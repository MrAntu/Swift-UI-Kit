//
//  WebManager.swift
//  DDKit
//
//  Created by senyuhao on 2018/10/31.
//  Copyright © 2018 dd01. All rights reserved.
//

import Foundation
import WebKit

public class WebManager: NSObject {
    
    private var bridge: WKWebViewJavascriptBridge?

    public static let shared = WebManager()
    
    /// JS主动调用Native的config方法，返回结果，并可回调
    public var configBlock: WKWebViewJavascriptBridgeBase.Handler?
    /// JS主动调用Native的send方法，返回结果，并可回调
    public var sendBlock: WKWebViewJavascriptBridgeBase.Handler?
    /// JS主动调用Native的request方法，返回结果，并可回调
    public var requestBlock: WKWebViewJavascriptBridgeBase.Handler?

    private var configValue: [String: Any]?
    private var configHandler: WKWebViewJavascriptBridgeBase.Callback?

    /// 配置WkWebView
    public func configManager(_ web: WKWebView) {
        bridge = WKWebViewJavascriptBridge(webView: web)
        bridge?.register(handlerName: "config", handler: { [weak self] value, block in
            self?.configValue = value
            self?.configHandler = block
            self?.configBlock?(value, block)
        })
        bridge?.register(handlerName: "send", handler: { [weak self] value, block in
            self?.sendBlock?(value, block)
        })
        bridge?.register(handlerName: "request", handler: { [weak self] value, block in
            self?.requestBlock?(value, block)
        })
    }

    /// Native调用JS的push方法，传递参数，并回调回结果
    public func push(param: Any, handler: WKWebViewJavascriptBridgeBase.Callback? = nil) {
        if let bridge = bridge {
           bridge.call(handlerName: "push", data: param, callback: handler)
        }
    }

    /// Native调用JS方法sendCallback方法，传递参数，并回调回结果。 err与response必有一个有值
    public func callback(err: String?, response: Any?) -> Any? {
        if bridge != nil {
            var param = [String: Any]()
            if let err = err {
                param["err"] = err
            }
            if let response = response {
                param["message"] = response
            }
            if let data = try? JSONSerialization.data(withJSONObject: param, options: []), let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                return json
            }
        }
        return nil
    }

    /// 字典转json
    public func dictToJson(_ sender: [String: Any]) -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: sender, options: []) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    public func configFinished() {
        if let value = WebManager.shared.callback(err: nil, response: "request response") {
            configHandler?(value)
        }
    }
}
