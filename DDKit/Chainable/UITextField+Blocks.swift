//
//  UITextField+Blocks.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/8.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    fileprivate struct TextFieldKey {
        static var UITextFieldShouldBeginEditingShakeKey = "UITextFieldShouldBeginEditingShakeKey"
        static var UITextFieldShouldBeginEditingKey = "UITextFieldShouldBeginEditingKey"
        static var UITextFieldShouldEndEditingKey = "UITextFieldShouldEndEditingKey"
        static var UITextFieldDidBeginEditingKey = "UITextFieldDidBeginEditingKey"
        static var UITextFieldDidEndEditingKey = "UITextFieldDidEndEditingKey"
        static var UITextFieldShouldChangeCharactersInRangeKey = "UITextFieldShouldChangeCharactersInRangeKey"
        static var UITextFieldShouldClearKey = "UITextFieldShouldClearKey"
        static var UITextFieldShouldReturnKey = "UITextFieldShouldReturnKey"
    }
    
    fileprivate var shouldBegindEditingBlock: ((UITextField)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &TextFieldKey.UITextFieldShouldBeginEditingKey) as? ((UITextField) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextFieldKey.UITextFieldShouldBeginEditingKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var shouldEndEditingBlock: ((UITextField)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &TextFieldKey.UITextFieldShouldEndEditingKey) as? ((UITextField) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextFieldKey.UITextFieldShouldEndEditingKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var didBeginEditingBlock: ((UITextField)->())? {
        get {
            return objc_getAssociatedObject(self, &TextFieldKey.UITextFieldDidBeginEditingKey) as? ((UITextField) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextFieldKey.UITextFieldDidBeginEditingKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var didEndEditingBlock: ((UITextField)->())? {
        get {
            return objc_getAssociatedObject(self, &TextFieldKey.UITextFieldDidEndEditingKey) as? ((UITextField) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextFieldKey.UITextFieldDidEndEditingKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var shouldChangeCharactersInRangeBlock: ((UITextField, NSRange, String)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &TextFieldKey.UITextFieldShouldChangeCharactersInRangeKey) as? ((UITextField, NSRange, String) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextFieldKey.UITextFieldShouldChangeCharactersInRangeKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var shouldReturnBlock: ((UITextField)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &TextFieldKey.UITextFieldShouldReturnKey) as? ((UITextField) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextFieldKey.UITextFieldShouldReturnKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var shouldClearBlock: ((UITextField)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &TextFieldKey.UITextFieldShouldClearKey) as? ((UITextField) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &TextFieldKey.UITextFieldShouldClearKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate func setDelegate() {
        if delegate == nil || delegate?.isEqual(self) == false {
            delegate = self
        }
    }
}

// MARK: - Public Method
extension UITextField {
    /// 当输入框进入编辑的是否需要震动动画
    public var shouldBegindEditingShake: Bool? {
        get {
            return objc_getAssociatedObject(self, &TextFieldKey.UITextFieldShouldBeginEditingShakeKey) as? Bool
        }
        set(value) {
            objc_setAssociatedObject(self, &TextFieldKey.UITextFieldShouldBeginEditingShakeKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    public func setShouldBegindEditingBlock(_ handler: @escaping((UITextField)->(Bool))) {
        shouldBegindEditingBlock = handler
    }
    
    public func setShouldEndEditingBlock(_ handler: @escaping((UITextField)->(Bool))) {
        shouldEndEditingBlock = handler
    }
    
    public func setDidBeginEditingBlock(_ handler: @escaping((UITextField)->())) {
        didBeginEditingBlock = handler
    }
    
    public func setDidEndEditingBlock(_ handler: @escaping((UITextField)->())) {
        didEndEditingBlock = handler
    }
    
    public func setShouldChangeCharactersInRangeBlock(_ handler: @escaping((UITextField, NSRange, String)->(Bool))) {
        shouldChangeCharactersInRangeBlock = handler
    }
    
    public func setShouldReturnBlock(_ handler: @escaping((UITextField)->(Bool))) {
        shouldReturnBlock = handler
    }
    
    public func setShouldClearBlock(_ handler: @escaping((UITextField)->(Bool))) {
        shouldClearBlock = handler
    }
}


// MARK: - UITextFieldDelegate
extension UITextField: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var res: Bool = true
        if shouldBegindEditingShake != nil && shouldBegindEditingShake == true {
            self.shake()
        }
    
        if let block = shouldBegindEditingBlock {
            res = block(textField)
        }
    
//        if let delegate = chainalbeDelegate,
//            let value = delegate.textFieldShouldBeginEditing?(textField) {
//            res = value
//        }
        return res 
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        var res: Bool = true
        if let block = shouldEndEditingBlock {
            res = block(textField)
        }

//        if let delegate = chainalbeDelegate,
//            let value = delegate.textFieldShouldEndEditing?(textField) {
//            res = value
//        }
        return res
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditingBlock?(textField)
//        if let delegate = chainalbeDelegate {
//            delegate.textFieldDidBeginEditing?(textField)
//        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditingBlock?(textField)
//        if let delegate = chainalbeDelegate {
//            delegate.textFieldDidEndEditing?(textField)
//        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var res: Bool = true
        if let block = shouldChangeCharactersInRangeBlock {
           res = block(textField, range, string)
        }
//        if let delegate = chainalbeDelegate,
//            let value = delegate.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) {
//            res = value
//        }
        return res
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var res: Bool = true
        if let block = shouldReturnBlock {
            res = block(textField)
        }
//        if let delegate = chainalbeDelegate,
//            let value = delegate.textFieldShouldReturn?(textField) {
//            res = value
//        }
        return res
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        var res: Bool = true
        if let block = shouldClearBlock {
            res = block(textField)
        }
//        if let delegate = chainalbeDelegate,
//            let value = delegate.textFieldShouldClear?(textField) {
//            res = value
//        }
        return res
    }
}
