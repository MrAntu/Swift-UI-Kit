//
//  UIColor+Extension.swift
//  hk01-uikit
//
//  Created by USER on 2018/5/22.
//  Copyright © 2018年 dd01. All rights reserved.
//

import UIKit

extension UIColor {
    public static func imageFromColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
