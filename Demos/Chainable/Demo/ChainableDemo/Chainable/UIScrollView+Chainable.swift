
//
//  UIScrollView+Chainable.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

public extension UIKitChainable where Self: UIScrollView {

    @discardableResult
    func contentOffset(_ offset: CGPoint) -> Self {
        contentOffset = offset
        return self
    }
    
    @discardableResult
    func contentSize(_ size: CGSize) -> Self {
        contentSize = size
        return self
    }
    
    @discardableResult
    func contentInset(_ inset: UIEdgeInsets) -> Self {
        contentInset = inset
        return self
    }
    
    @discardableResult
    @available(iOS 11.0, *)
    func contentInsetAdjustmentBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        contentInsetAdjustmentBehavior = behavior
        return self
    }
    
    @discardableResult
    func isDirectionalLockEnabled(_ enabled: Bool) -> Self {
        isDirectionalLockEnabled = enabled
        return self
    }
    
    @discardableResult
    func bounces(_ bool: Bool) -> Self {
        bounces = bool
        return self
    }
    
    @discardableResult
    func alwaysBounceVertical(_ bool: Bool) -> Self {
        alwaysBounceVertical = bool
        return self
    }

    @discardableResult
    func alwaysBounceHorizontal(_ bool: Bool) -> Self {
        alwaysBounceHorizontal = bool
        return self
    }
    
    @discardableResult
    func isPagingEnabled(_ enabled: Bool) -> Self {
        isPagingEnabled = enabled
        return self
    }
    
    @discardableResult
    func isScrollEnabled(_ enabled: Bool) -> Self {
        isScrollEnabled = enabled
        return self
    }
    
    @discardableResult
    func showsHorizontalScrollIndicator(_ bool: Bool) -> Self {
        showsVerticalScrollIndicator = bool
        return self
    }
    
    @discardableResult
    func showsVerticalScrollIndicator(_ bool: Bool) -> Self {
        showsVerticalScrollIndicator = bool
        return self
    }
    
    @discardableResult
    func scrollIndicatorInsets(_ insets: UIEdgeInsets) -> Self {
        scrollIndicatorInsets = insets
        return self
    }
    
    @discardableResult
    func indicatorStyle(_ style: UIScrollView.IndicatorStyle) -> Self {
        indicatorStyle = style
        return self
    }
    
    // 此属性ci跑不过，暂时关闭。此属性基本不使用
//    @discardableResult
//    func decelerationRate(_ rate: UIScrollViewDecelerationRate) -> Self {
//        decelerationRate = rate
//        return self
//    }
    
    @discardableResult
    func indexDisplayMode(_ mode: UIScrollView.IndexDisplayMode) -> Self {
        indexDisplayMode = mode
        return self
    }
    
    @discardableResult
    func delaysContentTouches(_ bool: Bool) -> Self {
        delaysContentTouches = bool
        return self
    }
    
    @discardableResult
    func canCancelContentTouches(_ bool: Bool) -> Self {
        canCancelContentTouches = bool
        return self
    }
    
    @discardableResult
    func minimumZoomScale(_ scale: CGFloat) -> Self {
        minimumZoomScale = scale
        return self
    }
    
    @discardableResult
    func maximumZoomScale(_ scale: CGFloat) -> Self {
        maximumZoomScale = scale
        return self
    }
    
    @discardableResult
    func zoomScale(_ scale: CGFloat) -> Self {
        zoomScale = scale
        return self
    }
    
    @discardableResult
    func bouncesZoom(_ bool: Bool) -> Self {
        bouncesZoom = bool
        return self
    }
    
    @discardableResult
    func scrollsToTop(_ bool: Bool) -> Self {
        scrollsToTop = bool
        return self
    }
    
    @discardableResult
    func keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        keyboardDismissMode = mode
        return self
    }
    
    @discardableResult
    @available(iOS 10.0, *)
    func refreshControl(_ control: UIRefreshControl?) -> Self {
        refreshControl = control
        return self
    }
}


// MARK: - UIScrollViewDelegate
public extension UIKitChainable where Self: UIScrollView {
    @discardableResult
    public func addScrollViewDidScrollBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) -> Self {
        setScrollViewDidScrollBlock(handler)
        return self
    }
    
    @discardableResult
    public func addScrollViewDidZoomBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) -> Self {
        setScrollViewDidZoomBlock(handler)
        return self
    }
    
    @discardableResult
    public func addScrollViewWillBeginDraggingBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) -> Self {
        setScrollViewWillBeginDraggingBlock(handler)
        return self
    }
    
    @discardableResult
    public func addScrollViewWillEndDraggingWithVelocityTargetContentOffsetBlock(_ handler: @escaping((_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>)->())) -> Self {
        setScrollViewWillEndDraggingWithVelocityTargetContentOffsetBlock(handler)
        return self
    }
    
    @discardableResult
    public func addScrollViewDidEndDraggingWillDecelerateBlock(_ handler: @escaping((_ scrollView: UIScrollView, _ decelerate: Bool)->())) -> UIScrollView {
        setScrollViewDidEndDraggingWillDecelerateBlock(handler)
        return self
    }
    
    @discardableResult
    public func addScrollViewWillBeginDeceleratingBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) -> Self {
        setScrollViewWillBeginDeceleratingBlock(handler)
        return self
    }
    
    @discardableResult
    public func addScrollViewDidEndDeceleratingBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) -> Self {
        setScrollViewDidEndDeceleratingBlock(handler)
        return self
    }
    
    @discardableResult
    public func addScrollViewDidEndScrollingAnimationBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) -> Self {
        setScrollViewDidEndScrollingAnimationBlock(handler)
        return self
    }
    
    @discardableResult
    public func addViewForZoomingBlock(_ handler: @escaping((_ scrollView: UIScrollView)->(UIView?))) -> Self {
        setViewForZoomingBlock(handler)
        return self
    }
    
    @discardableResult
    public func addScrollViewWillBeginZoomingBlock(_ handler: @escaping((_ scrollView: UIScrollView, _ view: UIView?)->())) -> Self {
        setScrollViewWillBeginZoomingBlock(handler)
        return self
    }
    
    @discardableResult
    public func addScrollViewDidEndZoomingBlock(_ handler: @escaping((_ scrollView: UIScrollView, _ view: UIView?, _ scale: CGFloat)->())) -> Self {
        setScrollViewDidEndZoomingBlock(handler)
        return self
    }
    
    @discardableResult
    public func addScrollViewShouldScrollToTopBlock(_ handler: @escaping((_ scrollView: UIScrollView)->(Bool))) -> Self {
        setScrollViewShouldScrollToTopBlock(handler)
        return self
    }
    
    @discardableResult
    public func addScrollViewDidScrollToTopBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) -> Self {
        setScrollViewDidScrollToTopBlock(handler)
        return self
    }
    
    @discardableResult
    @available(iOS 11.0, *)
    public func addScrollViewDidChangeAdjustedContentInsetBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) -> Self {
        setScrollViewDidChangeAdjustedContentInsetBlock(handler)
        return self
    }

}
