
//
//  UISwitch+Chainable.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/11.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

public extension UIKitChainable where Self: UISwitch {

    @discardableResult
    func onTintColor(_ color: UIColor?) -> Self {
        onTintColor = color
        return self
    }
    
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }
    
    @discardableResult
    func thumbTintColor(_ color: UIColor?) -> Self {
        thumbTintColor = color
        return self
    }
    
    @discardableResult
    func onImage(_ image: UIImage?) -> Self {
        onImage = image
        return self
    }
    
    @discardableResult
    func offImage(_ image: UIImage?) -> Self {
        offImage = image
        return self
    }
    
    @discardableResult
    func isOn(_ bool: Bool) -> Self {
        isOn = bool
        return self
    }

}
