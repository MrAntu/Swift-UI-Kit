//
//  DDMediator.swift
//  MediatorDemo
//
//  Created by weiwei.li on 2019/3/19.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
//定义类型
public typealias MediatorParamDic = [String: Any]

public class Mediator {
    
}

public extension Mediator {
    public func dispath(_ action: Action) -> Any? {
        if  action.cls.isEmpty {
            assert(false, "Action----class名不能为空")
        }
        
        if action.method.isEmpty {
            assert(false, "Action----method名不能为空")
        }
        return className(action.cls, method: action.method, parameters: action.parameters?.chainDic)
    }
}

private extension Mediator {
    func className(_ clsName: String, method mtd: String, parameters pa: MediatorParamDic?) -> Any? {
        /// 获取targetClass字符串
        let swiftModuleName = pa?[kMediatorTargetModuleName] as? String
        var targetClassString: String?
        if swiftModuleName?.isEmpty == false {
            targetClassString = (swiftModuleName ?? "") + "." + clsName
        } else {
            let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String
            targetClassString = (namespace ?? "") + "." + clsName
        }
        
        guard let classString = targetClassString  else {
            assert(false, "获取targetClassString失败")
            return nil
        }
        
        //获取Target对象
        let targetClass = NSClassFromString(classString) as! NSObject.Type
        let target = targetClass.init()
    
        //获取methodName
        let methodName = mtd + ":"
        //获取Selector
        let sel = Selector(methodName)
        //带参数判断
        if target.responds(to: sel) == true {
           let unmanaged = target.perform(sel, with: pa ?? MediatorParamDic())
            let res = unmanaged?.takeRetainedValue()
            unmanaged?.release()
            return res
        }
    
        //不带参数判断
        if target.responds(to: Selector(mtd)) == true {
            let unmanaged = target.perform(Selector(mtd))
            let res = unmanaged?.takeRetainedValue()
            unmanaged?.release()
            return res
        }
        
        return nil
    
    }
}
