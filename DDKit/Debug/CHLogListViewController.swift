//
//  CHLogListViewController.swift
//  CHLog
//
//  Created by wanggw on 2018/6/30.
//  Copyright © 2018年 UnionInfo. All rights reserved.
//

import UIKit

class CHLogListViewController: UIViewController {
    private var searchBar: UISearchBar?
    private var tableView: UITableView?
    
    private var dataSource: [CHLogItem] = []
    
    private var isSearch = false
    private var searchArray: [CHLogItem] = []

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //去掉返回按钮上的文字
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBarConfig()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupUI()
        setupCHLog()
        setupNavigationBar()
    }
    
    private func setupCHLog() {
        dataSource = CHLog.currentLogArray()
        tableView?.reloadData()
        
        CHLog.logInfoArrayChanged { (logArray) in
            self.dataSource.removeAll()
            self.dataSource = logArray
            if !self.isSearch {
                self.tableView?.reloadData()
            }
        }
    }
    
    // MARK: - SetupUI
    
    private func setupNavigationBar() {
        let rect = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 64)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor(red: 255/255.0, green: 127/255.0, blue: 80/255.0, alpha: 1.0).cgColor)
        context?.fill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
    }
    
    private func navigationBarConfig() {
        //设置标题颜色
        navigationController?.navigationBar.topItem?.title = "调试日志"
        //设置导航栏背景颜色
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255.0, green: 127/255.0, blue: 80/255.0, alpha: 1.0)
        //设置NagivationBar上按钮的颜色
        navigationController?.navigationBar.tintColor = UIColor.white
        //设置NavigationBar上的title的颜色以及属性
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func setupUI() {
        title = "调试日志"
        view.backgroundColor = UIColor.groupTableViewBackground
        navigationController?.navigationBar.isTranslucent = false
        
        initRightNavButton()
        setupSearchBar()
        setupTableView()
    }
    
    private func initRightNavButton() {
        let alertButtonItem = UIBarButtonItem(title: "提示", style: .plain, target: self, action:  #selector(self.alertAction))
        navigationItem.leftBarButtonItem = alertButtonItem
        
        let closeButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action:  #selector(self.dismissAction))
        let cleanButtonItem = UIBarButtonItem(title: "清屏", style: .plain, target: self, action:  #selector(self.cleanAction))
        navigationItem.rightBarButtonItems = [closeButtonItem, cleanButtonItem] //倒序排序的
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 49.5))
        if let searchBar = searchBar {
            view.addSubview(searchBar)
        }
    
        searchBar?.backgroundColor = UIColor.white
        searchBar?.barStyle = .default
        searchBar?.placeholder = "输入path进行搜索"
        searchBar?.searchBarStyle = .minimal
        searchBar?.delegate = self
    }
    
    private func setupTableView() {
        let bottomSpace = ((UIScreen.main.bounds.size.height==812) ? 88 : 64)
        tableView = UITableView(frame: CGRect(x: 0, y: 50, width: view.bounds.width, height: view.bounds.height - CGFloat(bottomSpace) - 50), style: .grouped)
        if let tableView = tableView {
            view.addSubview(tableView)
        }
        
        tableView?.delegate = self as UITableViewDelegate
        tableView?.dataSource = self as UITableViewDataSource
        tableView?.backgroundColor = UIColor.groupTableViewBackground
        tableView?.keyboardDismissMode = .onDrag        //滑动隐藏键盘
        tableView?.showsVerticalScrollIndicator = true  //显示滚动线
        tableView?.separatorStyle = .singleLine         //分割线
        tableView?.tableFooterView = UIView.init()      //去掉多余的分割线
        
        //处理分割线前面 15px，下面👇两个一起才能去掉 tableView 分割线前面的 15px：cell 也要进行这样的写法才能去掉
        if (tableView?.responds(to: #selector(setter: UITableView.layoutMargins)) ?? false) {
            tableView?.layoutMargins = UIEdgeInsets.zero
        }
        if (tableView?.responds(to: #selector(setter: UITableView.separatorInset)) ?? false) {
            tableView?.separatorInset = UIEdgeInsets.zero
        }
        
        tableView?.register(CHLogListCell.self, forCellReuseIdentifier: "CHLogListCell")
        
        
        //给出傻瓜式的提示，不是所有人都明白操作流程
        let height = CGFloat((UIScreen.main.bounds.size.height==568) ? 30 : 44)
        let noteHeader = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: height))
        noteHeader.font = UIFont.systemFont(ofSize: 12)
        noteHeader.text = "Tips：点击出错的请求接口并拷贝发送给后台人员，可以快速排查问题"
        noteHeader.textColor = UIColor.red
        noteHeader.textAlignment = .center
        noteHeader.backgroundColor = UIColor.groupTableViewBackground
        //noteHeader.sizeToFit()//这个方法的效果是，让高度紧贴文字高度😂
        noteHeader.adjustsFontSizeToFitWidth = true//字体适应大小
        tableView?.tableHeaderView = noteHeader
    }
}

// MARK: - Actions

extension CHLogListViewController {
    
    @objc private func alertAction() {
        let alert = UIAlertController(title: "提示", message: "单击接口请求列表，就可以拷贝请求参数信息至剪切板", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func dismissAction() {
        dismiss(animated: true) {
            CHLog.show()
        }
    }
    
    @objc private func cleanAction() {
        CHLog.clean()
    }
    
    private func searchAction(key: String) {
        searchArray.removeAll()
        dataSource.forEach { (logInfo) in
            if logInfo.requstFullUrl.contains(key) {
                searchArray.append(logInfo)
            }
        }
        tableView?.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension CHLogListViewController: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        isSearch = true
        tableView?.reloadData()
    }
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchAction(key: searchText)
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        isSearch = false
        tableView?.reloadData()
    }
}

// MARK: -

extension CHLogListViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar?.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension CHLogListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearch ? searchArray.count : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearch ? searchArray[section].responses.count : dataSource[section].responses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let response = isSearch ? searchArray[indexPath.section].responses[indexPath.row] : dataSource[indexPath.section].responses[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CHLogListCell", for: indexPath as IndexPath) as? CHLogListCell {
            cell.updateContent(response: response)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let height = isSearch ? searchArray[section].cellRowHeigt() + 10 : dataSource[section].cellRowHeigt() + 10
        let logInfo = isSearch ? searchArray[section] : dataSource[section]
        
        let head = CHLogHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height))
        head.updateContent(logInfo: logInfo, target: self)
        return head
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = isSearch ? searchArray[section].cellRowHeigt() + 10 : dataSource[section].cellRowHeigt() + 10
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.groupTableViewBackground
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let response = isSearch ? searchArray[indexPath.section].responses[indexPath.row] : dataSource[indexPath.section].responses[indexPath.row]
        let vc = CHLogDetailViewController(response: response)
        navigationController?.pushViewController(vc, animated: true)
    }
}
