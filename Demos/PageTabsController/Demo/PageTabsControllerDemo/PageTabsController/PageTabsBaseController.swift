//
//  PageTabsBaseController.swift
//  PageTabsControllerDemo
//
//  Created by USER on 2018/12/19.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

/// PageTabsBaseController 此类为抽象类，只能继承，不能直接创建对象
open class PageTabsBaseController: UIViewController {
    //记录content是否可以滑动,无需手动设置
    public var canContentScroll = false
    //记录tabsType,无需手动设置
    public var tabsType: PageTabsType = .multiWork
    
    public lazy var tableView: UITableView =  {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        return tableView
    }()

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(notifactionContentOffsetZero), name: NSNotification.Name.kPageTabsContainerAllCotentoffsetZero, object: nil)
    }
    
    @objc public func notifactionContentOffsetZero() {
        tableView.contentOffset = CGPoint.zero
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PageTabsBaseController {
    //子类重写此方法，下拉刷新
    @objc open func requesetPullData(currentIndex: Int) {}
    
    //发送结束下拉刷新通知
    public func endPullData() {
        NotificationCenter.default.post(name: NSNotification.Name.kPageTabsContainerEndHeaderRefresh, object: nil)
    }
}

extension PageTabsBaseController {
    private func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 34, right: 0)
        }
    }
}


extension PageTabsBaseController: UIScrollViewDelegate {
    @objc open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tabsType == .segmented {
            canContentScroll = true
            return
        }
        if canContentScroll == false {
            // 这里通过固定contentOffset，来实现不滚动
            scrollView.contentOffset = CGPoint.zero
        } else if (scrollView.contentOffset.y <= 0) {
            canContentScroll = false
            // 通知容器可以开始滚动
            NotificationCenter.default.post(name: NSNotification.Name.kPageTabsContainerCanScrollName, object: nil, userInfo: nil)
        }
        scrollView.showsVerticalScrollIndicator = canContentScroll
    }
}
