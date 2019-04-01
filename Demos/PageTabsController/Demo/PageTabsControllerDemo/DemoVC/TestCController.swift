//
//  TestCController.swift
//  PageTabsControllerDemo
//
//  Created by USER on 2018/12/19.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

class TestCController: PageTabsBaseController {
    let webview = UIWebView()
    
    deinit {
        print(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //不需要tableview就移除
        tableView.removeFromSuperview()
        
        // 添加webview
        webview.backgroundColor = UIColor.white
        if let url = URL(string: "http://www.baidu.com") {
            webview.loadRequest(URLRequest(url: url))
        }
        webview.scrollView.delegate = self  // 主要是为了在 scrollViewDidScroll: 中处理是否可以滚动
        view.addSubview(webview)
        webview.backgroundColor = UIColor.white
        
        if #available(iOS 11.0, *) {
            webview.scrollView.contentInsetAdjustmentBehavior = .never
            webview.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 34, right: 0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webview.frame = view.bounds
    }
}
