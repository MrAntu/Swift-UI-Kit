//
//  ProgressHUD.swift
//  DDKit
//
//  Created by shenzhen-dd01 on 2018/12/29.
//  Copyright © 2018 dd01. All rights reserved.
//

import Foundation
import MBProgressHUD

public class ProgressHUD: NSObject {
    private var hud: MBProgressHUD?
    
    static let shared = ProgressHUD()
    private override init() {} // This prevents others from using the default '()' initializer for this class
}

// MARK: - Show In UIView
public extension ProgressHUD {
    
    /// 集成已有的库的API
    public class func show(base: UIView?,
                           title: String? = nil,
                           backgroundColor: UIColor? = nil) {
        ProgressHUD.dismiss()
        let hud = MBProgressHUD.show(base: base, title: title, mode: nil, backgroundColor: backgroundColor, style: nil)
        ProgressHUD.shared.hud = hud
    }
}

// MARK: - Show In UIViewController
public extension ProgressHUD {

    /// 试图控制器中显示加载框
    ///
    /// - Parameters:
    ///   - vc: 视图控制器
    ///   - status: 加载提示文本
    public class func show(vc: UIViewController, status: String = "") {
        ProgressHUD.dismiss()
        
        let hud = MBProgressHUD.showAdded(to: vc.view, animated: true)
        hud.label.text = status
        ProgressHUD.shared.hud = hud
    }
    
    /// 试图控制器中显示提示视图
    ///
    /// - Parameters:
    ///   - vc: 视图控制器
    ///   - info: 需要提示文字信息
    ///   - time: 显示时长，默认2秒
    public class func showInfo(vc: UIViewController, info: String, time: TimeInterval = 2.0) {
        ProgressHUD.dismiss()
        
        let hud = MBProgressHUD.showAdded(to: vc.view, animated: true)
        hud.mode = .text
        hud.label.text = info
        hud.hide(animated: true, afterDelay: time)
    }
}

// MARK: - Dismiss
public extension ProgressHUD {

    /// Hud消失方法
    public class func dismiss() {
        if let hud = ProgressHUD.shared.hud {
            hud.hide(animated: true)
            ProgressHUD.shared.hud = nil
        }
    }
}
