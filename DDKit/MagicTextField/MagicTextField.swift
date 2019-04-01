//
//  MagicTextField.swift
//  MagicTextFieldDemo
//
//  Created by leo on 2018/12/7.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

public class MagicTextField: UITextField {
    // public property
    //placeholder移动后的字体大小
    public var animatedFont: UIFont? = UIFont.systemFont(ofSize: 12)
    //placeholder移动后的文字显示
    public var animatedText: String?
    //placeholder向上移动的距离，负数向下
    public var moveDistance: CGFloat = 0.0
    //UITextFieldDidChange事件回调
    public var magicFieldDidChangeCallBack: (()->())?
    //placeholder的颜色,默认为灰色
    public var placeholderColor: UIColor? {
        didSet {
            placeholderAnimationLab.textColor = placeholderColor
            animatedPlaceholderColor = placeholderColor
        }
    }
    //placeholder移动后的颜色,默认为placeholderColor,设置此属性一定要在设置placeholderColor的后面
    public var animatedPlaceholderColor: UIColor?
    //离输入框左边的边距,默认为0
    public var marginLeft: CGFloat = 0
    //重写父类placeholder
    override public var placeholder: String? {
        didSet {
            placeholderAnimationLab.text = placeholder
            self.tmpPlaceholder = placeholder
            super.placeholder = ""
        }
    }
    //重写父类textAlignment
    override public var textAlignment: NSTextAlignment {
        didSet {
            placeholderAnimationLab.textAlignment = textAlignment
        }
    }
    //重写父类font
    override public var font: UIFont? {
        didSet {
            placeholderFont = font
            placeholderAnimationLab.font = font
            animatedFont = font
            super.font = font
        }
    }
    
    private var isFirstLoad: Bool = true
    private lazy var placeholderAnimationLab: UILabel = {
        let animationLab = UILabel()
        animationLab.isUserInteractionEnabled = false
        animationLab.textColor = UIColor(red: 136.0/255.0, green: 136.0/255.0, blue: 136.0/255.0, alpha: 0.6)
        return animationLab
    }()
    private var placeholderFont: UIFont?
    private var tmpPlaceholder:String?
    
    public init() {
        super.init(frame: CGRect.zero)
        moveDistance = frame.size.height / 2
        setupUI()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        moveDistance = frame.size.height / 2
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        if isFirstLoad == true {
            isFirstLoad = false
            var rect = bounds
            rect.origin.x = rect.origin.x + marginLeft
            rect.size.width = rect.width - marginLeft
            placeholderAnimationLab.frame = rect

            leftView = UIView(frame: CGRect(x: 0, y: 0, width: marginLeft, height: 0))
            leftViewMode = .always
        }
    }
    
    override public func becomeFirstResponder() -> Bool {
        startAnimation()
        return super.becomeFirstResponder()
    }
    
    override public func resignFirstResponder() -> Bool {
        restoreAnimation()
        return super.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MagicTextField {
    func startAnimation() {
        var targetFrame = self.placeholderAnimationLab.frame
        targetFrame.origin.y = -moveDistance
        UIView.animate(withDuration: 0.25) {
            self.placeholderAnimationLab.frame = targetFrame
            self.placeholderAnimationLab.textColor = self.animatedPlaceholderColor
            self.placeholderAnimationLab.font = self.animatedFont
            self.placeholderAnimationLab.text = self.animatedText?.count == 0 ? self.placeholderAnimationLab.text : self.animatedText
        }
    }
    
    func restoreAnimation() {
        if text?.count ?? 0 > 0 || placeholderAnimationLab.frame.origin.y == 0 {
            return
        }
        var targetFrame = self.placeholderAnimationLab.frame
        targetFrame.origin.y = 0
        
        UIView.animate(withDuration: 0.25) {
            self.placeholderAnimationLab.frame = targetFrame
            self.placeholderAnimationLab.textColor = self.placeholderColor
            self.placeholderAnimationLab.font = self.placeholderFont
            self.placeholderAnimationLab.text = self.tmpPlaceholder
        }
    }
}

private extension MagicTextField {
    func setupUI() {
        placeholderColor = placeholderAnimationLab.textColor
        animatedPlaceholderColor = placeholderColor
        addSubview(placeholderAnimationLab)
        NotificationCenter.default.addObserver(self, selector: #selector(changeEditing), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    @objc func changeEditing() {
        if let callBack = magicFieldDidChangeCallBack {
            callBack()
        }
        self.placeholderAnimationLab.isHidden = false
    }
}

