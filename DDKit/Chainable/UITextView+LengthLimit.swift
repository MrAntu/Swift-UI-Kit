//
//  UITextView+LengthLimit.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

fileprivate let UITextViewDisposebag = DisposeBag()

extension UITextView {
    fileprivate struct TextViewMaxLengthKey {
        static var kTextViewMaxLengthKey = "kTextViewMaxLengthKey"
    }
    
    public var maxLength: Int  {
        get {
            return (objc_getAssociatedObject(self, &TextViewMaxLengthKey.kTextViewMaxLengthKey) as? Int) ?? LONG_MAX
        }
        
        set(value) {
            var newValue = value
            if newValue < 1 {
                newValue = LONG_MAX
            }
            
            objc_setAssociatedObject(self, &TextViewMaxLengthKey.kTextViewMaxLengthKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            //            NotificationCenter.default
            //                .rx.notification(NSNotification.Name.UITextViewTextDidChange)
            //                .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
            //                .subscribe(onNext: {[weak self] _ in
            //                    self?.textViewTextChanged()
            //                })
            //                .disposed(by: UITextViewDisposebag)
            
            self.rx.text.orEmpty
                .map {[weak self] (text) -> Bool in
                    return text.count > self?.maxLength ?? LONG_MAX
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
                .disposed(by: UITextViewDisposebag)
        }
    }
    
    //    fileprivate func  textViewTextChanged() {
    //        let toBeString = self.text as NSString?
    //        guard let textStr = toBeString else {
    //            return
    //        }
    //
    //        if textStr.length == 0 {
    //            return
    //        }
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
