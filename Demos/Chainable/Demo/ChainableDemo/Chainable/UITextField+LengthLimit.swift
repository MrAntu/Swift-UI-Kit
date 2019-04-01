//
//  UITextField+LengthLimit.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/8.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

fileprivate let UITextFieldDisposebag = DisposeBag()
extension UITextField {
    
    fileprivate struct TextFieldMaxLengthKey {
        static var kTextFieldMaxLengthKey = "kUITextFieldMaxLengthKey"
    }
    
    public var maxLength: Int  {
        get {
            return (objc_getAssociatedObject(self, &TextFieldMaxLengthKey.kTextFieldMaxLengthKey) as? Int) ?? LONG_MAX
        }
        
        set(value) {
            var newValue = value
            if newValue < 1 {
                newValue = LONG_MAX
            }
            
            objc_setAssociatedObject(self, &TextFieldMaxLengthKey.kTextFieldMaxLengthKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            //
            //            self.rx.controlEvent(.editingChanged)
            //                .asObservable()
            //                .subscribe(onNext: { [weak self] in
            //                    self?.textFieldTextChanged()
            //                })
            //                .disposed(by: UITextFieldDisposebag)
            
            self.rx.text.orEmpty
                .map {[weak self] (text) -> Bool in
                    return text.count > self?.maxLength ?? Int.max
                }
                .share(replay: 1)
                .subscribe(onNext: {[weak self] (res) in
                    if res == true,
                        let strongSelf = self,
                        let text = self?.text {
                        let index = text.index(text.startIndex, offsetBy: strongSelf.maxLength)
                        self?.text = String(text[..<index])
                    }
                })
                .disposed(by: UITextFieldDisposebag)
            
        }
    }
    
    //    fileprivate func textFieldTextChanged() {
    //        let toBeString = self.text as NSString?
    //        guard let textStr = toBeString else {
    //            return
    //        }
    //        if textStr.length == 0 {
    //            return
    //        }
    //
    //        //获取高亮方法
    //        let selectedRange = self.markedTextRange ?? UITextRange()
    //        let position = self.position(from: selectedRange.start, offset: 0)
    //
    //        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    //        if position != nil {
    //            return
    //        }
    //        if (textStr.length ) > self.maxLength {
    //            let rangeIndex = textStr.rangeOfComposedCharacterSequence(at: self.maxLength)
    //            if rangeIndex.length == 1 {
    //                self.text = textStr.substring(to: self.maxLength)
    //            } else {
    //                let range = textStr.rangeOfComposedCharacterSequences(for: NSRange(location: 0, length: self.maxLength))
    //                self.text = textStr.substring(with: range)
    //            }
    //        }
    //    }
}
