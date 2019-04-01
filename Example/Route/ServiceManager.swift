//
//  ServiceManager.swift
//  Route
//
//  Created by 鞠鹏 on 6/4/2018.
//  Copyright © 2018年 dd01. All rights reserved.
//

import UIKit

public class ServiceManager: NSObject {
    
    public static let shareInstance = ServiceManager()
    
    // serviceAPI (协议) 和 service (实现)
    var serviceMap: Dictionary = [String: Any]()
    
    private override init() {
    }
    
    /// 注册 serviceAPI 和 service
    public static func register(service: Any, serviceAPIName: String) {
        shareInstance.serviceMap.updateValue(service, forKey: serviceAPIName)
    }
    
    /// 通过协议获取Service
    ///
    /// - Parameter p: 协议名
    /// - Returns: 实现了此协议的Service实现
    func service<T>(_ apiName: T.Type = T.self) -> T? {
        let service = Array(ServiceManager.shareInstance.serviceMap.values).compactMap { item -> T? in
            item as? T
        }.first
        
        return service
    }
    
    /// 注册所有的 service
    ///
    /// 传入自定义 Dictionary
    public static func registerAll(serviceMap: [String: String]) {
        for (serviceAPI, serviceName) in serviceMap {
            let classStringName = serviceName
            let classType = NSClassFromString("Route" + "." + classStringName) as? NSObject.Type
            
            if let type = classType {
                
                let service = type.init()
                register(service: service, serviceAPIName: serviceAPI)
                
            }
        }
    }
    
    /// 注册所有的 service
    /// 默认 service.plist
    public static func registerAll() {
        let servicePlistPath = Bundle.main.path(forResource: "service", ofType: "plist")
        
        if let servicePlistPath = servicePlistPath {
            let map = NSDictionary(contentsOfFile: servicePlistPath)
            if let map = map as? [String: String] {
                registerAll(serviceMap: map)
            }
        }
        
    }
}

/// 通过协议获取Service
/// let api = API() as XxxAPI?
/// let api: XxxAPI? = API()
///
/// - Parameter p: 协议名，默认为类型自动推导的泛型类型
/// - Returns: 实现了此协议的Service实现
public func API<T>(_ apiName: T.Type = T.self) -> T? {
    return ServiceManager.shareInstance.service(apiName)
}
