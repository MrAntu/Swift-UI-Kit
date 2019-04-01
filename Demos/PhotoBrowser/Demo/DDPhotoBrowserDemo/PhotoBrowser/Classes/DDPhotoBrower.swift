//
//  DDPhotoBrower.swift
//  DDPhotoBrowserDemo
//
//  Created by USER on 2018/11/22.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

public protocol DDPhotoBrowerDelegate: NSObjectProtocol {
    /// 索引值改变
    ///
    /// - Parameter index: 索引
    func photoBrowser(controller: UIViewController?, didChanged index: Int?)

    /// 单击事件，即将消失
    ///
    /// - Parameter index: 索引
    func photoBrowser(controller: UIViewController?, willDismiss index: Int?)

    /// 长按事件事件
    ///
    /// - Parameter index: 索引
    func photoBrowser(controller: UIViewController?, longPress index: Int?)
}

extension DDPhotoBrowerDelegate {
    func photoBrowser(controller: UIViewController?, didChanged index: Int?) {}
    func photoBrowser(controller: UIViewController?, willDismiss index: Int?) {}
    func photoBrowser(controller: UIViewController?, longPress index: Int?) {}
}

public class DDPhotoBrower: NSObject {
    
    /// 代理
    public weak var delegate: DDPhotoBrowerDelegate?
    /// 滑动消失时是否隐藏原来的视图
    public var isHideSourceView: Bool = false
    /// 长按是否自动保存图片到相册，若为true,则长按代理不在回调。若为false，返回长按代理
    public var isLongPressAutoSaveImageToAlbum: Bool = true
    
    /// 配置保存图片权限提示
    public var photoPermission: String = "请在iPhone的\"设置-隐私-照片\"选项中，允许访问您的照片"

    /// 是否需要显示状态栏，默认不显示
//    public var isShowStatusBar: Bool = false
   
    public var photos: [DDPhoto]?
    public var currentIndex: Int?
   
    public init(photos: [DDPhoto], currentIndex: Int) {
        super.init()
        self.photos = photos
        self.currentIndex = currentIndex
    }
}

extension DDPhotoBrower {
    
    public static func photoBrowser(Photos photos: [DDPhoto], currentIndex: Int) -> DDPhotoBrower {
        return DDPhotoBrower(photos: photos, currentIndex: currentIndex)
    }
    
    public func show() {
        let topController = getTopViewController
        let vc = DDPhotoBrowerController(Photos: photos, currentIndex: currentIndex)
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .custom
        vc.deleagte = delegate
        vc.isHideSourceView = isHideSourceView
        vc.isLongPressAutoSaveImageToAlbum = isLongPressAutoSaveImageToAlbum
        vc.photoPermission = photoPermission
        vc.previousStatusBarStyle = UIApplication.shared.statusBarStyle
        // 是否接管状态栏外观，即重写的 prefersStatusBarHidden 等方法是否会被调用
        vc.modalPresentationCapturesStatusBarAppearance = true
        topController?.present(vc, animated: false, completion: nil)
    }
}

private extension DDPhotoBrower {

    private var getTopViewController: UIViewController? {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        return getTopViewController(viewController: rootViewController)
    }
    
    private func getTopViewController(viewController: UIViewController?) -> UIViewController? {
        
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
