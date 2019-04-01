

//
//  UISlider+Chainable.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/11.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

public extension UIKitChainable where Self: UISlider {

    @discardableResult
    func value(_ value: Float) -> Self {
        self.value = value
        return self
    }
    
    @discardableResult
    func minimumValue(_ value: Float) -> Self {
        minimumValue = value
        return self
    }
    
    @discardableResult
    func maximumValue(_ value: Float) -> Self {
        maximumValue = value
        return self
    }
    
    @discardableResult
    func minimumValueImage(_ image: UIImage?) -> Self {
        minimumValueImage = image
        return self
    }
    
    @discardableResult
    func maximumValueImage(_ image: UIImage?) -> Self {
        maximumValueImage = image
        return self
    }
    
    @discardableResult
    func isContinuous(_ bool: Bool) -> Self {
        isContinuous = bool
        return self
    }
    
    @discardableResult
    func minimumTrackTintColor(_ color: UIColor?) -> Self {
        minimumTrackTintColor = color
        return self
    }
    
    @discardableResult
    func maximumTrackTintColor(_ color: UIColor?) -> Self {
        maximumTrackTintColor = color
        return self
    }
    
    @discardableResult
    func thumbTintColor(_ color: UIColor?) -> Self {
        thumbTintColor = color
        return self
    }
}
