//
//  UIKit+Chain.swift
//  UIKit
//
//  Created by 胡峰 on 2017/7/19.
//  Copyright © 2017年 . All rights reserved.
//

import UIKit

// 使用 extension UIKitChainable where Self: UIView 而非直接使用 extension UIView 的方式扩展
// 是因为 Xcode（目前到 9 仍有问题）代码无法自动提示问题：父类方法 -> Self 后，无法自动提示子类的成员，但编译无问题
//自定义的两个类型
public typealias Section = Int
public typealias ElementKind = String

public protocol Chainable {}

public protocol UIKitChainable: Chainable {}
extension UIView: UIKitChainable {}

// MARK: - UIView便利构造器
public extension UILabel {
    
    /// 初始化 UILabel 对象，并设置好常用的属性
    ///
    /// - Parameters:
    ///   - text: 需要显示的文字
    ///   - size: 字体大小，支持数字（默认为system字体），UIFont类型
    ///   - color: 文字颜色，默认 .black
    ///   - background: view 的背景色，默认 .clear
    convenience init(text: String?, font: UIFontType, color: UIColor = .black, background: UIColor = .clear) {
        self.init()
        self.text       = text
        self.font       = font.font
        textColor       = color
        backgroundColor = background
    }
}

public extension UIButton {
    
    /// 初始化 .system 类型的按钮，文字默认使用 tintColor 的颜色
    ///
    /// - Parameters:
    ///   - text: .normal 状态的字体大小
    ///   - font: 字体大小，支持数字（默认为system字体），UIFont类型
    ///   - color: .normal 状态的字体颜色，默认值 nil，显示 tintColor 的颜色
    ///   - image: 按钮图片，默认值 nil
    convenience init(text: String?, font: UIFontType, color: UIColor? = nil, image: UIImage? = nil) {
        self.init(type: .system)
        setTitle(text, for: .normal)
        setTitleColor(color, for: .normal)
        titleLabel?.font = font.font
        setImage(image, for: .normal)
    }
}

extension UIImageView {
    
    /// 初始化 UIImageView，并设置 image 和显示模式
    ///
    /// - Parameters:
    ///   - image: 显示的图片
    ///   - mode: 显示模式 `contentMode`
    convenience init(image: UIImage, mode: UIView.ContentMode) {
        self.init(image: image)
        self.contentMode = mode
    }
}

// MARK: - UIFont
/// UIFont字体，已实现 Int，Double，UIFont 返回 UIFont 对象
public protocol UIFontType {
    var font: UIFont { get }
}

extension Int: UIFontType {
    public var font: UIFont { return UIFont.systemFont(ofSize: CGFloat(self)) }
}

extension Double: UIFontType {
    public var font: UIFont { return UIFont.systemFont(ofSize: CGFloat(self)) }
}

extension CGFloat: UIFontType {
    public var font: UIFont { return UIFont.systemFont(ofSize: self) }
}

extension UIFont: UIFontType {
    public var font: UIFont { return self }
}


