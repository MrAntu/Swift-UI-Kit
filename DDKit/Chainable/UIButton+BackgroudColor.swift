//
//  UIButton+BackgroudColor.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/3/27.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    public func setBackground(color: UIColor, forState state: UIControl.State) {
        setBackgroundImage(imageFromColor(color: color), for: state)
    }
    
    fileprivate func imageFromColor(color: UIColor) -> UIImage? {
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

