//
//  AccountModule.swift
//  Route
//
//  Created by 鞠鹏 on 2018/6/11.
//  Copyright © 2018年 dd01. All rights reserved.
//

import UIKit

public protocol AccountServiceAPI {
    func login(userName: String, passWord: String, complete: ((NSError?) -> Void))
    func logout()
    func register(userName: String, passWord: String, verifyCode: String, complete: ((NSError?) -> Void))
}

class AccountService: NSObject, AccountServiceAPI {
    func login(userName: String, passWord: String, complete: ((NSError?) -> Void)) {
        print(".........login")
    }
    
    func logout() {
        print("=========logout")
    }
    
    func register(userName: String, passWord: String, verifyCode: String, complete: ((NSError?) -> Void)) {
        print("-----------register")
    }
}
