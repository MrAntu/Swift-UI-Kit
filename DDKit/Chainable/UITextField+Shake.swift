//
//  UITextField+Shake.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/9.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

public enum ShakeDirection {
    case horizontal
    case vertical
}

extension UITextField {
    
    /// 输入框震动
    ///
    /// - Parameters:
    ///   - times: 震动次数
    ///   - delta: 震动的宽度
    ///   - speed: shake的持续时间
    ///   - shakeDirection: 震动的方向
    ///   - completion: 震动完成回调
    public func shake(times: Int = 10, delta: CGFloat = 5, speed: TimeInterval = 0.03, shakeDirection: ShakeDirection = .horizontal, completion: (()->())? = nil) {
        _shake(times: times, direction: 1, currentTimes: 0, delta: delta, speed: speed, shakeDirection: shakeDirection, completion: completion)
    }
}

extension UITextField {
    fileprivate func _shake(times: Int, direction: Int, currentTimes: Int, delta: CGFloat, speed: TimeInterval, shakeDirection: ShakeDirection, completion:(()->())?) {
        UIView.animate(withDuration: speed, animations: {[weak self] in
            self?.transform = (shakeDirection == .horizontal) ? CGAffineTransform(translationX: delta * CGFloat(direction), y: 0) : CGAffineTransform(translationX: 0, y: delta * CGFloat(direction))
        }) {[weak self] (finished) in
            if currentTimes >= times {
                UIView.animate(withDuration: speed, animations: {
                    self?.transform = .identity
                }, completion: { (finished) in
                    completion?()
                })
                return
            }
            
            self?._shake(times: times - 1, direction: direction * -1, currentTimes: currentTimes + 1, delta: delta, speed: speed, shakeDirection: shakeDirection, completion: completion)
        }
    }
}
