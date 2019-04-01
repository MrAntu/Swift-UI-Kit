//
//  Router.swift
//  Route
//
//  Created by 鞠鹏 on 2018/6/5.
//  Copyright © 2018年 dd01. All rights reserved.
//

import UIKit

public enum RouterError: Int {
    case routeInvalid
    case route404
    case urlInvalid
    case url404
    case unmatch
    
    public static let domain = "RouterErrorDomain"
    
    func error() -> NSError {
        switch self {
        case .routeInvalid:
            return error(info: "Route illegal")
        case .route404:
            return error(info: "Route is illegal or not registration")
        case .urlInvalid:
            return error(info: "url invalid")
        case .url404:
            return error(info: "can not open")
        case .unmatch:
            return error(info: "No match for the results")
        }
    }
    
    func error(info: String) -> NSError {
        let error = NSError(domain: RouterError.domain, code: self.rawValue, userInfo: [NSLocalizedDescriptionKey: info])
        return error
    }
}

public enum Jump: Int {
    case push
    case present
}

public class Router: NSObject {
    
    public typealias Handler = ((RouterURL) -> UIViewController)
    public typealias Completion = (() -> Void)
    public static let shareInstance = Router()
    public var error: NSError?
    
    // 保存路由模块和模块跳转
    private var routerMap = [String: Handler]()
    
    // 获取所以注册路由
    public static func allRoutes() -> [String] {
        return Array(Router.shareInstance.routerMap.keys)
    }
    
    // MARK: - public
    
    /// 注册路由
    public static func register(route: String, handler:@escaping Handler) -> NSError? {
        return Router.shareInstance.add(route: route, handler: handler)
    }
    
    /// 注销路由
    public static func deRegister(route: String) {
        Router.shareInstance.remove(route: route)
    }
    
    // MARK: - private
    
    private func add(route: String, handler:@escaping Handler) -> NSError? {
        guard let route = RouterURL.route(urlStr: route)  else {
            return RouterError.routeInvalid.error()
        }
        guard URL(string: route) != nil else {
            return RouterError.routeInvalid.error()
        }
        routerMap.updateValue(handler, forKey: route)
        
        return nil
    }
    
    private func remove(route: String) {
        routerMap.removeValue(forKey: route)
    }
    
    private override init() {
    }
}

extension Router {
    
    /// push 模块和参数拼接在一起
    ///
    /// paramter: urlStr后面拼接了参数
    @discardableResult
    public static func push(urlStr: String, animated: Bool = true) -> Router {
        return open(urlStr: urlStr, animated: animated, jumpType: .push, completion: nil)
    }
    
    /// push 自定义参数
    ///
    /// paramter: route跳转的模块
    /// paramter: params
    @discardableResult
    public static func push(route: String, params: [String: String]?, animated: Bool = true) -> Router {
        return open(route: route, params: params, animated: animated, jumpType: .push, completion: nil)
    }
    
    /// present 模块和参数拼接在一起
    ///
    /// paramter: urlStr后面拼接了参数
    @discardableResult
    public static func present(urlStr: String, animated: Bool = true, completion: Completion?) -> Router {
        return open(urlStr: urlStr, animated: animated, jumpType: .present, completion: completion)
    }
    
    /// present 自定义参数
    ///
    /// paramter: route跳转的模块
    /// paramter: params
    @discardableResult
    public static func present(route: String, params: [String: String]?, animated: Bool = true, completion: Completion?) -> Router {
        return open(route: route, params: params, animated: animated, jumpType: .present, completion: completion)
    }
    
    static func open(urlStr: String, animated: Bool, jumpType: Jump, completion: Completion?) -> Router {
        let router = Router()
        guard !urlStr.isEmpty else {
            router.error = RouterError.urlInvalid.error()
            return router
        }
        
        guard let routerURL = RouterURL(urlStr: urlStr) else {
            router.error = RouterError.route404.error()
            return router
        }
        
        let params = routerURL.params as? [String: String]
        switch jumpType {
        case .push:
            return push(route: routerURL.route, params: params, animated: animated)
        case .present:
            return present(route: routerURL.route, params: params, animated: animated, completion: completion)
        }
    }
    
    static func open(route: String, params: [String: String]?, animated: Bool, jumpType: Jump, completion: Completion?) -> Router {
        let router = Router()
        
        guard let route = RouterURL.route(urlStr: route) else {
            router.error = RouterError.route404.error()
            return router
        }
        
        guard let handler = shareInstance.routerMap[route] else {
            router.error = RouterError.route404.error()
            return router
        }
        
        guard let routerURL = RouterURL(urlStr: route) else {
            router.error = RouterError.unmatch.error()
            return router
        }
        
        routerURL.params = params
        let viewController = handler(routerURL)
        switch jumpType {
        case .push:
            pushViewController(viewController: viewController, animated: animated)
            return router
        case .present:
            presentViewController(viewController: viewController, animated: animated, completion: completion)
            return router
        }
    }
}

extension Router {
    
    @discardableResult
    static func pushViewController(viewController: UIViewController, animated: Bool) -> UIViewController? {
        guard !viewController.isKind(of: UINavigationController.self) else {
            return nil
        }
        
        guard let navigationController = UIViewController.getTopViewController?.navigationController else {
            return nil
        }
        
        navigationController.pushViewController(viewController, animated: animated)
        return viewController
    }
    
    @discardableResult
    static func presentViewController(viewController: UIViewController, animated: Bool, completion: Completion?) -> UIViewController? {
        
        guard let fromViewController = UIViewController.getTopViewController else {
            return nil
        }
        
        fromViewController.present(viewController, animated: true, completion: completion)
        
        return viewController
    }
}
