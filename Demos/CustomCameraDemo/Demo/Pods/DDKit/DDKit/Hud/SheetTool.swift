//
//  SheetTool.swift
//  Sheet
//
//  Created by senyuhao on 2018/7/1.
//  Copyright © 2018年 dd01. All rights reserved.
//

import SnapKit
import UIKit

public class SheetTool: NSObject {
    public static let shared = SheetTool()
    public var titlesColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    public var cancelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    public var destructiveColor = #colorLiteral(red: 0.9316427112, green: 0.1361732781, blue: 0.1165842786, alpha: 1)
    public var font = UIFont.systemFont(ofSize: 16)
    public var height: CGFloat = 44.0
    public var messageFont = UIFont.systemFont(ofSize: 14)
    public var titleFont = UIFont.systemFont(ofSize: 16)
    public var messageColor = UIColor.lightGray
    
    public func show(value:(title: String?, message: String?, destructive: String?)?,
                     cancel: String,
                     titles: [String],
                     target: UIView,
                     handler: @escaping(Int) -> Void) {
        let sheet = CustomActionSheet(value: value, cancel: cancel, titles: titles) { tag in
            handler(tag)
        }
        let height = CGFloat(titles.count + 1) * (SheetTool.shared.height + 0.5) + 5
        var currentHeight: CGFloat = height
        if let value = value {
            if value.destructive != nil {
                currentHeight += SheetTool.shared.height
            }
            if value.message != nil {
                currentHeight += 30
            }
            if value.title != nil {
                currentHeight += 40
            }
        }
        sheet.show(target: target, height: currentHeight)
    }
    
    public func show(value:(title: String?, message: String?)? = nil,
                     cancel: String,
                     titles: [String],
                     target: UIView,
                     handler: @escaping(Int) -> Void) {
        SheetTool.shared.show(value: (title: value?.title, message: value?.message, destructive: nil), cancel: cancel, titles: titles, target: target, handler: handler)
    }
}

class CustomActionSheet: UIView {
    
    private var sheetBlock: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9725490196, blue: 0.9803921569, alpha: 1)
    }
    
    convenience init(value:(title: String?, message: String?, destructive: String?)? = nil,
                     cancel: String,
                     titles: [String],
                     handler: @escaping(Int) -> Void) {
        self.init(frame: .zero)
        sheetBlock = handler
        let cancelBtn = createCancelBtn(cancel: cancel)
        
        for (index, value) in titles.enumerated() {
            let offset = -(5.0 + (SheetTool.shared.height + 0.5) * CGFloat(index))
            let button = configButton(tag: index + 1, title: value, color: SheetTool.shared.titlesColor)
            addSubview(button)
            button.snp.makeConstraints { make in
                make.bottom.equalTo(cancelBtn.snp.top).offset(offset)
                make.left.right.equalTo(self)
                make.height.equalTo(SheetTool.shared.height)
            }
        }
        
        if let value = value {
            var offset = -(5.0 + (SheetTool.shared.height + 0.5) * CGFloat(titles.count))
            
            if let destructive = value.destructive {
                let destructiveBtn = configButton(tag: titles.count + 1, title: destructive, color: SheetTool.shared.destructiveColor)
                addSubview(destructiveBtn)
                destructiveBtn.snp.makeConstraints { make in
                    make.bottom.equalTo(cancelBtn.snp.top).offset(offset)
                    make.left.right.equalTo(self)
                    make.height.equalTo(SheetTool.shared.height)
                }
                offset -= SheetTool.shared.height
            }
            
            if let message = value.message {
                let messageLabel = configLabel(title: message,
                                               font: SheetTool.shared.messageFont,
                                               color: SheetTool.shared.messageColor)
                addSubview(messageLabel)
                messageLabel.snp.makeConstraints { make in
                    make.bottom.equalTo(cancelBtn.snp.top).offset(offset)
                    make.left.right.equalTo(self)
                    make.height.equalTo(30)
                }
                offset -= 30
            }
            
            if let title = value.title {
                let titleLabel = configLabel(title: title,
                                             font: SheetTool.shared.titleFont,
                                             color: SheetTool.shared.titlesColor)
                addSubview(titleLabel)
                titleLabel.snp.makeConstraints { make in
                    make.bottom.equalTo(cancelBtn.snp.top).offset(offset)
                    make.left.right.equalTo(self)
                    make.height.equalTo(40)
                }
            }
        }
    }
    
    private func createCancelBtn(cancel: String) -> UIButton {
        let cancelBtn = configButton(tag: 0, title: cancel, color: SheetTool.shared.cancelColor)
        addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.left.right.equalTo(self)
            make.height.equalTo(SheetTool.shared.height)
        }
        return cancelBtn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(target: UIView, height: CGFloat) {
        let window = target is UIWindow ? target : target.window
        if let window = window {
            let groundView = UIView(frame: .zero)
            groundView.tag = NSIntegerMax
            window.addSubview(groundView)
            groundView.snp.makeConstraints { make in
                make.top.left.right.equalTo(window)
                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(window.safeAreaLayoutGuide.snp.bottom)
                } else {
                    make.bottom.equalTo(window)
                }
            }
            
            let maskView = UIView(frame: .zero)
            maskView.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.2, blue: 0.2, alpha: 0.3)
            maskView.alpha = 0
            groundView.addSubview(maskView)
            maskView.snp.makeConstraints { make in
                make.top.left.right.bottom.equalTo(groundView)
            }
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
            maskView.addGestureRecognizer(gesture)
            
            groundView.addSubview(self)
            snp.makeConstraints { make in
                make.bottom.left.right.equalTo(groundView)
                make.height.equalTo(height)
            }
            transform = CGAffineTransform(translationX: 0, y: height)
            UIView.animate(withDuration: 0.4) { [weak self] in
                maskView.alpha = 1
                self?.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }
    }
    
    private func configButton(tag: Int, title: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = tag
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = SheetTool.shared.font
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.addTarget(self, action: #selector(buttonAction(_ :)), for: .touchUpInside)
        return button
    }
    
    private func configLabel(title: String, font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel(frame: .zero)
        label.textColor = color
        label.font = font
        label.text = title
        label.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        return label
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        sheetBlock?(sender.tag)
        dismiss()
    }
    
    @objc private func tapGestureAction() {
        dismiss()
    }
    
    private func dismiss() {
        let height = frame.size.height
        UIView.animate(withDuration: 0.3,
                       animations: { [weak self] in
                        self?.transform = CGAffineTransform(translationX: 0, y: height)
        },
                       completion: { [weak self] finished in
                        if finished {
                            if self?.superview?.tag == NSIntegerMax {
                                self?.superview?.removeFromSuperview()
                            }
                        }
        })
    }
}
