//
//  PageTabsBaseTableView.swift
//  PageTabsControllerDemo
//
//  Created by USER on 2018/12/18.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import WebKit

public class PageTabsBaseTableView: UITableView {
    
    public var allowGestureEventPassViews: [UIView]?
    
    override public init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        comonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PageTabsBaseTableView {
   private func comonInit() {
        // 在某些情况下，contentView中的点击事件会被panGestureRecognizer拦截，导致不能响应，
        // 这里设置cancelsTouchesInView表示不拦截
        panGestureRecognizer.cancelsTouchesInView = false
    }
}

extension PageTabsBaseTableView: UIGestureRecognizerDelegate {
    // 返回true表示可以继续传递触摸事件，这样两个嵌套的scrollView才能同时滚动
    public func  gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
