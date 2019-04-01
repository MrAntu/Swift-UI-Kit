//
//  DDDebug+URLSession.swift
//  DDDebug
//
//  Created by shenzhen-dd01 on 2019/1/17.
//  Copyright © 2019 shenzhen-dd01. All rights reserved.
//

import Foundation

public extension URLSession {
    
    /// 显示当前显示的控制器的名字
    public static func ch_swizzle() {
        URLSession.swizzleSession()
    }
}

extension URLSession {
    
    private static func swizzleSession() {
        guard self == UIViewController.self else { return }
        
        //巧妙的方法，使用匿名函数避免再次调用
        let _: () = { 
            //Swift 方式 Hook URLSession 代理方法
            // NSNotificationCenter @"NSURLSession_Hook_Request" get request info
            // NSNotificationCenter @"NSURLSession_Hook_Response" get response info
        }()
    }
}
