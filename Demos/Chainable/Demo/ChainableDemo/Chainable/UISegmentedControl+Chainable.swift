

//
//  UISegmentedControl+Chainable.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/11.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit
public extension UIKitChainable where Self: UISegmentedControl {
    @discardableResult
    func isMomentary(_ bool: Bool) -> Self {
        isMomentary = bool
        return self
    }
    
    @discardableResult
    func apportionsSegmentWidthsByContent(_ bool: Bool) -> Self {
        apportionsSegmentWidthsByContent = bool
        return self
    }
    
    @discardableResult
    func insertSegment(title t: String?, segment: Int, animated: Bool) -> Self {
        insertSegment(withTitle: t, at: segment, animated: animated)
        return self
    }
    
    @discardableResult
    func insertSegment(image i: UIImage?, segment: Int, animated: Bool) -> Self {
        insertSegment(with: i, at: segment, animated: animated)
        return self
    }
    
    @discardableResult
    func removeSegment(_ segment: Int, animated: Bool) -> Self {
        removeSegment(at: segment, animated: animated)
        return self
    }
    
    @discardableResult
    func removeAll() -> Self {
        removeAllSegments()
        return self
    }
    
    @discardableResult
    func selectedSegmentIndex(_ index: Int) -> Self {
        selectedSegmentIndex = index
        return self
    }
    
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }
}
