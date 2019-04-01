//
//  CHLogDetailViewController.swift
//  CHLog
//
//  Created by wanggw on 2018/6/30.
//  Copyright © 2018年 UnionInfo. All rights reserved.
//

private let CHLog_ScreenWidth    = UIScreen.main.bounds.size.width
private let CHLog_ScreenHeight   = UIScreen.main.bounds.size.height
private let CHLog_IS_iPhone_5_8_X      = (UIScreen.main.bounds.size.height == 812)
private let CHLog_Height_navigationBar = (CHLog_IS_iPhone_5_8_X ? CGFloat(88.0) : CGFloat(64.0)) /// 导航栏高度：64pt -> 88pt：iphoneX 增加24pt

class CHLogDetailViewController: UIViewController {
    private var searchBar: UISearchBar?
    private var textView: UITextView?
    private var response: CHLogItem?
    
    init(response: CHLogItem) {
        self.response = response
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupContent()
    }
}

// MARK: - SetupUI

extension CHLogDetailViewController {
    
    private func setupUI() {
        title = "接口请求返回详情"
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let closeButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action:  #selector(self.dismissAction))
        let copyButtonItem = UIBarButtonItem(title: "拷贝", style: .plain, target: self, action:  #selector(self.copyAction))
        navigationItem.rightBarButtonItems = [closeButtonItem, copyButtonItem] //倒序排序的
        
        setupSearchBar()
        initTextView()
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 49.5))
        if let searchBar = searchBar {
            view.addSubview(searchBar)
        }
        
        searchBar?.backgroundColor = UIColor.white
        searchBar?.delegate = self
        searchBar?.barStyle = .default
        searchBar?.placeholder = "输入字段进行搜索"
        searchBar?.searchBarStyle = .minimal
    }
    
    private func initTextView() {
        textView = UITextView(frame: CGRect(x: 0, y: 50, width: CHLog_ScreenWidth, height: (CHLog_ScreenHeight - CHLog_Height_navigationBar)))
        textView?.isEditable = false
        textView?.backgroundColor = UIColor.black
        textView?.font = UIFont.systemFont(ofSize: 12)
        if let textView = textView {
            view.addSubview(textView)
        }
    }
}

// MARK: - Actions

extension CHLogDetailViewController {
    
    private func setupContent() {
        textView?.text = response?.describeString()
        textView?.textColor = (response?.isRequestError ?? false) ? UIColor.red : UIColor.white
    }
    
    @objc private func dismissAction() {
        dismiss(animated: true) {
            CHLog.show()
        }
    }
    
    @objc private func copyAction() {
        UIPasteboard.general.string = response?.describeString()
        
        let alert = UIAlertController(title: "提示", message: "已经拷贝至剪切板", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func searchAction(key: String) {
        guard key.count > 0 else {
            setupContent()
            return
        }
    
        let baseString = response?.describeString()
        textView?.attributedText = generateAttributedString(with: key, targetString: baseString ?? "")
    }
    
    private func generateAttributedString(with searchTerm: String, targetString: String) -> NSAttributedString? {
        let attributedString = NSMutableAttributedString(string: targetString)
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 12), range: NSMakeRange(0, attributedString.length))
        let color = (response?.isRequestError ?? false) ? UIColor.red : UIColor.white
        attributedString.addAttribute(.foregroundColor, value: color, range: NSMakeRange(0, attributedString.length))
        
        do {
            let regex = try NSRegularExpression(pattern: searchTerm, options: .caseInsensitive)
            let range = NSRange(location: 0, length: targetString.utf16.count)
            for match in regex.matches(in: targetString, options: .withTransparentBounds, range: range) {
                attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: match.range)
                attributedString.addAttribute(.foregroundColor, value: UIColor.yellow, range: match.range)
            }
            return attributedString
        } catch _ {
            NSLog("Error creating regular expresion")
            return nil
        }
    }
}

// MARK: - UISearchBarDelegate

extension CHLogDetailViewController: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchAction(key: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        setupContent()
    }
}
