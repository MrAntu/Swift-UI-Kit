//
//  Assert.swift
//  AssertDemo
//
//  Created by weiwei.li on 2019/1/24.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

public class DDAssert: NSObject {
    public class func ddAssert(_ condition: Bool, _ message: String, file: StaticString = #file, line: UInt = #line) {
        #if DEBUG
            assert(condition, message, file: file, line: line)
        #else
        // TODO: - 后面会上传日志系统
           // print(message)
        #endif
        
    }
}

extension NSObject {
    public func Assert(_ condition: Bool, _ message: String, file: StaticString = #file, line: UInt = #line) {
        DDAssert.ddAssert(condition, message, file: file, line: line)
    }
}
