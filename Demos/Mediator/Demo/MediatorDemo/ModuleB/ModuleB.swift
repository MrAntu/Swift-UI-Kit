//
//  Test.swift
//  MediatorDemo
//
//  Created by weiwei.li on 2019/3/19.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation

public class ModuleB: NSObject {
    @objc func test(_ pa: MediatorParamDic) -> String {
        let back = pa["back"] as? (String) -> ()
        back?("werwer")
        return "sdfsfsdfdf"
    }
}
