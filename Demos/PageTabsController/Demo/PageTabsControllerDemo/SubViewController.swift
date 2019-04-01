//
//  SubViewController.swift
//  PageTabsControllerDemo
//
//  Created by USER on 2018/12/18.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import MJRefresh
class SubViewController: PageTabsContainerController {
    
    deinit {
        print(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setConfig()
        title = "水电费你就是你发的健康"
        
        // 若需要头部刷新，如下即可
        pageContainerView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            //调用父类方法
            self?.requesetPullData()
        })
        
     
        
        //一定要设置下面属性.否则高度会出错
        if #available(iOS 11.0, *) {
            pageContainerView.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        //关于导航栏的隐藏，此demo只是提供参考。可任意自己去实现
        navigationController?.navigationBar.isTranslucent = true
    }
    
    /// 重写父类方法。实现结束刷新
    override func endPullData() {
        super.endPullData()
        pageContainerView.tableView.mj_header.endRefreshing()
    }
    
    /// 配置父类信息
    func setConfig() {
        /// 配置segmentViewItems
        segmentViewItems = ["列表1", "列表2", "网页"]
        
        /// 配置segmentView
        segmentView.itemWidth = UIScreen.main.bounds.width / CGFloat((segmentViewItems?.count) ?? 1)
        segmentView.bottomLineWidth = 20
        segmentView.bottomLineHeight = 2
        
        /// 配置headerView
        let offset: CGFloat = 0

        let imgView = UIImageView()
        imgView.image = UIImage(named: "img2.jpg")
        imgView.frame = CGRect(x: 0, y: -offset, width: UIScreen.main.bounds.width, height: 200)
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200-offset))
        header.backgroundColor = UIColor.red
        header.addSubview(imgView)
        headerView = header
        
        /// 配置viewControllerList
        var list = [PageTabsBaseController]()
        let v1 = TestAController()
        list.append(v1)
        let v2 = TestBController()
        list.append(v2)
        let v3 = TestCController()
        list.append(v3)
        viewControllerList = list
        
        tabsType = .multiWork
        /// 初始化默认选择tab
        segmentView.scrollToIndex(0)
    }
    
    
    
    
    
    
    /// 重写滑动监听代理方法，改变导航栏的透明度
    ///
    /// - Parameter scrollView:
    override func pageTabsContainerDidScroll(scrollView: UIScrollView) {
        super.pageTabsContainerDidScroll(scrollView: scrollView)
        // 监听容器的滚动，来设置NavigationBar的透明度
        if tabsType == .segmented {
            return
        }
        let offset = scrollView.contentOffset.y
        let canScrollHeight = pageContainerView.heightForContainerCanScroll()
        setNavigationBackgroundAlpha(offset/canScrollHeight)
    }
    
    
    func setNavigationBackgroundAlpha(_ alpha: CGFloat) {
        var alpha = alpha
        alpha = alpha > 1 ? 1 : alpha
        alpha = alpha < 0 ? 0 : alpha
        if alpha == 0.0 {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        } else {
            navigationController?.navigationBar.setBackgroundImage(imageFromColor(color: UIColor.white), for: .default)
        }
    }
    
    func imageFromColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
