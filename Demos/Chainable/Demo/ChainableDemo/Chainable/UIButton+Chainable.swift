//
//  UIButton+Chainable.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIButton
public extension UIKitChainable where Self: UIButton {
    /// 设置图片位置
    ///
    /// - Parameters:
    ///   - p: 位置
    ///   - space: 距离
    /// - Returns: self
    @discardableResult
    func image(position p: ButtonImagePosition, space: CGFloat) -> Self {
        imagePosition(p, space: space)
        return self
    }
    
    /// font
    ///
    /// - Parameter font: font
    /// - Returns: self
    @discardableResult
    func font(_ font: UIFontType) -> Self {
        titleLabel?.font = font.font
        return self
    }
    
    /// contentEdgeInsets
    ///
    /// - Parameter insets: insets
    /// - Returns: self
    @discardableResult
    func contentEdgeInsets(_ insets: UIEdgeInsets) -> Self {
        contentEdgeInsets = insets
        return self
    }
    
    /// titleEdgeInsets
    ///
    /// - Parameter insets: insets
    /// - Returns: self
    @discardableResult
    func titleEdgeInsets(_ insets: UIEdgeInsets) -> Self {
        titleEdgeInsets = insets
        return self
    }
    
    /// reversesTitleShadowWhenHighlighted
    ///
    /// - Parameter highlighted: highlighted
    /// - Returns: self
    @discardableResult
    func reversesTitleShadow(highlighted bool: Bool) -> Self {
        reversesTitleShadowWhenHighlighted = bool
        return self
    }
    
    /// imageEdgeInsets
    ///
    /// - Parameter insets: insets
    /// - Returns: self
    @discardableResult
    func imageEdgeInsets(_ insets: UIEdgeInsets) -> Self {
        imageEdgeInsets = insets
        return self
    }
    
    /// adjustsImage
    ///
    /// - Parameter highlighted: highlighted
    /// - Returns: self
    @discardableResult
    func adjustsImage(highlighted bool: Bool) -> Self {
        adjustsImageWhenHighlighted = bool
        return self
    }
    
    /// adjustsImage
    ///
    /// - Parameter bool: disabled
    /// - Returns: self
    @discardableResult
    func adjustsImage(disabled bool: Bool) -> Self {
        adjustsImageWhenDisabled = bool
        return self
    }
    
    /// showsTouch
    ///
    /// - Parameter bool: highlighted
    /// - Returns: self
    @discardableResult
    func showsTouch(highlighted bool: Bool) -> Self {
        showsTouchWhenHighlighted = bool
        return self
    }
    
    /// tint
    ///
    /// - Parameter color: color
    /// - Returns: self
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }
    
    /// setTitle
    ///
    /// - Parameters:
    ///   - title: title
    ///   - state: state
    /// - Returns: self
    @discardableResult
    func setTitle(_ title: String?, state: UIControl.State) -> Self {
        setTitle(title, for: state)
        return self
    }
    
    /// setTitleColor
    ///
    /// - Parameters:
    ///   - color: color
    ///   - state: state
    /// - Returns: self
    @discardableResult
    func setTitleColor(_ color: UIColor?, state: UIControl.State) -> Self {
        setTitleColor(color, for: state)
        return self
    }
    
    /// 设置图片
    ///
    /// - Parameters:
    ///   - image: image
    ///   - state: state
    /// - Returns: self
    @discardableResult
    func setImage(_ image: UIImage?, state: UIControl.State) -> Self {
        setImage(image, for: state)
        return self
    }
    
    /// 设置背景图片
    ///
    /// - Parameters:
    ///   - image: image
    ///   - state: state
    /// - Returns: self
    @discardableResult
    func setBackgroundImage(_ image: UIImage?, state: UIControl.State) -> Self {
        setBackgroundImage(image, for: state)
        return self
    }
    
    /// 设置富文本
    ///
    /// - Parameters:
    ///   - title: 富文本
    ///   - state: state
    /// - Returns: self
    @discardableResult
    func setAttributedTitle(_ title: NSAttributedString?, state: UIControl.State) -> Self {
        setAttributedTitle(title, for: state)
        return self
    }
    
    /// addTargetAction
    ///
    /// - Parameter handler: handler
    /// - Returns: self
    @discardableResult
    func addActionTouchUpInside(_ handler: @escaping (UIButton) -> Void) -> Self {
        self.action(.touchUpInside) { (btn) in
            handler(btn)
        }
        return self
    }
}
