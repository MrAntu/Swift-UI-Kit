
//
//  DDMediator.swift
//  DDMediatorDemo
//
//  Created by USER on 2018/12/5.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

/// 若调用sdk中的模块，或者pod管理的模块，需要传入模块名，swift中存在命名空间
public let kMediatorTargetModuleName = "kMediatorTargetModuleName"

//定义两个类型
public typealias MediatorParamDic = [String: Any]
public typealias MediatorCallBack = (Any?) -> ()

public class DDMediator: NSObject {
    /// 单列
    public static let shared = DDMediator()
    
    /// 服务模块对象的开头字符串命名，默认 "Target"开头
    public var moduleName: String = "Target"
    
    //初始化缓存
    private var cacheTarget = [String: NSObject]()
}

extension DDMediator {
    
    /// perform
    ///
    /// - Parameters:
    ///   - targetName: 对应的target名字
    ///   - actionName: target中的方法名
    ///   - params: 传入的参数
    ///   - isCacheTarget: 是否需要缓存Target对象，多次调用只需要初始化一个对象
    ///   - complete: 完成回调
    public func perform(Target targetName: String, actionName: String, params: MediatorParamDic?, isCacheTarget: Bool = true, complete: MediatorCallBack?) {
        /// 获取targetClass字符串
        let swiftModuleName = params?[kMediatorTargetModuleName] as? String
        var targetClassString: String?
        if (swiftModuleName?.count ?? 0) > 0 {
            targetClassString = (swiftModuleName ?? "") + "." + "Target_\(targetName)"
        } else {
            let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            targetClassString = namespace + "." + "\(moduleName)_\(targetName)"
        }
        
        guard let classString = targetClassString  else {
            return
        }
        
        var target = cacheTarget[classString]
        var targetClass: NSObject.Type
        if target == nil {
            //获取Target对象
            targetClass = NSClassFromString(classString) as! NSObject.Type
            target = targetClass.init()
            //缓存target
            if isCacheTarget == true {
                if let obj = target {
                    cacheTarget[classString] = obj
                }
            }
        }
        
        //获取Target对象中的方法Selector
        let sel = Selector(actionName)
        
        //定义回调block
        let result: MediatorCallBack = { res in
            complete?(res)
        }
        
        //创建参数model
        let model = MediatorParams()
        model.callBack = result
        model.params = params
        if target?.responds(to: sel) == true {
            target?.perform(sel, with: model)
        }
        
        return
    }
}
