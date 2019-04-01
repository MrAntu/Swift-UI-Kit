//
//  CacheKey.swift
//  DDRequest
//
//  Created by jp on 2018/9/20.
//  Copyright © 2018年 dd01. All rights reserved.
//

import Cache
import Foundation

func cacheKey(_ url: String, _ params: [String: HTTPParam]?) -> String {

    guard let params = params else {
        return MD5(url)
    }
    
    if let stringData = try? JSONSerialization.data(withJSONObject: params, options: []),
        let paramString = String(data: stringData, encoding: String.Encoding.utf8) {
        let str = "\(url)" + "\(paramString)"
        return MD5(str)
    } else {
        return MD5(url)
    }
}
