//
//  UILabel+Chainable.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit


// MARK: - UILabel
public extension UIKitChainable where Self: UILabel {
    
    /// 设置文字水平方向对齐方式 `textAlignment`
    ///
    /// - Parameter alignment: 对齐方式
    /// - Returns: 返回 self，支持链式调用
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }
    
    /// 设置最多显示行数 `numberOfLines`
    ///
    /// - Parameter lines: 最多显示行数，0 为任意行数
    /// - Returns: 返回 self，支持链式调用
    @discardableResult
    func numberOfLines(_ lines: Int) -> Self {
        numberOfLines = lines
        return self
    }
    
    /// 设置字体大小
    ///
    /// - Parameter font: `UIFontType`
    /// - Returns: self
    @discardableResult
    func font(_ font: UIFontType) -> Self {
        self.font = font.font
        return self
    }
    
    /// 设置文字
    ///
    /// - Parameter text: `text`
    /// - Returns: self
    @discardableResult
    func text(_ text: String?) -> Self {
        self.text = text
        return self
    }
    
    /// 设置字体颜色
    ///
    /// - Parameter color: color
    /// - Returns: self
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        textColor = color
        return self
    }
    
    /// 设置shadowColor
    ///
    /// - Parameter color: color
    /// - Returns: self
    @discardableResult
    func shadowColor(_ color: UIColor?) -> Self {
        shadowColor = color
        return self
    }
    
    /// 设置阴影偏移量
    ///
    /// - Parameter offset: offset
    /// - Returns: self
    @discardableResult
    func shadowOffset(_ offset: CGSize) -> Self {
        shadowOffset = offset
        return self
    }
    
    /// 设置lineBreakMode
    ///
    /// - Parameter mode: mode
    /// - Returns: self
    @discardableResult
    func lineBreakMode(_ mode: NSLineBreakMode) -> Self {
        lineBreakMode = mode
        return self
    }
    
    /// 设置富文本
    ///
    /// - Parameter attributedtext: attributedtext
    /// - Returns: self
    @discardableResult
    func attributedText(_ attributedtext: NSAttributedString?) -> Self {
        attributedText = attributedtext
        return self
    }
    
    /// 设置高亮字体颜色
    ///
    /// - Parameter color: color
    /// - Returns: self
    @discardableResult
    func highlightedTextColor(_ color: UIColor?) -> Self {
        highlightedTextColor = color
        return self
    }
    
    /// 是否高亮
    ///
    /// - Parameter bool: bool
    /// - Returns: self
    @discardableResult
    func isHighlighted(_ lighted: Bool) -> Self {
        isHighlighted = lighted
        return self
    }
    
    /// 是否允许交互
    ///
    /// - Parameter enabled: enabled
    /// - Returns: self
    @discardableResult
    func isUserInteractionEnabled(_ enabled: Bool) -> Self {
        isUserInteractionEnabled = enabled
        return self
    }
    
    /// 是否可用
    ///
    /// - Parameter enabled: enabled
    /// - Returns: self
    @discardableResult
    func isEnabled(_ enabled: Bool) -> Self {
        isEnabled = enabled
        return self
    }
    
    /// 是否自动调整字体大小
    ///
    /// - Parameter bool: bool
    /// - Returns: self
    @discardableResult
    func adjustsFontSizeToFitWidth(_ bool: Bool) -> Self {
        adjustsFontSizeToFitWidth = bool
        return self
    }
    
    /// minimumScaleFactor
    ///
    /// - Parameter factor: factor
    /// - Returns: self
    @discardableResult
    func minimumScaleFactor(_ factor: CGFloat) -> Self {
        minimumScaleFactor = factor
        return self
    }
    
    /// allowsDefaultTighteningForTruncation
    ///
    /// - Parameter bool: bool
    /// - Returns: self
    @discardableResult
    func allowsDefaultTighteningForTruncation(_ bool: Bool) -> Self {
        allowsDefaultTighteningForTruncation = bool
        return self
    }
    
    /// preferredMaxLayoutWidth
    ///
    /// - Parameter width: width
    /// - Returns: self
    @discardableResult
    func preferredMaxLayoutWidth(_ width: CGFloat) -> Self {
        preferredMaxLayoutWidth = width
        return self
    }
    
    /// clipsToBounds
    ///
    /// - Parameter bool: bool
    /// - Returns: self
    @discardableResult
    func clipsToBounds(_ bool: Bool) -> Self {
        clipsToBounds = bool
        return self
    }
    
    /// isOpaque
    ///
    /// - Parameter bool: bool
    /// - Returns: self
    @discardableResult
    func isOpaque(_ bool: Bool) -> Self {
        isOpaque = bool
        return self
    }
    
    /// clearsContextBeforeDrawing
    ///
    /// - Parameter bool: bool
    /// - Returns: self
    @discardableResult
    func clearsContextBeforeDrawing(_ bool: Bool) -> Self {
        clearsContextBeforeDrawing = bool
        return self
    }
    
    /// isHidden
    ///
    /// - Parameter bool: bool
    /// - Returns: self
    @discardableResult
    func isHidden(_ bool: Bool) -> Self {
        isHidden = bool
        return self
    }
    
    /// mask
    ///
    /// - Parameter view: view
    /// - Returns: self
    @discardableResult
    func mask(_ view: UIView?) -> Self {
        mask = view
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
    
    /// tintAdjustmentMode
    ///
    /// - Parameter mode: mode
    /// - Returns: self
    @discardableResult
    func tintAdjustmentMode(_ mode: UIView.TintAdjustmentMode) -> Self {
        tintAdjustmentMode = mode
        return self
    }
}
