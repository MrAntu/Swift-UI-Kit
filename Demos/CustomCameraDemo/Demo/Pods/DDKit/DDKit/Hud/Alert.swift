//
//  EBAlert.swift
//  EatojoyBiz
//
//  Created by senyuhao on 20/03/2018.
//  Copyright © 2018 dd01. All rights reserved.
//

import UIKit

extension AlertView {
    // 设置Title
    private func configTitle(title: String?, height: CGFloat) -> CGFloat {
        var now = height
        if let title = title {
            addSubview(lbFromInfo(rect: CGRect(x: 0, y: height, width: frame.size.width, height: 24), title: title, font: 18))
            now += 24
        }
        return now
    }

    // 设置subTitle
    private func configSubTitle(subTitle: NSMutableAttributedString?, height: CGFloat) -> CGFloat {
        var now = height
        if let subTitle = subTitle {
            let label = lbFromInfo(rect: CGRect(x: 15, y: now + 10, width: frame.size.width - 30, height: 0), title: "", font: 16)
            label.attributedText = subTitle
            let size = label.sizeThatFits(CGSize(width: frame.size.width - 30, height: 0))
            label.frame = CGRect(x: 15, y: now + 10, width: frame.size.width - 30, height: size.height)
            addSubview(label)
            now += size.height + 10
        }
        return now
    }
}

class AlertView: UIView {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public var alertBlock: ((Int) -> Void)?
    public var inputBlock: ((String) -> Void)?
    
    convenience init(info: AlertInfo, handler: @escaping (_ tag: Int) -> Void, inputHandler: @escaping (_ value: String) -> Void) {
        self.init(info: info, handler: handler)
        inputBlock = inputHandler
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardShow(notification: Notification) {
        if let userInfo = notification.userInfo as Dictionary? {
            let keyboardRec = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            if let heightValue = keyboardRec?.size.height {
                let offSetY = heightValue + self.frame.height / 2 - self.center.y
                if offSetY > 0 {
                    self.transform = CGAffineTransform(translationX: 0, y: -(offSetY + 10))
                }
            }
        }
    }
    
    @objc func keyboardHide(notification: Notification) {
        self.transform = CGAffineTransform.identity
    }
    
    convenience init(info: AlertInfo, handler: @escaping (_ tag: Int) -> Void) {
        self.init()
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        alertBlock = handler
        frame = CGRect(x: 0, y: 0, width: 280, height: 120)

        var height: CGFloat = 20
        height = configTitle(title: info.title, height: height)
        height = configSubTitle(subTitle: info.subTitle, height: height)

        if let content = info.content, !content.isEmpty {
            let contentLb = lbFromInfo(rect: .zero, title: content, font: 15)
            contentLb.textColor = Alert.shared.contentColor
            contentLb.textAlignment = info.subTitle != nil ? .left : Alert.shared.contentAlign
            let size = contentLb.sizeThatFits(CGSize(width: frame.size.width - 30, height: 0))
            contentLb.frame = CGRect(x: 15, y: height + 10, width: frame.size.width - 30.0, height: size.height)
            addSubview(contentLb)
            height += size.height + 10
        }
        
        if info.needInput != nil {
            addSubview(fieldInfo(rect: CGRect(x: 20, y: height + 10, width: frame.size.width - 40, height: 36)))
            height += 46
        }
        
        addSubview(lineFromRect(rect: CGRect(x: 0, y: height + 18, width: frame.size.width, height: 0.5)))
        height += 18.5
        
        var bnwidth: CGFloat = 0
        if let cancel = info.cancel, !cancel.isEmpty {
            bnwidth = frame.size.width / 2
            let cancelBn = bnFromInfo(rect: CGRect(x: 0, y: height, width: bnwidth, height: 48), tag: 0, title: cancel)
            cancelBn.setTitleColor(Alert.shared.cancelColor, for: .normal)
            addSubview(cancelBn)
            addSubview(lineFromRect(rect: CGRect(x: bnwidth, y: height, width: 0.5, height: 48)))
            bnwidth += 0.5
        }
        
        addSubview(bnFromInfo(rect: CGRect(x: bnwidth, y: height, width: frame.size.width - bnwidth, height: 48), tag: 1, title: info.sure))
        
        frame = CGRect(x: 0, y: 0, width: frame.size.width, height: height + 48)
        clipsToBounds = true
        layer.cornerRadius = 7
    }
    
    public func show(targetView: UIView) {
        if let window = targetView.window {
            if !existView(container: window) {
                showOnView(container: window)
            }
        } else {
            if let window = UIApplication.shared.keyWindow {
                if !existView(container: window) {
                    showOnView(container: window)
                }
            }
        }
    }

    private func existView(container: UIView) -> Bool {
        var exist = false
        for item in container.subviews where item.tag == NSIntegerMax - 1 {
            exist = true
        }
        return exist
    }
    
    public func showOnView(container: UIView) {
        let backView = UIView(frame: container.frame)
        backView.tag = NSIntegerMax - 1
        
        let maskView = UIView(frame: backView.frame)
        maskView.alpha = 0
        maskView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        backView.addSubview(maskView)
        backView.addSubview(self)
        center = backView.center
        container.addSubview(backView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        maskView.addGestureRecognizer(tap)
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        maskView.alpha = 0.5
        }, completion: { _ in
            
        })
    }
    
    @objc private func tapAction() {
        endEditing(true)
    }
    
    private func hiddenAction() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.alpha = 0.0
        }, completion: { finished in
            if finished {
                let backview = self.superview
                if backview?.tag == NSIntegerMax - 1 {
                    backview?.removeFromSuperview()
                    
                }
            }
        })
    }
    
    // MARK: - 界面元素方法生成
    private func lineFromRect(rect: CGRect) -> UIView {
        let label = UIView(frame: rect)
        label.autoresizingMask = .flexibleWidth
        label.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        return label
    }
    
    private func bnFromInfo(rect: CGRect, tag: Int, title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.autoresizingMask = .flexibleWidth
        btn.frame = rect
        btn.tag = tag
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        btn.setTitleColor(Alert.shared.sureColor, for: .normal)
        btn.addTarget(self, action: #selector(dismiss(_ : )), for: .touchUpInside)
        btn.clipsToBounds = true
        return btn
    }
    
    private func lbFromInfo(rect: CGRect, title: String, font: CGFloat) -> UILabel {
        let label = UILabel(frame: rect)
        label.text = title
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: font)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Alert.shared.titleColor
        label.autoresizingMask = .flexibleWidth
        return label
    }
    
    private func fieldInfo(rect: CGRect) -> UITextField {
        let field = UITextField(frame: rect)
        field.placeholder = NSLocalizedString("請輸入", comment: "")
        field.font = UIFont.systemFont(ofSize: 15)
        field.addTarget(self, action: #selector(textFieldChanged( _ :)), for: .editingChanged)
        field.borderStyle = .roundedRect
        return field
    }
    
    @objc func textFieldChanged(_ sender: UITextField) {
        if let text = sender.text, let input = inputBlock {
            input(text)
        }
    }
    
    @objc private func dismiss(_ sender: UIButton) {
        if inputBlock != nil, let value = Alert.shared.inputValue, !value.isEmpty {
            alertBlock?(sender.tag)
            hiddenAction()
            return
        }
        
        if inputBlock == nil, Alert.shared.inputValue == nil {
            alertBlock?(sender.tag)
            hiddenAction()
            return
        }
        
        if sender.tag == 0 {
            alertBlock?(sender.tag)
            hiddenAction()
            Alert.shared.inputValue = nil
        }
    }
}

public struct AlertInfo {
    var title: String?
    var subTitle: NSMutableAttributedString?
    var needInput: Bool?
    var cancel: String?
    var sure: String
    var content: String?
    var targetView: UIView
    
    public init(title: String? = nil,
                subTitle: NSMutableAttributedString? = nil,
                needInput: Bool? =  nil,
                cancel: String? = nil,
                sure: String,
                content: String? = nil,
                targetView: UIView) {
        self.title = title
        self.subTitle = subTitle
        self.needInput = needInput
        self.cancel = cancel
        self.sure = sure
        self.content = content
        self.targetView = targetView
    }
}

public class Alert: NSObject {
    public static let shared = Alert()
    public var cancelColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    public var sureColor: UIColor = #colorLiteral(red: 0.2139216065, green: 0.8187626004, blue: 0.6359331608, alpha: 1)
    public var titleColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    public var contentColor: UIColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
    public var contentAlign: NSTextAlignment = .center
    
    var inputValue: String?
    
    public func show(info: AlertInfo,
                     handler: @escaping (Int) -> Void) {
        let alertView = AlertView(info: info) { tag in
            handler(tag)
        }
        alertView.show(targetView: info.targetView)
    }
    
    public func show(info: AlertInfo,
                     handler: @escaping (Int) -> Void,
                     input: @escaping ((String) -> Void)) {
        let alertView = AlertView(info: info,
                                  handler: { tag in
                                    handler(tag)
        },
                                  inputHandler: { value in
                                    input(value)
        })
        alertView.show(targetView: info.targetView)
    }
}
