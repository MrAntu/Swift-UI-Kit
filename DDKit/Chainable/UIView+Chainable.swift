//
//  UIView+Chainable.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

// MARK: - UIView
public extension UIKitChainable where Self: UIView  {
    
    /// 支持SnapKit- remakeConstraints布局，请在addSubView方法后再调用，否则崩溃
    ///
    /// - Parameter handler: handler
    /// - Returns: self
    @discardableResult
    func remakeConstraints(_ handler: (_ make: ConstraintMaker) -> Void) -> Self {
        self.snp.remakeConstraints(handler)
        return self
    }
    
    /// 支持SnapKit- makeConstraints布局，请在addSubView方法后再调用，否则崩溃
    ///
    /// - Parameter closure: 回调
    /// - Returns: self
    @discardableResult
    func makeConstraints(_ handler: (_ make: ConstraintMaker) -> Void) -> Self {
        self.snp.makeConstraints(handler)
        return self
    }
    
    /// 支持SnapKit- updateConstraints布局，请在addSubView方法后再调用，否则崩溃
    ///
    /// - Parameter closure: 回调
    /// - Returns: self
    @discardableResult
    func updateConstraints(_ handler: (_ make: ConstraintMaker) -> Void) -> Self {
        self.snp.updateConstraints(handler)
        return self
    }
    
    /// 支持SnapKit- removeConstraints布局，请在addSubView方法后再调用，否则崩溃
    ///
    /// - Parameter closure: 回调
    /// - Returns: self
    @discardableResult
    func removeConstraints() -> Self {
        self.snp.removeConstraints()
        return self
    }
    
    /// 显示到的 superview
    ///
    /// - Parameter superview: `父view`
    /// - Returns: 返回 self，支持链式调用
    @discardableResult func add(to superview: UIView) -> Self {
        superview.addSubview(self)
        return self
    }
    
    /// 添加子View
    ///
    /// - Parameter view: `subView`
    /// - Returns: self
    @discardableResult
    func add(subView view: UIView) -> Self {
        self.addSubview(view)
        return self
    }
    
    /// 移除所有的子视图
    ///
    /// - Returns: self
    @discardableResult
    func removeAllSubViews() -> Self {
        for sub in self.subviews {
            sub.remove()
        }
        return self
    }
    
    /// 移除自己
    ///
    /// - Returns: self
    @discardableResult
    func remove() -> Self {
        self.removeFromSuperview()
        return self
    }
    
    /// 添加单点手势
    ///
    /// - Parameter gestureRecognizer: gestureRecognizer
    /// - Returns: self
    @discardableResult
    func addTapGesture(_ handler: @escaping (Self, UITapGestureRecognizer) -> Void) -> Self {
        tap { (view, tap) in
            handler(view, tap)
        }
        return self
    }
    
    /// addDoubleTap
    ///
    /// - Parameter handler: handler
    /// - Returns: self
    @discardableResult
    func addDoubleGesture(_ handler: @escaping (Self, UITapGestureRecognizer) -> Void) -> Self {
        doubleTap { (view, tap) in
            handler(view, tap)
        }
        return self
    }
    
    /// 添加长按手势
    ///
    /// - Parameter handler: handler
    /// - Returns: self
    @discardableResult
    func addLongGesture(_ handler: @escaping (Self, UILongPressGestureRecognizer) -> Void) -> Self {
        longPress { (view, tap) in
            handler(view, tap)
        }
        return self
    }
    
    /// 移除手势
    ///
    /// - Parameter gestureRecognizer: gestureRecognizer
    /// - Returns: self
    @discardableResult
    func removeGesture(_ gestureRecognizer: UIGestureRecognizer) -> Self {
        removeGestureRecognizer(gestureRecognizer)
        return self
    }
    
    /// 坐标绝对定位的方式布局，设置 frame 时必须设置好自适应
    ///
    /// frame 应始终以 superview 的 bounds 为参考，不能跨级，更不能使用 UIScreen 的 size
    /// - Parameters:
    ///   - frame: frame位置
    ///   - autoresizing: 自适应方式
    /// - Returns: 返回 self，支持链式调用
    @discardableResult
    func layout(_ frame: CGRect, _ autoresizing: UIView.AutoresizingMask) -> Self {
        self.frame = frame
        autoresizingMask = autoresizing
        return self
    }
    
    /// 设置frame
    ///
    /// - Parameter frame: frame
    /// - Returns: self
    @discardableResult
    func frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    
    /// 显示边框：设置颜色和宽度
    ///
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - width: 边框宽度，默认为 1.0
    /// - Returns: 返回 self，支持链式调用
    @discardableResult
    func border(_ color: UIColor, _ width: CGFloat = 1.0) -> Self {
        layer.borderColor  = color.cgColor
        layer.borderWidth  = width
        return self
    }
    
    /// 设置圆角 `layer.cornerRadius`
    ///
    /// - Parameter radius: 圆角半径
    /// - Returns: 返回 self，支持链式调用
    @discardableResult
    func corner(_ radius: CGFloat) -> Self  {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        clipsToBounds = true
        return self
    }
    
    /// 设置背景色 `backgroundColor`
    ///
    /// - Parameter color: 背景色
    /// - Returns: 返回 self，支持链式调用
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
    
    /// 设置透明度 `alpha`
    ///
    /// - Parameter alpha: 透明度，0.0 为全透明，1.0为不透明
    /// - Returns: 返回 self，支持链式调用
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
    
    /// 设置内容显示模式 `contentMode`
    ///
    /// - Parameter mode: 显示模式
    /// - Returns: 返回 self，支持链式调用
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        contentMode = mode
        return self
    }
    
    /// 是否允许交互
    ///
    /// - Parameter enabled: enabled
    /// - Returns: self
    @discardableResult
    func isUserInteractionEnabled(_ enabled: Bool) -> Self {
        isUserInteractionEnabled = enabled
        return self
    }
    
    /// tag
    ///
    /// - Parameter tag: tag
    /// - Returns: self
    @discardableResult
    func tag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }
    
    /// semanticContentAttribute
    ///
    /// - Parameter contentAttribute: contentAttribute
    /// - Returns: self
    @discardableResult
    func semanticContentAttribute(_ contentAttribute: UISemanticContentAttribute) -> Self {
        semanticContentAttribute = contentAttribute
        return self
    }
    
    /// bounds
    ///
    /// - Parameter bounds: bounds
    /// - Returns: self
    @discardableResult
    func bounds(_ bounds: CGRect) -> Self {
        self.bounds = bounds
        return self
    }
    
    /// center
    ///
    /// - Parameter center: center
    /// - Returns: self
    @discardableResult
    func center(_ center: CGPoint) -> Self {
        self.center = center
        return self
    }
    
    /// transform
    ///
    /// - Parameter form: transform
    /// - Returns: self
    @discardableResult
    func transform(_ form: CGAffineTransform) -> Self {
        transform = form
        return self
    }
    
    /// contentScaleFactor
    ///
    /// - Parameter factor: factor
    /// - Returns: self
    @discardableResult
    func contentScaleFactor(_ factor: CGFloat) -> Self {
        contentScaleFactor = factor
        return self
    }
    
    /// isMultipleTouchEnabled
    ///
    /// - Parameter enabled: enabled
    /// - Returns: self
    @discardableResult
    func isMultipleTouchEnabled(_ enabled: Bool) -> Self {
        isUserInteractionEnabled = enabled
        return self
    }
    
    /// discardableResult
    ///
    /// - Parameter bool: bool
    /// - Returns: self
    @discardableResult
    func isExclusiveTouch(_ bool: Bool) -> Self {
        isExclusiveTouch = bool
        return self
    }
    
    /// autoresizesSubviews
    ///
    /// - Parameter bool: bool
    /// - Returns: self
    @discardableResult
    func autoresizesSubviews(_ bool: Bool) -> Self {
        autoresizesSubviews = bool
        return self
    }
    
    /// autoresizingMask
    ///
    /// - Parameter mask: mask
    /// - Returns: self
    @discardableResult
    func autoresizingMask(_ mask: UIView.AutoresizingMask) -> Self {
        autoresizingMask = mask
        return self
    }
    
    /// sizeToFit
    ///
    /// - Parameter _:
    /// - Returns: self
    @discardableResult func sizeFit() -> Self {
        self.sizeToFit()
        return self
    }
    
    /// insert
    ///
    /// - Parameters:
    ///   - view: subView
    ///   - index: index
    /// - Returns: self
    @discardableResult
    func insert(subview view: UIView, at index: Int) -> Self {
        insertSubview(view, at: index)
        return self
    }
    
    
    /// 交换subView的位置
    ///
    /// - Parameters:
    ///   - index1: 下标1
    ///   - index2: 下标2
    /// - Returns: self
    @discardableResult
    func exchange(at index1: Int, to index2: Int) -> Self {
        exchangeSubview(at: index1, withSubviewAt: index2)
        return self
    }
    
    /// inset 将当前子view插在另外一个子view的下面
    ///
    /// - Parameters:
    ///   - view: subView
    ///   - siblingSubview: siblingSubview
    /// - Returns: self
    @discardableResult
    func insert(subview view: UIView, belowSubview siblingSubview: UIView) -> Self {
        insertSubview(view, belowSubview: siblingSubview)
        return self
    }
    
    /// inset 将当前子view插在另外一个子view的上面
    ///
    /// - Parameters:
    ///   - view: subView
    ///   - siblingSubview: siblingSubview
    /// - Returns: self
    @discardableResult
    func insert(subview view: UIView, aboveSubview siblingSubview: UIView) -> Self {
        insertSubview(view, aboveSubview: siblingSubview)
        return self
    }
    
    /// 将子view显示在最前面
    ///
    /// - Parameter view: 子view
    /// - Returns: self
    @discardableResult
    func bring(subviewToFront view: UIView) -> Self {
        bringSubviewToFront(view)
        return self
    }
    
    /// 将子view显示在最下面
    ///
    /// - Parameter view: 子view
    /// - Returns: self
    @discardableResult
    func send(subviewToBack view: UIView) -> Self {
        sendSubviewToBack(view)
        return self
    }
    
    /// layoutMargins
    ///
    /// - Parameter margins: margins
    /// - Returns: self
    @discardableResult
    func layoutMargins(_ margins: UIEdgeInsets) -> Self {
        layoutMargins = margins
        return self
    }
    
    /// directionalLayoutMargins
    ///
    /// - Parameter edgeInsets: edgeInsets
    /// - Returns: self
    @available(iOS 11.0, *)
    @discardableResult
    func directionalLayoutMargins(_ edgeInsets: NSDirectionalEdgeInsets) -> Self {
        directionalLayoutMargins = edgeInsets
        return self
    }
    
    /// preservesSuperviewLayoutMargins
    ///
    /// - Parameter bool: bool
    /// - Returns: self
    @discardableResult
    func preservesSuperviewLayoutMargins(_ bool: Bool) -> Self {
        preservesSuperviewLayoutMargins = bool
        return self
    }
    
    /// insetsLayoutMarginsFromSafeArea
    ///
    /// - Parameter bool: bool
    /// - Returns: self
    @available(iOS 11.0, *)
    @discardableResult
    func insetsLayoutMarginsFromSafeArea(_ bool: Bool) -> Self {
        insetsLayoutMarginsFromSafeArea = bool
        return self
    }
}
