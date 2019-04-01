//
//  UITextView+Chainable.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit


// MARK: - UITextView
public extension UIKitChainable where Self: UITextView {

    /// 设置最大值
    ///
    /// - Parameter length: length
    /// - Returns: self
    @discardableResult
    func maxLength(_ length: Int) -> Self {
        maxLength = length
        return self
    }
    
    /// placeholder
    ///
    /// - Parameter holder: holder
    /// - Returns: self
    @discardableResult
    func placeholder(_ holder: String?) -> Self {
        placeholder = holder
        return self
    }
    
    /// 设置代理
    ///
    /// - Parameter delegate: delegate
    /// - Returns: self
//    @discardableResult
//    func delegate(_ delegate: UITextViewDelegate?) -> UITextView {
//        self.delegate = delegate
//        return self
//    }
    
    /// text
    ///
    /// - Parameter text: text
    /// - Returns: self
    @discardableResult
    func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    /// font
    ///
    /// - Parameter font: font
    /// - Returns: self
    @discardableResult
    func font(_ font: UIFontType) -> Self {
        self.font = font.font
        return self
    }
    
    /// textColor
    ///
    /// - Parameter color: color
    /// - Returns: self
    @discardableResult
    func textColor(_ color: UIColor?) -> Self {
        textColor = color
        return self
    }
    
    @discardableResult
    func textAlignment(_ aligment: NSTextAlignment) -> Self {
        textAlignment = aligment
        return self
    }
    
    @discardableResult
    func selectedRange(_ range: NSRange) -> Self {
        selectedRange = range
        return self
    }
    
    @discardableResult
    func isEditable(_ able: Bool) -> Self {
        isEditable = able
        return self
    }
    
    @discardableResult
    func isSelectable(_ able: Bool) -> Self {
        isSelectable = able
        return self
    }
    
    @discardableResult
    func dataDetectorTypes(_ types: UIDataDetectorTypes) -> Self {
        dataDetectorTypes = types
        return self
    }
    
    @discardableResult
    func allowsEditingTextAttributes(_ bool: Bool) -> Self {
        allowsEditingTextAttributes = bool
        return self
    }
    
    @discardableResult
    func attributedText(_ text: NSAttributedString) -> Self {
        attributedText = text
        return self
    }
    
    @discardableResult
    func typingAttributes(_ attributes: [String : Any]) -> Self {
        typingAttributes = convertToNSAttributedStringKeyDictionary(attributes)
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
    
    @discardableResult
    func textContainerInset(_ inset: UIEdgeInsets) -> Self {
        textContainerInset = inset
        return self
    }
    
    @discardableResult
    func linkTextAttributes(_ attributes: [String : Any]) -> Self {
        linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary(attributes)
        return self
    }
    
    //MARK: - 添加UITextViewDelegate
    
    @discardableResult
    func addShouldBegindEditingBlock(_ handler: @escaping((UITextView)->(Bool))) -> Self {
        setShouldBegindEditingBlock(handler)
        return self
    }
    
    @discardableResult
    func addShouldEndEditingBlock(_ handler: @escaping((UITextView)->(Bool))) -> Self {
        setShouldEndEditingBlock(handler)
        return self
    }
    
    @discardableResult
    func addDidBeginEditingBlock(_ handler: @escaping((UITextView)->())) -> Self {
        setDidBeginEditingBlock(handler)
        return self
    }
    
    @discardableResult
    func addDidEndEditingBlock(_ handler: @escaping((UITextView)->())) -> Self {
        setDidEndEditingBlock(handler)
        return self
    }
    
    @discardableResult
    func addShouldChangeTextInRangeReplacementTextBlock(_ handler: @escaping((UITextView, NSRange, String)->(Bool))) -> Self {
        setShouldChangeTextInRangeReplacementTextBlock(handler)
        return self
    }
    
    @discardableResult
    func addDidChangeBlock(_ handler: @escaping((UITextView)->())) -> Self {
        setDidChangeBlock(handler)
        return self
    }
    
    @discardableResult
    func addDidChangeSelectionBlock(_ handler: @escaping((UITextView)->())) -> Self {
        setDidChangeSelectionBlock(handler)
        return self
    }
    
    @discardableResult
    @available(iOS 10.0, *)
    func addShouldInteractWithURLCharacterRangeInteractionBlock(_ handler: @escaping((UITextView, URL, NSRange, UITextItemInteraction)->(Bool))) -> Self {
        setShouldInteractWithURLCharacterRangeInteractionBlock(handler)
        return self
    }
    
    @discardableResult
    @available(iOS 10.0, *)
    func addShouldInteractWithTextAttachmentCharacterRangeInteractionBlock(_ handler: @escaping((UITextView, NSTextAttachment, NSRange, UITextItemInteraction)->(Bool))) -> Self {
        setShouldInteractWithTextAttachmentCharacterRangeInteractionBlock(handler)
        return self
    }
    
    @discardableResult
    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithURL:inRange:forInteractionType: instead")
    func addShouldInteractWithURLcharacterRangeBlock(_ handler: @escaping((UITextView, URL, NSRange)->(Bool))) -> Self {
        setShouldInteractWithURLcharacterRangeBlock(handler)
        return self
    }
    
    @discardableResult
    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithTextAttachment:inRange:forInteractionType: instead")
    func addShouldInteractWithTextAttachmentCharacterRangeBlock(_ handler: @escaping((UITextView, NSTextAttachment, NSRange)->(Bool))) -> Self {
        setShouldInteractWithTextAttachmentCharacterRangeBlock(handler)
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
