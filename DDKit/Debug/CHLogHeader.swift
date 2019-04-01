//
//  CHLogHeader.swift
//  CHLog
//
//  Created by wanggw on 2018/7/2.
//  Copyright © 2018年 UnionInfo. All rights reserved.
//

import UIKit

class CHLogHeader: UIView {
    private var titleLabel = UILabel()
    private var logInfo: CHLogItem?
    private var target: UIViewController?
    
    override var canBecomeFirstResponder: Bool {
        return true //最最最关键的代码。。。。。。。。
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        setupCopyMenu()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    private func setupUI() {
        backgroundColor = UIColor.white
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.isUserInteractionEnabled = true
        addSubview(titleLabel)
    }
    
    private func setupCopyMenu() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMenuAction)))
    }
    
    // MARK: - Action
    
    @objc private func showMenuAction() {
        if UIMenuController.shared.isMenuVisible {
            UIMenuController.shared.setMenuVisible(false, animated: true)
            return
        }
        
        becomeFirstResponder()
        let saveMenuItem = UIMenuItem(title: "拷贝请求参数", action: #selector(copyAction))
        UIMenuController.shared.menuItems = [saveMenuItem]
        UIMenuController.shared.setTargetRect(titleLabel.frame, in: self)
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }
    
    @objc private func copyAction() {
        UIPasteboard.general.string = logInfo?.describeString()

        let alert = UIAlertController(title: "提示", message: "已经拷贝至剪切板", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        target?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - updateContent
    
    public func updateContent(logInfo: CHLogItem, target: UIViewController) {
        self.logInfo = logInfo
        self.target = target
        
        backgroundColor = logInfo.isRequest ? UIColor.white : UIColor.black
        titleLabel.attributedText = logInfo.attributedDescribeString()
        titleLabel.frame = CGRect(x: 15, y: 5, width: self.bounds.size.width - 30, height: self.bounds.size.height - 10)
    }
}
