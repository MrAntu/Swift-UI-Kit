//
//  UIColor+HEX.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/18.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    ///  UIColor.colorWithHex(0x000000)
    ///
    /// - Parameters:
    ///   - hex: 16进制
    ///   - alpha: 透明度
    /// - Returns: color
    static public func colorWithHex(_ hex: UInt32, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat(((hex >> 16) & 0xFF))/255.0, green: CGFloat(((hex >> 8) & 0xFF))/255.0, blue: CGFloat((hex & 0xFF))/255.0, alpha: alpha)
    }
}
