//
//  Extension.swift
//  Route
//
//  Created by 鞠鹏 on 6/4/2018.
//  Copyright © 2018年 dd01. All rights reserved.
//

import UIKit

extension String {
    init<T>(_ instance: T) {
        self.init(describing: instance)
    }
}

/// 通过 T 转成字符串
///
/// Parameter instance: T
/// Return: T 名
public func convertString<T>(_ instance: T) -> String {
    return String(instance)
}
