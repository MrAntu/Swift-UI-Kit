
//
//  UIScrollView+Blocks.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    fileprivate struct ScrollViewKey {
        static var UIScrollViewScrollViewDidScrollKey = "UIScrollViewScrollViewDidScrollKey"
        static var UIScrollViewScrollViewDidZoomKey = "UIScrollViewScrollViewDidZoomKey"
        static var UIScrollViewScrollViewWillBeginDraggingKey = "UIScrollViewScrollViewWillBeginDraggingKey"
        static var UIScrollViewScrollViewWillEndDraggingWithVelocityTargetContentOffsetKey = "UIScrollViewScrollViewWillEndDraggingWithVelocityTargetContentOffsetKey"
        static var UIScrollViewScrollViewDidEndDraggingWillDecelerateKey = "UIScrollViewScrollViewDidEndDraggingWillDecelerateKey"
        static var UIScrollViewScrollViewWillBeginDeceleratingKey = "UIScrollViewScrollViewWillBeginDeceleratingKey"
        static var UIScrollViewScrollViewDidEndDeceleratingKey = "UIScrollViewScrollViewDidEndDeceleratingKey"
        static var UIScrollViewScrollViewDidEndScrollingAnimationKey = "UIScrollViewScrollViewDidEndScrollingAnimationKey"
        static var UIScrollViewViewForZoomingKey = "UIScrollViewViewForZoomingKey"
        static var UIScrollViewScrollViewWillBeginZoomingKey = "UIScrollViewScrollViewWillBeginZoomingKey"
        static var UIScrollViewScrollViewDidEndZoomingKey = "UIScrollViewScrollViewDidEndZoomingKey"
        static var UIScrollViewScrollViewShouldScrollToTopKey = "UIScrollViewScrollViewShouldScrollToTopKey"
        static var UIScrollViewScrollViewDidScrollToTopKey = "UIScrollViewScrollViewDidScrollToTopKey"
        static var UIScrollViewScrollViewDidChangeAdjustedContentInsetKey = "UIScrollViewScrollViewDidChangeAdjustedContentInsetKey"

    }
    
    fileprivate var scrollViewDidScrollBlock: ((UIScrollView)->())? {
        get {
            return objc_getAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidScrollKey) as? ((UIScrollView) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidScrollKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var scrollViewDidZoomBlock: ((UIScrollView)->())? {
        get {
            return objc_getAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidZoomKey) as? ((UIScrollView) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidZoomKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var scrollViewWillBeginDraggingBlock: ((UIScrollView)->())? {
        get {
            return objc_getAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewWillBeginDraggingKey) as? ((UIScrollView) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewWillBeginDraggingKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var scrollViewWillEndDraggingWithVelocityTargetContentOffsetBlock: ((UIScrollView, CGPoint, UnsafeMutablePointer<CGPoint>)->())? {
        get {
            return objc_getAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewWillEndDraggingWithVelocityTargetContentOffsetKey) as? ((UIScrollView, CGPoint, UnsafeMutablePointer<CGPoint>) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewWillEndDraggingWithVelocityTargetContentOffsetKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var scrollViewDidEndDraggingWillDecelerateBlock: ((UIScrollView, Bool)->())? {
        get {
            return objc_getAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidEndDraggingWillDecelerateKey) as? ((UIScrollView, Bool) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidEndDraggingWillDecelerateKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var scrollViewWillBeginDeceleratingBlock: ((UIScrollView)->())? {
        get {
            return objc_getAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewWillBeginDeceleratingKey) as? ((UIScrollView) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewWillBeginDeceleratingKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var scrollViewDidEndDeceleratingBlock: ((UIScrollView)->())? {
        get {
            return objc_getAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidEndDeceleratingKey) as? ((UIScrollView) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidEndDeceleratingKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var scrollViewDidEndScrollingAnimationBlock: ((UIScrollView)->())? {
        get {
            return objc_getAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidEndScrollingAnimationKey) as? ((UIScrollView) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidEndScrollingAnimationKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var viewForZoomingBlock:((UIScrollView)->(UIView?))? {
        get {
            return objc_getAssociatedObject(self, &ScrollViewKey.UIScrollViewViewForZoomingKey) as? ((UIScrollView) -> (UIView?))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &ScrollViewKey.UIScrollViewViewForZoomingKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var scrollViewWillBeginZoomingBlock:((UIScrollView, UIView?)->())? {
        get {
            return objc_getAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewWillBeginZoomingKey) as? ((UIScrollView, UIView?) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewWillBeginZoomingKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var scrollViewDidEndZoomingBlock:((UIScrollView, UIView?, CGFloat)->())? {
        get {
            return objc_getAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidEndZoomingKey) as? ((UIScrollView, UIView?, CGFloat) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidEndZoomingKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var scrollViewShouldScrollToTopBlock:((UIScrollView)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewShouldScrollToTopKey) as? ((UIScrollView) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewShouldScrollToTopKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var scrollViewDidScrollToTopBlock:((UIScrollView)->())? {
        get {
            return objc_getAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidScrollToTopKey) as? ((UIScrollView) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidScrollToTopKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var scrollViewDidChangeAdjustedContentInsetBlock:((UIScrollView)->())? {
        get {
            return objc_getAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidChangeAdjustedContentInsetKey) as? ((UIScrollView) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &ScrollViewKey.UIScrollViewScrollViewDidChangeAdjustedContentInsetKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate func setDelegate() {
        if delegate == nil || delegate?.isEqual(self) == false {
            delegate = self
        }
    }
}

// MARK: - Public method
extension UIScrollView {
    public func setScrollViewDidScrollBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) {
        scrollViewDidScrollBlock = handler
    }
    
    public func setScrollViewDidZoomBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) {
        scrollViewDidZoomBlock = handler
    }

    public func setScrollViewWillBeginDraggingBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) {
        scrollViewWillBeginDraggingBlock = handler
    }
    
    public func setScrollViewWillEndDraggingWithVelocityTargetContentOffsetBlock(_ handler: @escaping((_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>)->())) {
        scrollViewWillEndDraggingWithVelocityTargetContentOffsetBlock = handler
    }
    
    public func setScrollViewDidEndDraggingWillDecelerateBlock(_ handler: @escaping((_ scrollView: UIScrollView, _ decelerate: Bool)->())) {
        scrollViewDidEndDraggingWillDecelerateBlock = handler
    }
    
    public func setScrollViewWillBeginDeceleratingBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) {
        scrollViewWillBeginDeceleratingBlock = handler
    }
    
    public func setScrollViewDidEndDeceleratingBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) {
        scrollViewDidEndDeceleratingBlock = handler
    }
    
    public func setScrollViewDidEndScrollingAnimationBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) {
        scrollViewDidEndScrollingAnimationBlock = handler
    }
    
    public func setViewForZoomingBlock(_ handler: @escaping((_ scrollView: UIScrollView)->(UIView?))) {
        viewForZoomingBlock = handler
    }
    
    public func setScrollViewWillBeginZoomingBlock(_ handler: @escaping((_ scrollView: UIScrollView, _ view: UIView?)->())) {
        scrollViewWillBeginZoomingBlock = handler
    }

    public func setScrollViewDidEndZoomingBlock(_ handler: @escaping((_ scrollView: UIScrollView, _ view: UIView?, _ scale: CGFloat)->())) {
        scrollViewDidEndZoomingBlock = handler
    }
    
    public func setScrollViewShouldScrollToTopBlock(_ handler: @escaping((_ scrollView: UIScrollView)->(Bool))) {
        scrollViewShouldScrollToTopBlock = handler
    }
    
    public func setScrollViewDidScrollToTopBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) {
        scrollViewDidScrollToTopBlock = handler
    }
    
    @available(iOS 11.0, *)
    public func setScrollViewDidChangeAdjustedContentInsetBlock(_ handler: @escaping((_ scrollView: UIScrollView)->())) {
        scrollViewDidChangeAdjustedContentInsetBlock = handler
    }
}

extension UIScrollView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScrollBlock?(scrollView)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewDidZoomBlock?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewWillBeginDraggingBlock?(scrollView)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewWillEndDraggingWithVelocityTargetContentOffsetBlock?(scrollView, velocity, targetContentOffset)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDidEndDraggingWillDecelerateBlock?(scrollView, decelerate)
    }
 
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollViewWillBeginDeceleratingBlock?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndDeceleratingBlock?(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimationBlock?(scrollView)
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if let block = viewForZoomingBlock {
            return block(scrollView)
        }
        return nil
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollViewWillBeginZoomingBlock?(scrollView, view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollViewDidEndZoomingBlock?(scrollView, view, scale)
    }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let block = scrollViewShouldScrollToTopBlock {
            return block(scrollView)
        }
        return true
    }

    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollViewDidScrollToTopBlock?(scrollView)
    }

    @available(iOS 11.0, *)
    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        scrollViewDidChangeAdjustedContentInsetBlock?(scrollView)
    }
}
