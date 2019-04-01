//
//  UITextField+Chainable.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

//extension UITextField {
//    fileprivate struct ChainableTextFieldKey {
//        static var kChainableTextFieldDelegateKey = "kChainableTextFieldDelegateKey"
//    }
//
//
//    /// Chainable内部使用
//    weak var chainalbeDelegate: UITextFieldDelegate?  {
//        get {
//            return objc_getAssociatedObject(self, &ChainableTextFieldKey.kChainableTextFieldDelegateKey) as? UITextFieldDelegate
//        }
//        
//        set(value) {
//            objc_setAssociatedObject(self, &ChainableTextFieldKey.kChainableTextFieldDelegateKey, value, .OBJC_ASSOCIATION_ASSIGN)
//        }
//    }
//}

public extension UIKitChainable where Self: UITextField {

    /// 设置代理
    ///
    /// - Parameter delegate: delegate
    /// - Returns: self
//    @discardableResult
//    func delegate(_ delegate: UITextFieldDelegate?) -> UITextField {
//        chainalbeDelegate = delegate
//        return self
//    }
    
    /// 文字
    ///
    /// - Parameter text: text
    /// - Returns: self
    @discardableResult
    func text(_ text: String?) -> Self {
        self.text = text
        return self
    }
    
    /// attributedText
    ///
    /// - Parameter text: text
    /// - Returns: self
    @discardableResult
    func attributedText(_ text: NSAttributedString?) -> Self {
        attributedText = text
        return self
    }
    
    @discardableResult
    func textColor(_ color: UIColor?) -> Self {
        textColor = color
        return self
    }
    
    @discardableResult
    func font(_ font: UIFontType) -> Self {
        self.font = font.font
        return self
    }
    
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }
    
    @discardableResult
    func borderStyle(_ style: UITextField.BorderStyle) -> Self {
        borderStyle = style
        return self
    }
    
    @discardableResult
    func defaultTextAttributes(_ attributes: [String : Any]) -> Self {
        defaultTextAttributes = convertToNSAttributedStringKeyDictionary(attributes)
        return self
    }
    
    @discardableResult
    func placeholder(_ holder: String?) -> Self {
        placeholder = holder
        return self
    }
    
    @discardableResult
    func attributedPlaceholder(_ holder: NSAttributedString?) -> Self {
        attributedPlaceholder = holder
        return self
    }
    
    @discardableResult
    func clearsOnBeginEditing(_ bool: Bool) -> Self {
        clearsOnBeginEditing = bool
        return self
    }
    
    @discardableResult
    func adjustsFontSizeToFitWidth(_ bool: Bool) -> Self {
        adjustsFontSizeToFitWidth = bool
        return self
    }
    
    @discardableResult
    func minimumFontSize(_ size: CGFloat) -> Self {
        minimumFontSize = size
        return self
    }
    
    @discardableResult
    func background(image: UIImage?) -> Self {
        background = image
        return self
    }
    
    @discardableResult
    func disabledBackground(image: UIImage?) -> Self {
        disabledBackground = image
        return self
    }
    
    @discardableResult
    func allowsEditingTextAttributes(_ bool: Bool) -> Self {
        allowsEditingTextAttributes = bool
        return self
    }
    
    @discardableResult
    func typingAttributes(_ attributes: [String : Any]?) -> Self {
        typingAttributes = convertToOptionalNSAttributedStringKeyDictionary(attributes)
        return self
    }
    
    @discardableResult
    func clearButtonMode(_ mode: UITextField.ViewMode) -> Self {
        clearButtonMode = mode
        return self
    }
    
    @discardableResult
    func leftView(_ view: UIView?) -> Self {
        leftView = view
        return self
    }
    
    @discardableResult
    func leftViewMode(_ mode: UITextField.ViewMode) -> Self {
        leftViewMode = mode
        return self
    }
    
    @discardableResult
    func rightView(_ view: UIView?) -> Self {
        rightView = view
        return self
    }
    
    @discardableResult
    func rightViewMode(_ mode: UITextField.ViewMode) -> Self {
        rightViewMode = mode
        return self
    }
    
    @discardableResult
    func inputView(_ view: UIView?) -> Self {
        inputView = view
        return self
    }
    
    @discardableResult
    func inputAccessoryView(_ view: UIView?) -> Self {
        inputAccessoryView = view
        return self
    }
    
    @discardableResult
    func clearsOnInsertion(_ bool: Bool) -> Self {
        clearsOnInsertion = bool
        return self
    }
    
    /// 是否开始进入编辑状态
    ///
    /// - Parameter handler: handler
    /// - Returns: self
    @discardableResult
    func addShouldBegindEditingBlock(_ handler: @escaping((UITextField)->(Bool))) -> Self {
        setShouldBegindEditingBlock(handler)
        return self
    }
    
    /// 是否结束编辑状态
    ///
    /// - Parameter handler: handler
    /// - Returns: self
    @discardableResult
    func addShouldEndEditingBlock(_ handler: @escaping((UITextField)->(Bool))) -> Self {
        setShouldEndEditingBlock(handler)
        return self
    }
    
    /// 进入编辑状态
    ///
    /// - Parameter handler: handler
    /// - Returns: self
    @discardableResult
    func addDidBeginEditingBlock(_ handler: @escaping((UITextField)->())) -> Self {
        setDidBeginEditingBlock(handler)
        return self
    }
    
    /// 是否改变输入的字符
    ///
    /// - Parameter handler: handler
    /// - Returns: self
    @discardableResult
    func addShouldChangeCharactersInRangeBlock(_ handler: @escaping((UITextField, NSRange, String)->(Bool))) -> Self {
        setShouldChangeCharactersInRangeBlock(handler)
        return self
    }
    
    /// 点击clear按钮是否有效
    ///
    /// - Parameter handler: handler
    /// - Returns: self
    @discardableResult
    func addShouldClearBlock(_ handler: @escaping((UITextField)->(Bool))) -> Self {
        setShouldClearBlock(handler)
        return self
    }
    
    /// 点击return按钮是否有效
    ///
    /// - Parameter handler: handler
    /// - Returns: self
    @discardableResult
    func addShouldReturnBlock(_ handler: @escaping((UITextField)->(Bool))) -> Self {
        setShouldReturnBlock(handler)
        return self
    }
    
    /// 最大输入字符长度
    ///
    /// - Parameter length: length
    /// - Returns: self
    @discardableResult
    func maxLength(_ length: Int) -> Self {
        self.maxLength = length
        return self
    }
    
    /// 当进入编辑的时候是否需要震动
    ///
    /// - Parameter bool: bool
    /// - Returns: self
    @discardableResult
    func shake(_ bool: Bool) -> Self {
        shouldBegindEditingShake = bool
        return self
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
