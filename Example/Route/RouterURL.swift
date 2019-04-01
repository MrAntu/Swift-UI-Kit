//
//  RouterURL.swift
//  Route
//
//  Created by 鞠鹏 on 2018/6/5.
//  Copyright © 2018年 dd01. All rights reserved.
//

import UIKit

public class RouterURL: NSObject {
    /// 使用的URL 格式 scheme://module/page?param1=xxx&param2=xxx
    
    public var route: String
    ///保存param
    public var params: [String: Any]?
    
    public init?(route: String, urlStr: String) {
        
        guard URL(string: route) != nil else {
            return nil
        }
        
        guard let routeOfUrlStr = RouterURL.route(urlStr: urlStr)  else {
            return nil
        }
        
        guard routeOfUrlStr == route else {
            return nil
        }
        
        self.route = route
        self.params = RouterURL.params(urlStr: urlStr)
    }
    
    public convenience init?(urlStr: String) {
        guard let route = RouterURL.route(urlStr: urlStr) else {
            return nil
        }
        
        self.init(route: route, urlStr: urlStr)
    }
    
    /// url 路由解析
    ///
    /// param url: string
    /// return: 路由模版
    public static func route(urlStr: String) -> String? {
        guard let url = URL(string: urlStr) else {
            return nil
        }
        let query = url.query ?? ""
        var route = urlStr.replacingOccurrences(of: query, with: "")
        route = route.replacingOccurrences(of: "?", with: "")
        if route.hasSuffix("/") {
            var characterSet = CharacterSet()
            characterSet.insert(charactersIn: "/")
            route = route.trimmingCharacters(in: characterSet)
        }
        return route
    }
    
    /// url 解析
    ///
    /// param url: string
    /// return: params
    public static func params(urlStr: String) -> [String: String]? {
        let url = URL(string: urlStr)
        guard let query = url?.query else {
            return nil
        }
        var params = [String: String]()
        let sections = query.components(separatedBy: "&")
        sections.forEach {
            guard let separatorIndex = $0.index(of: "=") else {
                return
            }
            let keyRange = $0.startIndex..<separatorIndex
            let valueRange = $0.index(after: separatorIndex)..<$0.endIndex
            let key = String($0[keyRange])
            let value = $0[valueRange].removingPercentEncoding ?? String($0[valueRange])
            params[key] = value
        }
        
        return params
    }
}
