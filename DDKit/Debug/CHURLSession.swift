//
//  CHURLSession.swift
//  DDDebug
//
//  Created by shenzhen-dd01 on 2019/1/18.
//  Copyright © 2019 shenzhen-dd01. All rights reserved.
//

import UIKit

class CHURLSession: NSObject {
    static let shared = CHURLSession()
    private override init() {
        super.init()
    }
}

// MARK: - Notification

extension CHURLSession {
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(getRequestInfo), name: NSNotification.Name(rawValue: "NSURLSession_Hook_Request"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getResponseInfo), name: NSNotification.Name(rawValue: "NSURLSession_Hook_Response"), object: nil)
    }
    
    @objc func getRequestInfo(noti: Notification) {
        dealWithNotification(noti)
    }
    
    @objc func getResponseInfo(noti: Notification) {
        dealWithNotification(noti)
    }
    
    func dealWithNotification(_ noti: Notification) {
        guard let userInfo = noti.userInfo else {
            return
        }
    
        var session = SessionItem()
        if let method = userInfo["method"] as? String,
            let url = userInfo["url"] as? String,
            let headers = userInfo["headers"] as? [String: String],
            let parameters = userInfo["parameters"] as? [String: String] {
            
            session.method = method
            session.url = url
            session.headers = headers
            session.parameters = parameters
        }
        
        if let response = userInfo["response"] as? [String: Any] {
            session.response = response
            
            //判断是否是error
            var isError = false
            //if let code = response["code"] as? Int {
            //    isError = code == 0 ? false : true
            //}
            if let status = response["status"] as? Bool {
                isError = status ? false : true
            }
            
            session.isError = isError
        }
        
        DDDebug.log(with: session)
    }
}

struct SessionItem: DDRequstItemProtocol {
    var method: String?
    var url: String?
    var headers: [String : String]?
    var parameters: [String : String]?
    var response: [String : Any]?
    var isError: Bool?
}
