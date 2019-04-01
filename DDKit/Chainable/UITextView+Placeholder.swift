//
//  UITextView+Placeholder.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    fileprivate struct TextViewPlaceholderKey {
        static var kTextViewPlaceholderKey = "kTextViewPlaceholderKey"
    }

    public var placeholder: String? {
        get {
            return objc_getAssociatedObject(self, &TextViewPlaceholderKey.kTextViewPlaceholderKey) as? String
        }
        
        set(value) {
            objc_setAssociatedObject(self, &TextViewPlaceholderKey.kTextViewPlaceholderKey, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            let label = UILabel()
                            .text(value)
                            .numberOfLines(0)
                            .textColor(UIColor.lightGray)
                            .font(self.font ?? 13)
                            .sizeFit()
                            .add(to: self)
            self .setValue(label, forKey: "_placeholderLabel")
        }
    }
}
