//
//  UIProgressView+Chainable.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/11.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

public extension UIKitChainable where Self: UIProgressView {

    @discardableResult
    func progressViewStyle(_ style: UIProgressView.Style) -> Self {
        progressViewStyle = style
        return self
    }
    
    @discardableResult
    func progress(_ value: Float) -> Self {
        progress = value
        return self
    }
    
    @discardableResult
    func progressTintColor(_ color: UIColor?) -> Self {
        progressTintColor = color
        return self
    }
    
    @discardableResult
    func trackTintColor(_ color: UIColor?) -> Self {
        trackTintColor = color
        return self
    }
    
    @discardableResult
    func progressImage(_ image: UIImage?) -> Self {
        progressImage = image
        return self
    }
    
    @discardableResult
    func trackImage(_ image: UIImage?) -> Self {
        trackImage = image
        return self
    }
    
    @discardableResult
    func observedProgress(_ progress: Progress?) -> Self {
        observedProgress = progress
        return self
    }

}
