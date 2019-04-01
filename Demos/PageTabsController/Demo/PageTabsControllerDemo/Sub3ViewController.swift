//
//  Sub3ViewController.swift
//  PageTabsControllerDemo
//
//  Created by USER on 2018/12/20.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

class Sub3ViewController: UIViewController {

    let segmentView = PageSegmentView(frame: CGRect.zero)
    override func viewDidLoad() {
        super.viewDidLoad()

        let list = ["列表1", "列表2", "列表3", "列表4", "列表5", "列表6"]
        segmentView.itemList = list
        segmentView.delegate = self
        segmentView.itemWidth = 100
        segmentView.bottomLineWidth = 20
        segmentView.bottomLineHeight = 2
        view.addSubview(segmentView)
        
        //初始化默认选择
        segmentView.scrollToIndex(5)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            segmentView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.width, height: 44)
        } else {
            segmentView.frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: 44)
        }
    }
    
}

extension Sub3ViewController: PageSegmentViewDelegate {
    func segmentView(segmentView: PageSegmentView, didScrollTo index: Int) {
        print(index)
    }
    
    
}
