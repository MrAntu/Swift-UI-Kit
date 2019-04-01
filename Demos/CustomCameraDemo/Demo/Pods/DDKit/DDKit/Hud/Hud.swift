//
//  Hud.swift
//  Hud
//
//  Created by senyuhao on 2018/7/17.
//  Copyright © 2018年 dd01. All rights reserved.
//

import Foundation
import MBProgressHUD

extension MBProgressHUD {

   @discardableResult public class func show(base: UIView?,
                           title: String? = nil,
                           mode: MBProgressHUDMode? = nil,
                           backgroundColor: UIColor? = nil,
                           style: MBProgressHUDBackgroundStyle? = nil) -> MBProgressHUD? {
        let container = base ?? UIApplication.shared.keyWindow
        if let container = container as? UIScrollView {
            container.isScrollEnabled = false
        }
        if let container = container {
            let hud = MBProgressHUD.showAdded(to: container, animated: true)
            if let mode = mode {
                hud.mode = mode
            }
            if let title = title {
                hud.label.text = title
            }
            if let style = style {
                hud.bezelView.style = style
            }
            if let backgroundColor = backgroundColor {
                hud.bezelView.backgroundColor = backgroundColor
            }
            hud.button.isHidden = true
            hud.show(animated: true)
            return hud
        }
        return nil
    }

    // 适用情况：界面加载中，loading提示在其他区域，当前页面不能进行任何操作
    public class func showNone(base: UIView?) {
        let container = base ?? UIApplication.shared.keyWindow
        if let container = container as? UIScrollView {
            container.isScrollEnabled = false
        }
        if let container = container {
            let hud = MBProgressHUD.showAdded(to: container, animated: true)
            hud.bezelView.style = .solidColor
            hud.bezelView.backgroundColor = .clear
            hud.customView = UIView(frame: .zero)
            hud.mode = .customView
            hud.show(animated: true)
        }
    }

    /// 隐藏Hud
    ///
    /// - Parameter base: containerView
    public class func hidden(base: UIView?) {
        let container = base ?? UIApplication.shared.keyWindow
        if let container = container as? UIScrollView {
            container.isScrollEnabled = true
        }
        if let container = container {
            for item in container.subviews where item is MBProgressHUD {
                item.isHidden = true
                let value = item as? MBProgressHUD
                value?.hide(animated: true)
            }
        }
    }
}

extension UIView {
    
    @discardableResult public func showHud(title: String? = nil,
                                              mode: MBProgressHUDMode? = nil,
                                              backgroundColor: UIColor? = nil,
                                              style: MBProgressHUDBackgroundStyle? = nil) -> MBProgressHUD? {
        return MBProgressHUD.show(base: self, title: title, mode: mode, backgroundColor: backgroundColor, style: style)
        
    }
    
    // 适用情况：界面加载中，loading提示在其他区域，当前页面不能进行任何操作
    public func showHudNone() {
        MBProgressHUD.showNone(base: self)
    }
    
    /// 隐藏Hud
    ///
    /// - Parameter base: containerView
    public func hiddenHud() {
        MBProgressHUD.hidden(base: self)
    }
}
