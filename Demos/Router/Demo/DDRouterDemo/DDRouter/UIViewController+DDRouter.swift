//
//  UIViewController+DDRouter.swift
//  DDRouterDemo
//
//  Created by USER on 2018/12/5.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

// MARK: - 扩展UIViewController,给每个控制器绑定一个属性
extension UIViewController {
    // 嵌套结构体
    private struct  DDRouterAssociatedKeys {
        static var paramsKey = "DDRouterParameterKey"
        static var completeKey = "DDRouterComplete"
    }
    
    public var params: DDRouterParameter? {
        set {
            objc_setAssociatedObject(self, &DDRouterAssociatedKeys.paramsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &DDRouterAssociatedKeys.paramsKey) as? DDRouterParameter
        }
    }
    
    /// 添加回调闭包，适用于反向传值，只能层级传递
    public var complete: ((Any?)->())? {
        set {
            objc_setAssociatedObject(self, &DDRouterAssociatedKeys.completeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &DDRouterAssociatedKeys.completeKey) as? ((Any?) -> ())
            
        }
    }
    
    /// push  sb控制器
    ///
    /// - Parameters:
    ///   - sbName: storybord名字
    ///   - identifier: id
    ///   - params: 参数
    ///   - animated: 是否动画
    ///   - complete: 回调
    public func pushSBViewController(_ sbName: String,
                                   identifier: String? = nil,
                                   params: DDRouterParameter? = nil,
                                   animated: Bool = true,
                                   complete:((Any?)->())? = nil) {
        DDRouter.share.pushSBViewController(sbName, identifier: identifier, params: params, animated: animated, complete: complete)
    }

    /// present sb控制器
    ///
    /// - Parameters:
    ///   - sbName: storybord名字
    ///   - identifier: id
    ///   - params: 入参
    ///   - animated: 是否动画
    ///   - complete: 回调
    public func presentSBViewController(_ sbName: String,
                                      identifier: String? = nil,
                                      params: DDRouterParameter? = nil,
                                      animated: Bool = true,
                                      complete:((Any?)->())? = nil) {
        DDRouter.share.presentSBViewController(sbName, identifier: identifier, params: params, animated: animated, complete: complete)
    }
        
    
    /// 路由入口 push
    ///
    /// - Parameters:
    ///   - key: 定义的key
    ///   - params: 需要传递的参数
    ///   - parent: 是否是present显示
    ///   - animated: 是否需要动画
    ///   - complete: 上级控制器回调传值，只能层级传递
    public func pushViewController(_ key: String, params: DDRouterParameter? = nil, animated: Bool = true, complete:((Any?)->())? = nil) {
        DDRouter.share.pushViewController(key, params: params, animated: animated, complete: complete)
    }
    
    /// 路由入口 present
    ///
    /// - Parameters:
    ///   - key: 路由key
    ///   - params: 参数
    ///   - animated: 是否需要动画
    ///   - complete: 上级控制器回调传值，只能层级传递
    public func presentViewController(_ key: String, params: DDRouterParameter? = nil, animated: Bool = true, complete:((Any?)->())? = nil) {
        DDRouter.share.presentViewController(key, params: params, animated: animated, complete: complete)
    }
    
    /// 正常的pop操作
    ///
    /// - Parameters:
    ///   - vc: 当前控制器
    ///   - dismiss: true: dismiss退出，false: pop退出
    ///   - animated: 是否需要动画
    public func pop(animated: Bool = true) {
        DDRouter.share.pop(self, animated: animated)
    }
    
    /// pop到指定的控制器
    ///
    /// - Parameters:
    ///   - currentVC: 当前控制器
    ///   - toVC: 目标控制器对应的key
    ///   - animated: 是否需要动画
    public func pop(ToViewController toVC: String, animated: Bool = true) {
        DDRouter.share.pop(ToViewController: self, toVC: toVC, animated: animated)
    }
    
    /// pop到根目录
    ///
    /// - Parameters:
    ///   - currentVC: 当前控制器
    ///   - animated: 是否需要动画
    public func pop(ToRootViewController animated: Bool = true) {
        DDRouter.share.pop(ToRootViewController: self, animated: animated)
    }
    
    /// dismiss操作
    ///
    /// - Parameters:
    ///   - vc: 当前控制器
    ///   - animated: 是否需要动画
    public func dismiss(_ animated: Bool = true) {
        DDRouter.share.dismiss(self, animated: animated)
    }
}

