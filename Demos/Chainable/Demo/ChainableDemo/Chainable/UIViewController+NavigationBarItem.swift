//
//  UIViewController+NavigationBarItem.swift
//  CoreDemo
//
//  Created by USER on 2018/12/21.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

// MARK: - 改变导航栏透明色
extension UIViewController {

    /// 改变导航栏透明度
    ///
    /// - Parameters:
    ///   - alpha: 透明值
    ///   - backgroundColor: 非透明时背景颜色
    ///   - shadowColor: 非透明是shadow阴影颜色
    public func changeNavBackgroundImageWithAlpha(alpha: CGFloat, backgroundColor: UIColor = .white, shadowColor: UIColor =  #colorLiteral(red: 0.9311618209, green: 0.9279686809, blue: 0.9307579994, alpha: 1)) {
        var value = alpha >= 1 ? 1 : alpha
        value = value >= 0 ? value : 0
        let color = backgroundColor.withAlphaComponent(alpha)
        let image = UIColor.imageFromColor(color: color)
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        if alpha > 0.5 {
            let shadowImage = UIColor.imageFromColor(color: shadowColor)
            navigationController?.navigationBar.shadowImage = shadowImage
        } else {
            navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
}

extension UIViewController {
    
    /// 添加右边带文字的ButtonItem
    ///
    /// - Parameters:
    ///   - title: item的标题
    ///   - actionBlock: 点击事件回调
    /// - Returns: 按钮
    @discardableResult public func setRightButtonItem(title: String, actionBlock: ((UIButton) -> Void)?) -> UIButton {
        return setRightButtonItem(frame: CGRect(x: 0, y: 0, width: 70, height: 44), title: title, image: nil, actionBlock: actionBlock)
    }
    
    /// 添加右边带图片的ButtonItem
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - actionBlock: 点击事件回调
    /// - Returns: 按钮
    @discardableResult public func setRightButtonItem(image: UIImage?, actionBlock: ((UIButton) -> Void)?) -> UIButton {
        return setRightButtonItem(frame: CGRect(x: 0, y: 12, width: 15, height: 20), title: nil, image: image, actionBlock: actionBlock)

    }
    
    /// 添加自定义view的ButtonItem
    ///
    /// - Parameters:
    ///   - customView: 自定义view
    ///   - actionBlock: 点击事件回调
    public func setRightButtonItem(customView: UIView, actionBlock: ((UIView, UITapGestureRecognizer) -> Void)?)  {
        customView.tap { (custom, tap) in
            actionBlock?(custom,tap)
        }
        
        let rightButtonItem = UIBarButtonItem(customView: customView)
        navigationController?.topViewController?.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    
    /// 添加右边带标题数组的ButtonItem
    ///
    /// - Parameters:
    ///   - titles: 标题数组
    ///   - actionBlock: 点击事件回调，多个按钮，通过tag区分
    public func setRightButtonItem(titles: [String], actionBlock: ((UIButton) -> Void)?) {
        assert(titles.count > 0, "请传入非空的标题数组")
        
        var items: [UIBarButtonItem] = [UIBarButtonItem]()
        for (index, title) in titles.enumerated() {
            let titleStr: NSString = title as NSString
            
            let titleSize = titleStr.boundingRect(with: CGSize(width: 200, height: 44), options: .usesFontLeading, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)], context: nil).size
            
            let btn = buttomItem(frame: CGRect(x: 0, y: 0, width: titleSize.width, height: titleSize.height), title: title, image: nil)
            btn.press { (btn) in
                actionBlock?(btn)
            }
            btn.tag = index
            let rightButtonItem = UIBarButtonItem(customView: btn)
            items.append(rightButtonItem)
//            
//            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//            negativeSpacer.width = 10
//            items.append(negativeSpacer)
        }
        navigationController?.topViewController?.navigationItem.rightBarButtonItems = items
    }
    
    /// 添加右边带图片数组的ButtonItem
    ///
    /// - Parameters:
    ///   - images: 图片数组
    ///   - actionBlock: 点击回调
    public func setRightButtonItem(images: [UIImage?], actionBlock: ((UIButton) -> Void)?) {
        assert(images.count > 0, "请传入非空的标题数组")
        
        var items: [UIBarButtonItem] = [UIBarButtonItem]()
        for (index, image) in images.enumerated() {
            let btn = buttomItem(frame: CGRect(x: 0, y: 12, width: 15, height: 20), title: nil, image: image)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
            btn.tag = index
            btn.press { (sender) in
                actionBlock?(sender)
            }
            let rightButtonItem = UIBarButtonItem(customView: btn)
            items.append(rightButtonItem)
            
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            negativeSpacer.width = 10
            items.append(negativeSpacer)
        }
        navigationController?.topViewController?.navigationItem.rightBarButtonItems = items
    }
    
    /// 添加左边带标题的ButtonItem
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - actionBlock: 点击回调
    /// - Returns: 左边按钮
    @discardableResult public func setLeftButtonItem(title: String, actionBlock: ((UIButton) -> Void)?) -> UIButton {
        let leftBtn = buttomItem(frame: CGRect(x: 0, y: 0, width: 44, height: 44), title: title, image: nil)
        leftBtn.contentHorizontalAlignment = .left
        leftBtn.press { (btn) in
            actionBlock?(btn)
        }
        let leftBtnItem = UIBarButtonItem(customView: leftBtn)
        navigationController?.topViewController?.navigationItem.leftBarButtonItem = leftBtnItem
        return leftBtn
    }
    
    /// 添加左边带图片的ButtonItem
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - actionBlock: 点击回调
    /// - Returns: 左边按钮
    @discardableResult public func setLeftButtonItem(image: UIImage?, actionBlock: ((UIButton) -> Void)?) -> UIButton {
        let leftBtn = buttomItem(frame: CGRect(x: 0, y: 12, width: 20, height: 20), title: nil, image: image)
        leftBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        leftBtn.press { (btn) in
            actionBlock?(btn)
        }
        let leftButtonItem = UIBarButtonItem(customView: leftBtn)
        navigationController?.topViewController?.navigationItem.leftBarButtonItem = leftButtonItem
        return leftBtn
    }
    
    /// 添加左边带图片数组的ButtonItem
    ///
    /// - Parameters:
    ///   - images: 图片数组
    ///   - actionBlock: 点击回调
    public func setLeftButtonItem(images: [UIImage?], actionBlock: ((UIButton) -> Void)?) {
        var items: [UIBarButtonItem] = [UIBarButtonItem]()
        for (index, image) in images.enumerated() {
            let btn = buttomItem(frame: CGRect(x: 0, y: 12, width: 15, height: 20), title: nil, image: image)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
            btn.tag = index
            btn.press { (sender) in
                actionBlock?(sender)
            }
            let rightButtonItem = UIBarButtonItem(customView: btn)
            items.append(rightButtonItem)
            
//            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//            negativeSpacer.width = 10
//            items.append(negativeSpacer)
        }
        navigationController?.topViewController?.navigationItem.leftBarButtonItems = items
    }
    
    /// 添加左边带标题数组的ButtonItem
    ///
    /// - Parameters:
    ///   - titles: 标题数组
    ///   - actionBlock: 点击事件回调，多个按钮，通过tag区分
    public func setLeftButtonItem(titles: [String], actionBlock: ((UIButton) -> Void)?) {
        assert(titles.count > 0, "请传入非空的标题数组")
        
        var items: [UIBarButtonItem] = [UIBarButtonItem]()
        for (index, title) in titles.enumerated() {
            let titleStr: NSString = title as NSString
            
            let titleSize = titleStr.boundingRect(with: CGSize(width: 200, height: 44), options: .usesFontLeading, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)], context: nil).size
            
            let btn = buttomItem(frame: CGRect(x: 0, y: 0, width: titleSize.width, height: titleSize.height), title: title, image: nil)
            btn.press { (btn) in
                actionBlock?(btn)
            }
            btn.tag = index
            let rightButtonItem = UIBarButtonItem(customView: btn)
            items.append(rightButtonItem)
            
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            negativeSpacer.width = 10
            items.append(negativeSpacer)
        }
        navigationController?.topViewController?.navigationItem.leftBarButtonItems = items
    }
    
    /// 添加自定义view的ButtonItem
    ///
    /// - Parameters:
    ///   - customView: 自定义view
    ///   - actionBlock: 点击事件回调
    public func setLeftButtonItem(customView: UIView, actionBlock: ((UIView, UITapGestureRecognizer) -> Void)?)  {
        customView.tap { (custom, tap) in
            actionBlock?(custom,tap)
        }
        
        let leftBarButtonItem = UIBarButtonItem(customView: customView)
        //        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        //        negativeSpacer.width = -4
        //        navigationController?.topViewController?.navigationItem.rightBarButtonItems = [negativeSpacer, rightButtonItem]
        navigationController?.topViewController?.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
}

extension UIViewController {
    fileprivate func setRightButtonItem(frame: CGRect, title: String?, image: UIImage?, actionBlock:((UIButton) -> Void)?) -> UIButton {
        let rightBtn = buttomItem(frame: frame, title: title, image: image)
        if image != nil {
            rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        }
        rightBtn.press { (btn) in
            actionBlock?(btn)
        }
        
        let rightButtonItem = UIBarButtonItem(customView: rightBtn)
        //        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        //        negativeSpacer.width = -4
        //        navigationController?.topViewController?.navigationItem.rightBarButtonItems = [negativeSpacer, rightButtonItem]
        navigationController?.topViewController?.navigationItem.rightBarButtonItem = rightButtonItem
        
        return rightBtn
    }
    
    fileprivate func buttomItem(frame: CGRect, title: String?, image: UIImage?) -> UIButton {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.clear
        btn.frame = frame
        if let title = title {
            btn.contentHorizontalAlignment = .right
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.setTitle(title, for: .normal)
        }
        
        if let image = image {
//            btn.setBackgroundImage(image, for: .normal)
            btn.setImage(image, for: .normal)
        }
        
        return btn
    }
}

