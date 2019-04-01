
//
//  PageTabsContainerView.swift
//  PageTabsControllerDemo
//
//  Created by USER on 2018/12/18.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

let kPageTabsContainerTableCell = "kPageTabsContainerTableCell"

public protocol PageTabsContainerViewDelegate: NSObjectProtocol {
    /// 当内容可以滚动时会调用
    func pageTabsContentCanScroll(containerView: PageTabsContainerView)
    /// 当容器可以滚动时会调用
    func pageTabsContainerCanScroll(containerView: PageTabsContainerView)
    /// 当容器正在滚动时调用，参数scrollView就是充当容器的tableView
    func pageTabsContainerDidScroll(scrollView: UIScrollView)
}

public protocol PageTabsContainerViewDataSource: NSObjectProtocol {
    // 根据 navigationBar 是否透明，返回不同的值
    // 1. 当设置 navigationBar.translucent = NO 时，
    //    普通机型 InsetTop = 0， iPhoneX InsetTop = 0 （默认情况）
    // 2. 当设置 navigationBar.translucent = YES 时，
    //    普通机型 InsetTop = 64， iPhoneX InsetTop = 88
    func pageTabsContainerViewInsetTop(containerView: PageTabsContainerView) -> CGFloat
    
    // 一般不需要实现
    // 普通机型 InsetBottom = 0， iPhoneX InsetBottom = 34 （默认情况）
    func pageTabsContainerViewInsetBottom(containerView: PageTabsContainerView) -> CGFloat
}

public class PageTabsContainerView: UIView {
    
    public weak var delegate: PageTabsContainerViewDelegate?
    public weak var dataSource: PageTabsContainerViewDataSource?
//    /// 允许手势传递的view列表
//    public var allowGestureEventPassViews: [UIView]? {
//        didSet {
//            tableView.allowGestureEventPassViews = allowGestureEventPassViews
//        }
//    }
    public var tabsType: PageTabsType = .multiWork

    /// 设置容器是否可以滚动
    public var canScroll = true {
        didSet {
            if canScroll == true {
                // 通知delegate，容器开始可以滚动
                delegate?.pageTabsContainerCanScroll(containerView: self)
            }
        }
    }
    
    public var headerView: UIView? {
        didSet {
            tableView.tableHeaderView = headerView
            resizeContentHeight()
            tableView.reloadData()
        }
    }
    
    public var segmentView: UIView? {
        didSet {
            resizeSegmentView()
            tableView.reloadData()
        }
    }
    
    public var contentView: UIView? {
        didSet {
            resizeContentHeight()
            tableView.reloadData()
        }
    }
    
    public var footerView: UIView? {
        didSet {
            resizeContentHeight()
            tableView.reloadData()
        }
    }
    
    public lazy var tableView: PageTabsBaseTableView = {
        let tableView = PageTabsBaseTableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kPageTabsContainerTableCell)
        return tableView
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        resizeTableView()
        resizeSegmentView()
        resizeContentHeight()
        if headerView == nil {
            tableView.isScrollEnabled = false
        }
        tableView.reloadData()
    }
}

extension PageTabsContainerView: UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kPageTabsContainerTableCell, for: indexPath)
        if let contentView = contentView {
            cell.selectionStyle = .none
            cell.contentView.addSubview(contentView)
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let contentView = contentView {
            return contentView.bounds.height
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return segmentViewHeight()
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return segmentView
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerViewHeight()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = heightForContainerCanScroll()
        if canScroll == false {
            // 这里通过固定contentOffset的值，来实现不滚动
            scrollView.contentOffset = CGPoint(x: 0, y: contentOffset)
        }  else if (scrollView.contentOffset.y >= contentOffset) {
            scrollView.contentOffset = CGPoint(x: 0, y: contentOffset)
            canScroll = false
            // 通知delegate内容开始可以滚动
            delegate?.pageTabsContentCanScroll(containerView: self)
        }
        
        scrollView.showsVerticalScrollIndicator = canScroll
        delegate?.pageTabsContainerDidScroll(scrollView: tableView)
    }
}

extension PageTabsContainerView {
    private func setupUI() {
        addSubview(tableView)
        canScroll = true
    }
    
    public func heightForContainerCanScroll() -> CGFloat {
        if let headerView = tableView.tableHeaderView {
            let headerH = headerView.frame.height
            let insetTop = contentInsetTop()
            return (headerH - insetTop)
        }
        return 0
    }
    
    private func resizeTableView() {
        tableView.frame = bounds
    }
    
    private func resizeSegmentView() {
        segmentView?.frame = CGRect(x: 0, y: 0, width: bounds.width, height: segmentView?.frame.height ?? 0)
    }
    
    private func resizeContentHeight() {
        let height = bounds.height - segmentViewHeight() - contentInsetTop() - contentInsetBottom() - footerViewHeight()
        contentView?.frame = CGRect(x: 0, y: 0, width: bounds.width, height: height)
    }
    
    private func segmentViewHeight() -> CGFloat {
        return segmentView?.bounds.height ?? 0
    }
    
    private func footerViewHeight() -> CGFloat {
        return footerView?.bounds.height ?? 0
    }
    
    private func contentInsetTop() -> CGFloat {
        return dataSource?.pageTabsContainerViewInsetTop(containerView: self) ?? 0
    }
    
    private func contentInsetBottom() -> CGFloat {
        return dataSource?.pageTabsContainerViewInsetBottom(containerView: self) ?? 0
    }
}
