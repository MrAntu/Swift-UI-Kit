//
//  Request+User.swift
//  Example
//
//  Created by senyuhao on 2018/7/11.
//  Copyright © 2018年 dd01. All rights reserved.
//

import Alamofire
import CryptoSwift
import Foundation
import PromiseKit
import DDKit

struct StoreStatus: Codable {
    var status: Int
    
    private enum CodingKeys: String, CodingKey {
        case status = "operating_status"
    }
}

struct ResponseVersion: Decodable {
    let code: Int
    let message: String?
    let data: Version?
}

struct Version: Codable {
    var version: String?
    var desc: String?
    var source: String?
    var type: Int? // 1：普通升级，2：强制升级
    
    private enum CodingKeys: String, CodingKey {
        case version
        case desc
        case source
        case type
    }
}

struct EBDefaultInfo: Codable { }

struct ResponseInter<T>: Decodable where T: Codable {
    let status: Bool
    let code: Int
    let message: String?
    let data: T?
}

struct Session: Codable {
    var id: Int
    var time: Int
    var token: String
    var reset: Int

    private enum CodingKeys: String, CodingKey {
        case id = "vendor_id"
        case token = "vendor_token"
        case time
        case reset
    }
}

extension DDRequest {
    static func login(mobile: String, password: String, previous: @escaping(ResponseInter<Session>) -> Void) -> Promise<ResponseInter<Session>> {
        let params = [
            "account": mobile,
            "password": password.md5()
        ]
        return DDRequest.post(path: "vendor/login", params: params, cache: true, previous: previous)
    }

    static func loginBlock(mobile: String, password: String, handler: @escaping(ResponseInter<Session>?, Error?) -> Void) {
        let params = [
            "account": mobile,
            "password": password.md5()
        ]
        DDRequest.post(path: "vendor/login", params: params, cache: true) { value, error in
            handler(value, error)
        }
    }
    
}

class Tool: NSObject {
    public static let shared = Tool()
    
    public class func storeLatestCookie(token: String) {
        UserDefaults.standard.set(token, forKey: "Cookie")
    }
    
    class func useLatestCookies() -> HTTPHeaders? {
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        if let cookinfo = UserDefaults.standard.value(forKey: "Cookie") as? String {
            defaultHeaders["Cookie"] = cookinfo
        }
        print("headers = \(defaultHeaders)")
        return defaultHeaders
    }
    
    @objc public func needLogin() {
        print("123")
    }
    
    @objc public func upgradeValue(_ value: Data) {
        let decoder = DDKit.JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let resp = try? decoder.decode(ResponseVersion.self, from: value)
        if let data = resp?.data {
            print(data)
        }
    }
}
