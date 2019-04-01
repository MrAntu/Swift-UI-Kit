//
//  UIKit+Action.swift
//  UIKit
//
//  Created by 胡峰 on 2017/7/12.
//  Copyright © 2017年 . All rights reserved.
//

import UIKit

/// 扩展了 UIKit 控件，支持闭包事件回调
///
/// 支持 UIView，UIControl，UIButton，UIBarButtonItem，UIGestureRecognizer。
/// 使用时一定要注意循环引用的问题，根据此API的使用场景，不使用 [weak self] 几乎 100% 产生循环引用
public protocol UIKitClosurable: NSObjectProtocol {
    init() // 仅为了解决 ActionClosureTarget.invoke(_:) 转化 Any 不成功时的兼容，理论上不可能转不成功
}
// 需要在方法参数中使用 Self，目前只能使用 protocol 的 extension 实现，参考 https://stackoverflow.com/q/42660874
extension UIView: UIKitClosurable { }
extension UIBarButtonItem: UIKitClosurable { }
extension UIGestureRecognizer: UIKitClosurable { }

// MARK: - 闭包回调
public extension UIKitClosurable where Self: UIControl {
    /// 添加事件回调（闭包）
    ///
    /// - Parameters:
    ///   - event: 事件类型
    ///   - handler: 闭包回调，sender 为产生事件的控件，闭包内一定要使用 `[weak self]` 避免循环引用
    /// - Returns: 返回 self，支持链式调用
    @discardableResult func action(_ event: UIControl.Event, _ handler: @escaping (_ sender: Self) -> Void) -> Self {
        let actionTarget = ClosureActionTarget(handler: handler)
        addTarget(actionTarget, action: #selector(actionTarget.invoke(_:)), for: event)
        allActionClosureTargets.append(actionTarget)
        return self
    }
}

public extension UIKitClosurable where Self: UIButton {
    /// 添加点击（即`.touchUpInside`）事件回调（闭包）
    ///
    /// - Parameter handler: 闭包回调，sender 为产生事件的控件，闭包内一定要使用 `[weak self]` 避免循环引用
    /// - Returns: 返回 self，支持链式调用
    @discardableResult func press(_ handler: @escaping (_ sender: Self) -> Void) -> Self {
        return action(.touchUpInside, handler)
    }
}

public extension UIKitClosurable where Self: UIBarButtonItem {
    /// 添加点击事件回调（闭包）
    ///
    /// - Parameter handler: 闭包回调，sender 为产生事件的控件，闭包内一定要使用 `[weak self]` 避免循环引用
    /// - Returns: 返回 self，支持链式调用
    @discardableResult func action(_ handler: @escaping (_ sender: Self) -> Void) -> Self {
        let actionTarget = ClosureActionTarget(handler: handler)
        target = actionTarget
        action = #selector(actionTarget.invoke(_:))
        allActionClosureTargets.append(actionTarget)
        return self
    }
}

public extension UIKitClosurable where Self: UIGestureRecognizer {
    /// 添加手势事件回调（闭包）
    ///
    /// - Parameter handler: 闭包回调，sender 为产生事件的手势，闭包内一定要使用 `[weak self]` 避免循环引用
    /// - Returns: 返回 self，支持链式调用
    @discardableResult func action(_ handler: @escaping (_ sender: Self) -> Void) -> Self {
        let actionTarget = ClosureActionTarget(handler: handler)
        addTarget(actionTarget, action: #selector(actionTarget.invoke(_:)))
        allActionClosureTargets.append(actionTarget)
        return self
    }
}

public extension UIKitClosurable where Self: UIView  {
    /// 添加单击手势事件回调（闭包），若添加了双击手势，将等待双击识别失败后才回调
    ///
    /// - Parameter handler: 闭包回调，闭包的参数为产生事件的view和手势，闭包内一定要使用 `[weak self]` 避免循环引用
    /// - Returns: 返回 self，支持链式调用
    @discardableResult func tap(_ handler: @escaping (Self, UITapGestureRecognizer) -> Void) -> Self {
        gesture(UITapGestureRecognizer(), handler)
        checkTapConflict()
        return self
    }
    
    /// 添加双击手势事件回调（闭包），若添加了单击手势，将等待双击识别失败后才回调单击手势的事件
    ///
    /// - Parameter handler: 闭包回调，闭包的参数为产生事件的view和手势，闭包内一定要使用 `[weak self]` 避免循环引用
    /// - Returns: 返回 self，支持链式调用
    @discardableResult func doubleTap(_ handler: @escaping (Self, UITapGestureRecognizer) -> Void) -> Self {
        let recognizer = UITapGestureRecognizer()
        recognizer.numberOfTapsRequired = 2
        gesture(recognizer, handler)
        checkTapConflict()
        return self
    }
    
    /// 添加长按手势事件回调（闭包）
    ///
    /// 默认长按时间为系统默认的0.5s，事件仅回调一次，不会按住时持续回调
    /// - Parameter handler: 闭包回调，闭包的参数为产生事件的view和手势，闭包内一定要使用 `[weak self]` 避免循环引用
    /// - Returns: 返回 self，支持链式调用
    @discardableResult func longPress(_ handler: @escaping (Self, UILongPressGestureRecognizer) -> Void) -> Self {
        gesture(UILongPressGestureRecognizer()) { (view, sender) in
//            if sender.state == .began {
//            }
            handler(view, sender)
        }
        return self
    }
    
    /// 添加任意手势事件回调（闭包）
    ///
    /// - Parameters:
    ///   - recognizer: 需要添加的手势
    ///   - handler: 闭包回调，闭包的参数为产生事件的view和手势，闭包内一定要使用 `[weak self]` 避免循环引用
    /// - Returns: 返回 self，支持链式调用
    @discardableResult func gesture<T: UIGestureRecognizer>(_ recognizer: T,_ handler: @escaping (Self, T) -> Void) -> Self {
        isUserInteractionEnabled = true
        addGestureRecognizer(recognizer.action({ (sender) in
            handler(self, sender)
        }))
        return self
    }
    
    /// 检测 tap 事件的冲突，如同时添加双击和单击事件时，需等待双击失败才响应单击事件
    private func checkTapConflict() {
        var taps = [[UITapGestureRecognizer]](repeating: [], count: 10)
        gestureRecognizers?.compactMap({ $0 as? UITapGestureRecognizer })
            .forEach({ taps[$0.numberOfTapsRequired].append($0) })
        taps = taps.compactMap({ $0.count > 0 ? $0 : nil })
        
        zip(taps, taps.dropFirst()).forEach { (left, right) in
            left.forEach({ (leftGesture) in
                right.forEach({ (rightGesture) in
                    leftGesture.require(toFail: rightGesture)
                })
            })
        }
    }
}

// MARK: - 内部方法
private var UIKitClosureKey: Void?

extension UIKitClosurable {
    fileprivate var allActionClosureTargets: [ClosureActionTarget<Self>] {
        get { return objc_getAssociatedObject(self, &UIKitClosureKey) as? [ClosureActionTarget] ?? [] }
        set { objc_setAssociatedObject(self, &UIKitClosureKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private class ClosureActionTarget<T>: NSObject where T: UIKitClosurable {
    
    var handler: (T) -> Void
    
    init(handler: @escaping (T) -> Void) {
        self.handler = handler
        super.init()
    }
    
    @objc func invoke(_ sender: Any) {
        guard let originalSender = sender as? T else {
            assertionFailure("\(type(of: sender)) 的事件回调 sender != self")
            handler(T())
            return
        }
        handler(originalSender)
    }
}
