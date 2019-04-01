//
//  UITextView+Blocks.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/9.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit
extension UITextView {
    fileprivate struct TextViewKey {
        static var UITextViewShouldBeginEditingKey = "UITextViewShouldBeginEditingKey"
        static var UITextViewShouldEndEditingKey = "UITextViewShouldEndEditingKey"
        static var UITextViewDidBeginEditingKey = "UITextViewDidBeginEditingKey"
        static var UITextViewDidEndEditingKey = "UITextViewDidEndEditingKey"
        static var UITextViewShouldChangeTextInRangeReplacementText = "UITextViewShouldChangeTextInRangeReplacementText"
        static var UITextViewDidChangeKey = "UITextViewDidChangeKey"
        static var UITextViewDidChangeSelectionKey = "UITextViewDidChangeSelectionKey"
        static var UITextViewshouldInteractWithURLCharacterRangeInteraction = "UITextViewshouldInteractWithURLCharacterRangeInteraction"
        static var UITextViewShouldInteractWithTextAttachmentCharacterRangeInteraction = "UITextViewShouldInteractWithTextAttachmentCharacterRangeInteraction"
        static var UITextViewshouldInteractWithURLcharacterRange = "UITextViewshouldInteractWithURLcharacterRange"
        static var UITextViewShouldInteractWithTextAttachmentCharacterRange = "UITextViewShouldInteractWithTextAttachmentCharacterRange"
    }
    
    fileprivate var shouldBegindEditingBlock: ((UITextView)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &TextViewKey.UITextViewShouldBeginEditingKey) as? ((UITextView) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextViewKey.UITextViewShouldBeginEditingKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var shouldEndEditingBlock: ((UITextView)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &TextViewKey.UITextViewShouldEndEditingKey) as? ((UITextView) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextViewKey.UITextViewShouldEndEditingKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var didBeginEditingBlock: ((UITextView)->())? {
        get {
            return objc_getAssociatedObject(self, &TextViewKey.UITextViewDidBeginEditingKey) as? ((UITextView) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextViewKey.UITextViewDidBeginEditingKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var didEndEditingBlock: ((UITextView)->())? {
        get {
            return objc_getAssociatedObject(self, &TextViewKey.UITextViewDidEndEditingKey) as? ((UITextView) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextViewKey.UITextViewDidEndEditingKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var shouldChangeTextInRangeReplacementTextBlock: ((UITextView, NSRange, String)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &TextViewKey.UITextViewShouldChangeTextInRangeReplacementText) as? ((UITextView, NSRange, String) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextViewKey.UITextViewShouldChangeTextInRangeReplacementText, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var didChangeBlock: ((UITextView)->())? {
        get {
            return objc_getAssociatedObject(self, &TextViewKey.UITextViewDidChangeKey) as? ((UITextView) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextViewKey.UITextViewDidChangeKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var didChangeSelectionBlock: ((UITextView)->())? {
        get {
            return objc_getAssociatedObject(self, &TextViewKey.UITextViewDidChangeSelectionKey) as? ((UITextView) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextViewKey.UITextViewDidChangeSelectionKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    @available(iOS 10.0, *)
    fileprivate var shouldInteractWithURLCharacterRangeInteractionBlock: ((UITextView, URL, NSRange, UITextItemInteraction)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &TextViewKey.UITextViewshouldInteractWithURLCharacterRangeInteraction) as? ((UITextView, URL, NSRange, UITextItemInteraction) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextViewKey.UITextViewshouldInteractWithURLCharacterRangeInteraction, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    @available(iOS 10.0, *)
    fileprivate var shouldInteractWithTextAttachmentCharacterRangeInteractionBlock: ((UITextView, NSTextAttachment, NSRange, UITextItemInteraction)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &TextViewKey.UITextViewShouldInteractWithTextAttachmentCharacterRangeInteraction) as? ((UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextViewKey.UITextViewShouldInteractWithTextAttachmentCharacterRangeInteraction, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithURL:inRange:forInteractionType: instead")
    fileprivate var shouldInteractWithURLcharacterRangeBlock: ((UITextView, URL, NSRange)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &TextViewKey.UITextViewshouldInteractWithURLcharacterRange) as? ((UITextView, URL, NSRange) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextViewKey.UITextViewshouldInteractWithURLcharacterRange, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithTextAttachment:inRange:forInteractionType: instead")
    fileprivate var shouldInteractWithTextAttachmentCharacterRangeBlock: ((UITextView, NSTextAttachment, NSRange)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &TextViewKey.UITextViewShouldInteractWithTextAttachmentCharacterRange) as? ((UITextView, NSTextAttachment, NSRange) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextViewKey.UITextViewShouldInteractWithTextAttachmentCharacterRange, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate func setDelegate() {
        if delegate == nil || delegate?.isEqual(self) == false {
            delegate = self
        }
    }
}


// MARK: - Public Method
extension UITextView {
    public func setShouldBegindEditingBlock(_ handler: @escaping((UITextView)->(Bool))) {
        shouldBegindEditingBlock = handler
    }
    
    public func setShouldEndEditingBlock(_ handler: @escaping((UITextView)->(Bool))) {
        shouldEndEditingBlock = handler
    }
    
    public func setDidBeginEditingBlock(_ handler: @escaping((UITextView)->())) {
        didBeginEditingBlock = handler
    }
    
    public func setDidEndEditingBlock(_ handler: @escaping((UITextView)->())) {
        didEndEditingBlock = handler
    }
    
    public func setShouldChangeTextInRangeReplacementTextBlock(_ handler: @escaping((UITextView, NSRange, String)->(Bool))) {
        shouldChangeTextInRangeReplacementTextBlock = handler
    }
    
    public func setDidChangeBlock(_ handler: @escaping((UITextView)->())) {
        didChangeBlock = handler
    }
    
    public func setDidChangeSelectionBlock(_ handler: @escaping((UITextView)->())) {
        didChangeSelectionBlock = handler
    }
    
    @available(iOS 10.0, *)
    public func setShouldInteractWithURLCharacterRangeInteractionBlock(_ handler: @escaping((UITextView, URL, NSRange, UITextItemInteraction)->(Bool))) {
        shouldInteractWithURLCharacterRangeInteractionBlock = handler
    }
    
    @available(iOS 10.0, *)
    public func setShouldInteractWithTextAttachmentCharacterRangeInteractionBlock(_ handler: @escaping((UITextView, NSTextAttachment, NSRange, UITextItemInteraction)->(Bool))) {
        shouldInteractWithTextAttachmentCharacterRangeInteractionBlock = handler
    }
    
    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithURL:inRange:forInteractionType: instead")
    public func setShouldInteractWithURLcharacterRangeBlock(_ handler: @escaping((UITextView, URL, NSRange)->(Bool))) {
        shouldInteractWithURLcharacterRangeBlock = handler
    }
    
    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithTextAttachment:inRange:forInteractionType: instead")
    public func setShouldInteractWithTextAttachmentCharacterRangeBlock(_ handler: @escaping((UITextView, NSTextAttachment, NSRange)->(Bool))) {
        shouldInteractWithTextAttachmentCharacterRangeBlock = handler
    }
}

extension UITextView: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if let block = shouldBegindEditingBlock {
            return block(textView)
        }
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if let block = shouldEndEditingBlock {
            return block(textView)
        }
        return true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
       didBeginEditingBlock?(textView)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        didEndEditingBlock?(textView)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let block = shouldChangeTextInRangeReplacementTextBlock {
            return block(textView, range, text)
        }
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        didChangeBlock?(textView)
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        didChangeSelectionBlock?(textView)
    }
    
    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithURL:inRange:forInteractionType: instead")
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if let block = shouldInteractWithURLcharacterRangeBlock {
            return block(textView, URL, characterRange)
        }
        return true
    }
    
    @available(iOS, introduced: 7.0, deprecated: 10.0, message: "Use textView:shouldInteractWithTextAttachment:inRange:forInteractionType: instead")
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        if let block = shouldInteractWithTextAttachmentCharacterRangeBlock {
            return block(textView, textAttachment, characterRange)
        }
        return true
    }
  
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let block = shouldInteractWithURLCharacterRangeInteractionBlock {
            return block(textView, URL, characterRange, interaction)
        }
        return true
    }
    
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let block = shouldInteractWithTextAttachmentCharacterRangeInteractionBlock {
            return block(textView, textAttachment, characterRange, interaction)
        }
        return true
    }
    

}
