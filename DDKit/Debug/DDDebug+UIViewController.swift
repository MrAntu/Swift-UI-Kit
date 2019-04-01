//
//  DDDebug+UIViewController.swift
//  DDDebug
//
//  Created by shenzhen-dd01 on 2019/1/16.
//  Copyright © 2019 shenzhen-dd01. All rights reserved.
//

import Foundation

public extension UIViewController {
    
    /// 显示当前显示的控制器的名字
    public static func ch_swizzle() {
        UIViewController.swizzleViewWillAppear()
    }
}

// MARK: - Method Swizzling

extension UIViewController {
    
    private static func swizzleViewWillAppear() {
        guard self == UIViewController.self else { return }
        
        //巧妙的方法，使用匿名函数避免再次调用
        let _: () = {
            let originalSelector = #selector(UIViewController.viewWillAppear(_:))
            let swizzledSelector = #selector(UIViewController.debug_ViewWillAppear(_:))
            
            if let originalMethod = class_getInstanceMethod(self, originalSelector),
                let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }()
    }
    
    @objc private func debug_ViewWillAppear(_ animated: Bool) {
        debug_ViewWillAppear(animated)
        let currentvc = NSStringFromClass(type(of: self)).components(separatedBy: ".").last ?? "UIViewController"
        
        guard  currentvc != "UIViewController"
            && currentvc != "UIAlertController"
            && currentvc != "UIPageViewController"
            && currentvc != "SFSafariViewController"
            && currentvc != "UINavigationController"
            && currentvc != "UIInputWindowController"
            && currentvc != "SFBrowserRemoteViewController"
            && currentvc != "UISystemKeyboardDockController"
            && currentvc != "UICompatibilityInputViewController" else { return }
        
        print("【DDDebug】+++++++++++++【current viewController： \(currentvc) 】")
    }
}
