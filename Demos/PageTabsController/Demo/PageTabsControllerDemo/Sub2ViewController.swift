//
//  Sub2ViewController.swift
//  PageTabsControllerDemo
//
//  Created by USER on 2018/12/19.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import MJRefresh

class Sub2ViewController: PageTabsContainerController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfig()
        title = "水电费你就是你发的健康"
        
        //此demo情景，请不要设置下面属性。否则高度会出错
//        if #available(iOS 11.0, *) {
//            pageContainerView.tableView.contentInsetAdjustmentBehavior = .never
//        } else {
//            automaticallyAdjustsScrollViewInsets = false
//        }
        
    }
    
    /// 配置父类信息
    func setConfig() {
        /// 配置segmentViewItems
        segmentViewItems = ["列表1", "列表2", "网页"]
        
        /// 配置segmentView
        segmentView.itemWidth = UIScreen.main.bounds.width / CGFloat((segmentViewItems?.count) ?? 1)
   
        segmentView.bottomLineWidth = 20
        segmentView.bottomLineHeight = 2
        
        /// 配置viewControllerList
        var list = [PageTabsBaseController]()
        let v1 = TestAController()
        list.append(v1)
        let v2 = TestBController()
        list.append(v2)
        let v3 = TestCController()
        list.append(v3)
        viewControllerList = list
        
        tabsType = .segmented
        /// 初始化默认选择tab
        segmentView.scrollToIndex(0)
    }

}
