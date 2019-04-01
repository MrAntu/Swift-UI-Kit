//
//  Action.swift
//  MediatorDemo
//
//  Created by weiwei.li on 2019/3/19.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation

/// 若调用sdk中的模块，或者pod管理的模块，需要传入模块名，swift中存在命名空间
public let kMediatorTargetModuleName = "kMediatorTargetModuleName"

public class Parameter {
    var chainDic = [String: Any]()
    private var chainCurrentKey: String = ""
}

public extension Parameter {
    //初始化
    static func create() -> Parameter {
        return Parameter()
    }
    
    //设置key值
    func key(_ pKey: String) -> Parameter {
        chainCurrentKey = pKey
        return self
    }
    
    //设置value
    func value(_ pValue: Any) -> Parameter {
        if chainCurrentKey.isEmpty {
            assert(false, "Parameter----请先设置key再设置value")
        }
        chainDic[chainCurrentKey] = pValue
        return self
    }
    
    /// 若调用sdk中的模块，或者pod管理的模块，需要传入模块名，swift中存在命名空间
    // ps: DDKit -> "DDKit"
    func addModule(_ value: String) -> Parameter {
        chainDic[kMediatorTargetModuleName] = value
        return self
    }
    
}
