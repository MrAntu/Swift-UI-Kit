
//
//  CHLogItem.swift
//  CHLog
//
//  Created by wanggw on 2018/6/30.
//  Copyright © 2018年 UnionInfo. All rights reserved.
//

import UIKit

public class CHLogItem: NSObject {
    var logTime: String = ""                //日志时间
    
    var logInfo: String = ""                //日志内容
    var isError: Bool = false               //是否是错误信息
    
    var isRequest: Bool = true              //是否是网络请求
    var isRequestError: Bool = false        //是否是请求失败

    var requstType: String = ""             //请求类型
    var requstBaseUrl: String = ""          //请求地址
    var requstFullUrl: String = ""          //请求完整地址
    var requstHeader: [String: String] = [:]   //请求头
    var requstParams: [String: String] = [:]   //请求参数
    var response: [String: Any] = [:]       //请求返回数据
    
    var responses: [CHLogItem] = []         //请求返回数据列表

    var rowHeight: CGFloat = 0              //缓存高度
}

extension CHLogItem {
    
    public class func item(with item: DDRequstItemProtocol) -> CHLogItem {
        let logItem: CHLogItem = CHLogItem()
        logItem.isRequest = true
        
        if let method = item.method,
            let url = item.url,
            let headers = item.headers,
            let parameters = item.parameters {
            logItem.requstType = method
            logItem.requstFullUrl = url
            logItem.requstHeader = headers
            logItem.requstParams = parameters
        }
        
        if let response = item.response {
            logItem.response = response
        }
        if let isRequestError = item.isError {
            logItem.isRequestError = isRequestError
        }
    
        return logItem
    }
}

extension CHLogItem {
    
    public func cellRowHeigt() -> CGFloat {
        if rowHeight != 0 {
            return rowHeight
        }
        
        let nsInfo = describeString() as NSString
        let size = nsInfo.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - 30, height: 1000),
                                       options: .usesLineFragmentOrigin,
                                       attributes: [.font: UIFont.systemFont(ofSize: 12)],
                                       context: nil)
        rowHeight = size.height + 10
        return rowHeight
    }
}

extension CHLogItem {
 
    public func describeString() -> String {
        if !isRequest {
            return logInfo
        }
        
        let info = "        Type：\(requstType)\n      FullUrl：\(requstFullUrl)\n    Header：\(requstHeader)\n   Params：\(requstParams)\nResponse：\(response)"
        return info
    }
    
    public func attributedDescribeString() -> NSMutableAttributedString {
        if !isRequest {
            let color = isError ? UIColor.red : UIColor.white
            let attributedString = NSMutableAttributedString(string: logInfo, attributes: [.font: UIFont.systemFont(ofSize: 12.0),
                                                                                           .foregroundColor: color])
            return attributedString
        }
        
        //-----
        let type = "     type："
        let attributedString = NSMutableAttributedString(string: type, attributes: [.font: UIFont.boldSystemFont(ofSize: 12.0),
                                                                                    .foregroundColor: UIColor.black])
        let typeValue = "\(requstType)    \(requstBaseUrl)\n"
        attributedString.append(NSMutableAttributedString(string: typeValue, attributes: [.font: UIFont.systemFont(ofSize: 12.0),
                                                                                          .foregroundColor: UIColor.black]))
        //-----
        let fullUrl = "  fullUrl："
        attributedString.append(NSMutableAttributedString(string: fullUrl, attributes: [.font: UIFont.boldSystemFont(ofSize: 12.0),
                                                                                        .foregroundColor: UIColor.blue]))
        let fullUrlValue = "\(requstFullUrl)\n"
        attributedString.append(NSMutableAttributedString(string: fullUrlValue, attributes: [.font: UIFont.systemFont(ofSize: 12.0),
                                                                                             .foregroundColor: UIColor.blue]))
        //-----
        let header = " header："
        attributedString.append(NSMutableAttributedString(string: header, attributes: [.font: UIFont.boldSystemFont(ofSize: 12.0),
                                                                                       .foregroundColor: UIColor.black]))
        let headerValue = "\(requstHeader)\n"
        attributedString.append(NSMutableAttributedString(string: headerValue, attributes: [.font: UIFont.systemFont(ofSize: 12.0),
                                                                                            .foregroundColor: UIColor.black]))
        //-----
        let params = "params："
        attributedString.append(NSMutableAttributedString(string: params, attributes: [.font: UIFont.boldSystemFont(ofSize: 12.0),
                                                                                       .foregroundColor: UIColor.black]))
        let paramsValue = "\(requstParams)\n"
        attributedString.append(NSMutableAttributedString(string: paramsValue, attributes: [.font: UIFont.systemFont(ofSize: 12.0),
                                                                                            .foregroundColor: UIColor.black]))
        //-----
        
        return attributedString
    }
}
