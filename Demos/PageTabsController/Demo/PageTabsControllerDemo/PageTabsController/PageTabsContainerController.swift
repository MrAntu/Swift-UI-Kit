//
//  PageTabsViewController.swift
//  PageTabsControllerDemo
//
//  Created by USER on 2018/12/18.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    static let kPageTabsContainerCanScrollName = NSNotification.Name("kPageTabsContainerCanScrollName")
    static let kPageTabsContainerAllCotentoffsetZero = NSNotification.Name("kPageTabsContainerAllCotentoffsetZero")
    static let kPageTabsContainerEndHeaderRefresh = NSNotification.Name("kPageTabsContainerEndHeaderRefresh")
}

public enum PageTabsType {
    case multiWork // 多级联动
    case segmented //无header的tabs
}

/// PageTabsContainerController 此类为抽象类，只能继承，请勿直接创建
open class PageTabsContainerController: UIViewController {

    public var segmentViewItems:[String]? {
        didSet {
            segmentView.itemList = segmentViewItems
        }
    }
    
    public var viewControllerList:[PageTabsBaseController]? {
        didSet {
            for vc in viewControllerList ?? [] {
                vc.tabsType = tabsType
            }
            pageContentView.viewControllerList = viewControllerList
        }
    }
    
    public var tabsType: PageTabsType = .multiWork {
        didSet {
            if tabsType == .segmented {
                pageContainerView.headerView = nil
            }
            for vc in viewControllerList ?? [] {
                vc.tabsType = tabsType
            }
        }
    }
    
    public lazy var segmentView: PageSegmentView =  {
        let segmentView = PageSegmentView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 44))
        segmentView.delegate = self
        segmentView.itemWidth = 0
        segmentView.itemTitleNormalColor = UIColor(red: 139.0/255.0, green: 142.0/255.0, blue: 147.0/255.0, alpha: 1)
        segmentView.itemTitleSelectedColor = UIColor(red: 41.0/255.0, green: 41.0/255.0, blue: 41.0/255.0, alpha: 1)
        segmentView.segmentBackgroudColor = UIColor.white
        segmentView.bottomLineWidth = 20
        segmentView.bottomLineHeight = 2
        segmentView.bottomLineColor = UIColor(red: 67.0/255.0, green: 116.0/255.0, blue: 1, alpha: 1)
        return segmentView
    }()
    
    public lazy var pageContainerView: PageTabsContainerView = {
        let containerView = PageTabsContainerView(frame: CGRect.zero)
        containerView.delegate = self
        containerView.dataSource = self
        return containerView
    }()
    
    public lazy var pageContentView: PageTabsContentView = {
        let content = PageTabsContentView(frame: CGRect.zero)
        content.delegate = self
        return content
    }()
    
    public var headerView: UIView? {
        didSet {
            pageContainerView.headerView = headerView
            if headerView == nil || headerView?.frame.height == 0 {
                tabsType = .segmented
            } else {
                tabsType = .multiWork
            }
        }
    }
    
    private var currentIndex = 0

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifactionCanscroll), name: NSNotification.Name.kPageTabsContainerCanScrollName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endPullData), name: NSNotification.Name.kPageTabsContainerEndHeaderRefresh, object: nil)
    }
    
    @objc private func notifactionCanscroll() {
        // 通知容器可以开始滚动
        pageContainerView.canScroll = true
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageContainerView.frame = view.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PageTabsContainerController {
    //子类调用此方法
    public func requesetPullData() {
        if currentIndex >= viewControllerList?.count ?? -1 {
            return
        }
        //刷新对应的子控制器界面
        let vc = viewControllerList?[currentIndex]
        vc?.requesetPullData(currentIndex: currentIndex)
    }
    
    // 需要子类重写此方法
    @objc open func endPullData() {}
}

extension PageTabsContainerController: PageSegmentViewDelegate {
    @objc public func segmentView(segmentView: PageSegmentView, didScrollTo index: Int) {
        currentIndex = index
        pageContentView.scroll(To: index)
    }
}

extension PageTabsContainerController: PageTabsContentViewDelegate {
    public func contentView(view: PageTabsContentView, didScrollTo index: Int) {
        currentIndex = index
        segmentView.scrollToIndex(index)
    }
}

extension PageTabsContainerController: PageTabsContainerViewDelegate, PageTabsContainerViewDataSource {
   @objc public func pageTabsContentCanScroll(containerView: PageTabsContainerView) {
        //将所有容器设置为可滚动
        for vc in viewControllerList ?? [] {
            vc.canContentScroll = true
        }
    }
    
    @objc public func pageTabsContainerCanScroll(containerView: PageTabsContainerView) {
        // 当容器开始可以滚动时，将所有内容设置回到顶部
        NotificationCenter.default.post(name: NSNotification.Name.kPageTabsContainerAllCotentoffsetZero, object: nil, userInfo: nil)
    }
    
    @objc public func pageTabsContainerDidScroll(scrollView: UIScrollView) {
        // 监听容器的滚动，来设置NavigationBar的透明度
    }

    @objc public func pageTabsContainerViewInsetTop(containerView: PageTabsContainerView) -> CGFloat {
        return isIphonex() ? 88 : 64
    }
    
    @objc public func pageTabsContainerViewInsetBottom(containerView: PageTabsContainerView) -> CGFloat {
//        return isIphonex() ? 34 : 0
        return 0
    }
}

extension PageTabsContainerController {
    private func getSubViewController(_ index: Int) -> PageTabsBaseController {
        guard let list = viewControllerList else {
            return PageTabsBaseController()
        }
        
        if index >= list.count {
            return PageTabsBaseController()
        }
        
        return list[index]
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(pageContainerView)
    
        pageContainerView.segmentView = segmentView
        pageContainerView.contentView = pageContentView
    
        tabsType = .multiWork
        /// 初始化默认选择tab
        segmentView.scrollToIndex(0)
    }
    
    /// 判断是否是iphonex以上机型
    ///
    /// - Returns: bool
    public func isIphonex() -> Bool {
        var isIphonex = false
        if UIDevice.current.userInterfaceIdiom != .phone {
            return isIphonex
        }
        
        if #available(iOS 11.0, *) {
            /// 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X 以上机型。
            let mainWindow = UIApplication.shared.keyWindow
            if mainWindow?.safeAreaInsets.bottom ?? CGFloat(0.0) > CGFloat(0.0) {
                isIphonex = true
            }
        }
        return isIphonex
    }
    
}
