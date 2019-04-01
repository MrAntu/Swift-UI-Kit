//
//  NSObject+TopViewController.swift
//  DDKit
//
//  Created by USER on 2018/12/21.
//  Copyright © 2018 dd01. All rights reserved.
//

import UIKit

extension UIViewController {
    public class var getTopViewController: UIViewController? {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        return getTopViewController(viewController: rootViewController)
    }
    
    public class func getTopViewController(viewController: UIViewController?) -> UIViewController? {
        
        if let presentedViewController = viewController?.presentedViewController {
            return getTopViewController(viewController: presentedViewController)
        }
        
        if let tabBarController = viewController as? UITabBarController,
            let selectViewController = tabBarController.selectedViewController {
            return getTopViewController(viewController: selectViewController)
        }
        
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return getTopViewController(viewController: visibleViewController)
        }
        
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return getTopViewController(viewController: pageViewController.viewControllers?.first)
        }
        
        for subView in viewController?.view.subviews ?? [] {
            if let childViewController = subView.next as? UIViewController {
                return getTopViewController(viewController: childViewController)
            }
        }
        return viewController
    }
}
