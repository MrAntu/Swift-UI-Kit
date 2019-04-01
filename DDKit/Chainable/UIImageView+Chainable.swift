//
//  UIImageView+Chainable.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIImageView
public extension UIKitChainable where Self: UIImageView {
    /// 设置图片
    ///
    /// - Parameter image: image
    /// - Returns: self
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    /// highlightedImage
    ///
    /// - Parameter image: image
    /// - Returns: self
    @discardableResult
    func highlightedImage(_ image: UIImage?) -> Self {
        highlightedImage = image
        return self
    }
    
    /// isUserInteractionEnabled
    ///
    /// - Parameter bool: bool
    /// - Returns: self
    @discardableResult
    func isUserInteractionEnabled(_ bool: Bool) -> Self {
        isUserInteractionEnabled = bool
        return self
    }
    
    /// isHighlighted
    ///
    /// - Parameter bool: bool
    /// - Returns: self
    @discardableResult
    func isHighlighted(_ bool: Bool) -> Self {
        isHighlighted = bool
        return self
    }
    
    /// animationImages
    ///
    /// - Parameter images: images
    /// - Returns: self
    @discardableResult
    func animationImages(_ images: [UIImage]?) -> Self {
        animationImages = images
        return self
    }
    
    /// highlightedAnimationImages
    ///
    /// - Parameter images: images
    /// - Returns: self
    @discardableResult
    func highlightedAnimationImages(_ images: [UIImage]?) -> Self {
        highlightedAnimationImages = images
        return self
    }
    
    /// 动画时间
    ///
    /// - Parameter duration: 时间
    /// - Returns: self
    @discardableResult
    func animationDuration(_ duration: TimeInterval) -> Self {
        animationDuration = duration
        return self
    }
    
    /// 动画循环次数
    ///
    /// - Parameter count: count
    /// - Returns: self
    @discardableResult
    func animationRepeatCount(_ count: Int) -> Self {
        animationRepeatCount = count
        return self
    }
    
    /// tintColor
    ///
    /// - Parameter color: color
    /// - Returns: self
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }
    
    /// 开始动画
    ///
    /// - Returns: self
    @discardableResult
    func startAnimate() -> Self {
        startAnimating()
        return self
    }
    
    
    /// 停止动画
    ///
    /// - Returns: self
    @discardableResult
    func stopAnimate() -> Self {
        stopAnimating()
        return self
    }
}
