//
//  NotificationCenter+Chainable.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/11.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

fileprivate let NotificationCenterChainableDisposebag = DisposeBag()

public extension Chainable where Self: NSObject {
    
    /// 给当前对象添加快捷通知方法
    ///
    /// - Parameters:
    ///   - name: name
    ///   - object: object
    ///   - handler: handler
    /// - Returns: self
    @discardableResult
    public func addNotifiObserver(name: String, object: Any? = nil, handler: @escaping (Notification) -> Void) -> Self {
        NotificationCenter.default
            .rx.notification(NSNotification.Name.init(name))
            .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
            .subscribe(onNext: { (notification) in
                handler(notification)
            })
            .disposed(by: NotificationCenterChainableDisposebag)
        return self
    }
    
    /// 给当前对象添加快捷发送通知
    ///
    /// - Parameters:
    ///   - name: name
    ///   - object: object
    ///   - userInfo: userInfo
    /// - Returns: self
    @discardableResult
    public func postNotification(name: String, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) -> Self {
        NotificationCenter.default.post(name: NSNotification.Name.init(name), object: object, userInfo: userInfo)
        return self
    }
}
