//
//  UIView+Responder.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/21.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 获取view上的当前控制器
extension UIView {
    public func viewController() -> UIViewController? {
        var next: UIResponder?
        next = self.next
        repeat {
            if (next as? UIViewController) != nil {
                return next as? UIViewController
            } else {
                next = next?.next
            }
        } while next != nil
        return UIViewController()
    }
}
