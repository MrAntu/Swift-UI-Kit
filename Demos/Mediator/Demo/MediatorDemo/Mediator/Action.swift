//
//  Action.swift
//  MediatorDemo
//
//  Created by weiwei.li on 2019/3/19.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation

public class Action {
    var method = ""
    var cls = ""
    var parameters: Parameter?
}

public extension Action {
    static func action(cls: String, method mtd: String, parameters pa: Parameter?) -> Action {
        if cls.isEmpty {
            assert(false, "Action----class名不能为空")
        }
        if cls.isEmpty {
            assert(false, "Action----method名不能为空")
        }
        let act = Action()
        act.cls = cls
        act.method = mtd
        act.parameters = pa
        return act
    }
}
