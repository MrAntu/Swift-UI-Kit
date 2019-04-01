//
//  MenuViewController.swift
//  EatojoyBiz
//
//  Created by 胡峰 on 2017/3/8.
//  Copyright © 2018年 dd01. All rights reserved.
//

import Foundation
import UIKit

public struct MenuItem {
    
    let title: String
    let image: UIImage?
    let isShowRedDot: Bool?
    let action: () -> Void
    
    public init(title: String,
                image: UIImage? = nil,
                isShowRedDot: Bool? =  nil,
                action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.isShowRedDot = isShowRedDot
        self.action = action
    }
}

public class OCMenuItem: NSObject {
    let menuItem: MenuItem
    
    public init(title: String, image: UIImage?, isShowRedDot: Bool, action:@escaping () -> Void) {
        menuItem = MenuItem(title: title, image: image, isShowRedDot: isShowRedDot, action: action)
        super.init()
    }
}

class MenuPopoverBackgroundView: UIPopoverBackgroundView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.shadowColor = UIColor.clear.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override static func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: -9, left: 0, bottom: 9, right: 0)
    }
    
    static override func arrowHeight() -> CGFloat {
        return 10
    }
    
    override static func arrowBase() -> CGFloat {
        return 0
    }
    
    override var arrowDirection: UIPopoverArrowDirection {
        get {
            return .up
        }
        set {
            
        }
    }
    
    override var arrowOffset: CGFloat {
        get {
            return 30
        }
        set {
            
        }
    }
    
}

public class MenuViewController: PopViewController {
    
    let items: [MenuItem]
    
    override var style: PopControllerStyle {
        return .popover
    }
    
    override var cornerRadius: CGFloat {
        return 6
    }
    
    var menuRowHeight: CGFloat = 45
    
    public init(items: [MenuItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(ocItems: [OCMenuItem]) {
        var items = [MenuItem]()
        for ocItem in ocItems {
            items.append(ocItem.menuItem)
        }
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        dimmingView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        self.popoverPresentationController?.backgroundColor = UIColor.clear
        self.popoverPresentationController?.popoverBackgroundViewClass = MenuPopoverBackgroundView.self
        self.preferredContentSize = CGSize(width: 124, height: 120)
        self.layoutViews()
    }
    
    deinit {
        print("MenuViewController deinit")
    }
    
    private func layoutViews() {
        let max = CGFloat.greatestFiniteMagnitude
        let titleWidths = items.map { (sizeWithText(text: ($0.title as NSString), font: UIFont.systemFont(ofSize: 15), size: CGSize(width: max, height: max))).size.width }
        let maxWidth = titleWidths.max() ?? 70
        self.preferredContentSize = CGSize(width: maxWidth + 80, height: menuRowHeight * CGFloat(items.count) + 30)
        if let path = Bundle(for: MenuViewController.classForCoder()).path(forResource: "CoreBundle", ofType: "bundle"), let bundle = Bundle(path: path) {
            let image = UIImage(named: "popupIos", in: bundle, compatibleWith: nil)
            let backgroundImage = UIImageView(image: image?.resizableImage(withCapInsets: UIEdgeInsets(top: 69, left: 43, bottom: 69, right: 43), resizingMode: .stretch))
            backgroundImage.frame = CGRect(x: 0, y: 8, width: self.preferredContentSize.width, height: self.preferredContentSize.height - 20)
            backgroundImage.layer.cornerRadius = 3
            backgroundImage.clipsToBounds = true
            view.addSubview(backgroundImage)
        }
        
        for (offset, item) in items.enumerated() {
            let button = UIButton(type: .custom)
//            button.setImage(item.image, for: .normal)
            button.setTitle(item.title, for: .normal)
            button.setTitleColor(UIColor.darkGray, for: .normal)
            button.frame = CGRect(x: 0, y: CGFloat(offset) * menuRowHeight + 18, width: self.preferredContentSize.width, height: menuRowHeight)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.addTarget(self, action: #selector(self.buttonAction(button:)), for: .touchUpInside)
            button.tag = 1_155 + offset
            view.addSubview(button)
            
            if item.isShowRedDot == true {
                let redDotImgeView = UIImageView(image: #imageLiteral(resourceName: "red_notice_small"))
                redDotImgeView.frame = CGRect(x: button.frame.width * 0.25, y: button.frame.height * 0.2, width: 10, height: 10)
                button.addSubview(redDotImgeView)
            }
            
//            let titleWidth = titleWidths[offset]
//            let contentWidth = (item.image?.size.width ?? 0) + titleWidth
//            var edge = (self.preferredContentSize.width - contentWidth) / 2 - 20
//            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -edge, bottom: 0, right: edge)
//            edge -= 15
//            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -edge, bottom: 0, right: edge)
            
            if offset != items.count - 1 {
                let line = UIView(frame: CGRect(x: 20, y: CGFloat(offset + 1) * 44 + 18, width: self.view.frame.size.width - 40, height: 1 / UIScreen.main.scale))
                line.autoresizingMask = .flexibleWidth
                line.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
                view.addSubview(line)
            }
        }
    }
    
    @objc private func buttonAction(button: UIButton) {
        let index = button.tag - 1_155
        if items.count > index {
            removeDimmingView()
            dismiss(animated: true) {
                    self.items[index].action()
            }
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeShadow()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeDimmingView()
    }
    
    // MARK: - 移除自带的阴影，添加黑色半透明背景蒙层
    
    let dimmingView = UIView()
    
    /// 移除自带的阴影
    func removeShadow() {
        if let window = UIApplication.shared.delegate?.window {
            let transitionView = window?.subviews.filter { subview -> Bool in
                type(of: subview) == NSClassFromComponents("UI", "Transition", "View")
            }
            let patchView = transitionView?.first?.subviews.filter { subview -> Bool in
                type(of: subview) == NSClassFromComponents("_", "UI", "Mirror", "Nine", "PatchView")
            }
            if let imageViews = patchView?.first?.subviews.filter({ subview -> Bool in
                type(of: subview) == UIImageView.self
            }) {
                for imageView in imageViews {
                    imageView.isHidden = true
                }
            }
        }
    }
    
    /// 使用私有类，避免私有 API 扫描检查二进制包的字串
    func NSClassFromComponents(_ components: String...) -> AnyClass? {
        return NSClassFromString(components.joined())
    }
    
    func sizeWithText(text: NSString, font: UIFont, size: CGSize) -> CGRect {
//        let attributes = [NSAttributedStringKey.font: font]
//        let option = NSStringDrawingOptions.usesLineFragmentOrigin
//        let rect:CGRect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    }
    
    private func removeDimmingView() {
        UIView.animate(withDuration: 0.1,
                       animations: {
            self.dimmingView.alpha = 0
        }, completion: { complete in
            if complete {
                self.dimmingView.removeFromSuperview()
            }
        })
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        if let presentingViewController = presentingViewController {
            dimmingView.frame = presentingViewController.view.bounds
            dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            dimmingView.alpha = 0
            presentingViewController.view.addSubview(dimmingView)
            let transitionCoordinator = presentingViewController.transitionCoordinator
            transitionCoordinator?.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1
            }, completion: nil)
        }
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        removeDimmingView()
        return true
    }
}
