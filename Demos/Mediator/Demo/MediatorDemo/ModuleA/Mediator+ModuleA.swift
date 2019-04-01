//
//  Action+Home.swift
//  MediatorDemo
//
//  Created by weiwei.li on 2019/3/19.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation

extension Mediator {
    
    func getModuleBData() {
        let pa = Parameter.create().key("back").value({(res: String) in
            print(res)
        }).key("name").value("lisi")
        let action = Action.action(cls: "ModuleB", method: "test", parameters: pa)
        print(dispath(action))
    }
}
