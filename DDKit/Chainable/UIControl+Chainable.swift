//
//  UIControl+Chainable.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/11.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

public extension UIKitChainable where Self: UIControl {

    /// addTargetAction
    ///
    /// - Parameter handler: handler
    /// - Returns: self
    @discardableResult
    func addActionTouchUpInside(_ handler: @escaping (Self) -> Void) -> Self {
        action(.touchUpInside, handler)
        return self
    }
    
    /// 添加点击事件
    ///
    /// - Parameters:
    ///   - event: UIControlEvents
    ///   - handler: 回调
    /// - Returns: self
    @discardableResult
    func addAction(events event: UIControl.Event, handler: @escaping (Self) -> Void) -> Self {
        action(event, handler)
        return self
    }
}
