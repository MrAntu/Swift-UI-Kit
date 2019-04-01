//
//  PageTabsContentView.swift
//  PageTabsControllerDemo
//
//  Created by USER on 2018/12/18.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
public protocol PageTabsContentViewDelegate: NSObjectProtocol {
    func contentView(view: PageTabsContentView, didScrollTo index: Int)
}

public class PageTabsContentView: UIView {
    public weak var delegate: PageTabsContentViewDelegate?

    public var viewControllerList:[PageTabsBaseController]? {
        didSet {
            loadedFlagArr.removeAll()
            for _ in viewControllerList ?? [] {
                loadedFlagArr.append(false)
            }
        }
    }
        
    private lazy var containerView: UIScrollView = {
        let containerView = UIScrollView(frame: CGRect.zero)
        containerView.showsVerticalScrollIndicator = false
        containerView.showsHorizontalScrollIndicator = false
        containerView.delegate = self
        containerView.backgroundColor = UIColor.white
        containerView.isPagingEnabled = true
        containerView.scrollsToTop = true
        return containerView
    }()
    /// 存取当前controller是否被加载
    private var loadedFlagArr:[Bool] = [Bool]()
    
    private var scrollIndex = 0
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let itemW = frame.width
        let itemH = frame.height
    
        containerView.frame = bounds
        let res = loadedFlagArr[scrollIndex]
        if res == true {
            guard let vc = viewControllerList?[scrollIndex] else {
                return
            }
            setChildViewFrame(vc.view, index: scrollIndex)
        }
        
        containerView.contentSize = CGSize(width: itemW * CGFloat(viewControllerList?.count ?? 0), height: itemH)
        setContentOffset(scrollIndex)
        loadChildViewController(scrollIndex)
    }
    
    public func scroll(To index: Int) {
        if index >= viewControllerList?.count ?? -1 {
            return
        }
        scrollIndex = index
        setContentOffset(scrollIndex)
        loadChildViewController(index)
    }
}

extension PageTabsContentView: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        let page: Int = Int(offset.x / screenWidth)
        scrollIndex = page
        loadChildViewController(scrollIndex)
        delegate?.contentView(view: self, didScrollTo: scrollIndex)
    }
}

extension PageTabsContentView {
    private func setContentOffset(_ index: Int) {
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        let offset: CGFloat = CGFloat(index) * screenWidth
        containerView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
    
    /// 加载对应的子控制器
    ///
    /// - Parameter index: 下标
    private func loadChildViewController(_ index: Int) {
        if index >= loadedFlagArr.count  {
            return
        }
        /// 已经加载过就不在加载
        if loadedFlagArr[index] == true {
            guard let vc = viewControllerList?[index] else {
                return
            }
            setChildViewFrame(vc.view, index: scrollIndex)
            return
        }
        
        if index >= viewControllerList?.count ?? -1 {
            return
        }
        
        guard let vc = viewControllerList?[index] else {
            return
        }
        getViewController()?.addChildViewController(vc)
        containerView.addSubview(vc.view)
        loadedFlagArr[index] = true
        setChildViewFrame(vc.view, index: index)
    }
    
    /// 设置子控制器的frame
    ///
    /// - Parameters:
    ///   - childView: 子控制器的view
    ///   - index: 下标
    private func setChildViewFrame(_ childView:UIView, index: Int) {
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        var rect = containerView.bounds
        rect.origin.x = CGFloat(index) * screenWidth
        rect.origin.y = 0
        rect.size.height = rect.height
        childView.frame = rect
        //防止横屏时出错
        containerView.bringSubview(toFront: childView)
    }
    
    private func getViewController () -> UIViewController? {
        var next: UIResponder?
        next = self.next
        repeat {
            if (next as? UIViewController) != nil {
                return next as? UIViewController
            } else {
                next = next?.next
            }
        } while next != nil
        return UIViewController()
    }
}
