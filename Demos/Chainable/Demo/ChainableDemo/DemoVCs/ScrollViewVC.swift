//
//  ScrollViewVC.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

class ScrollViewVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let w = UIScreen.main.bounds.width
        
        let lab1 = UILabel()
            .frame(CGRect(x: 0, y: 0, width: w, height: 200))
            .backgroundColor(UIColor.red)
            .text("第一个")
            .font(18)
            .textAlignment(.center)
            .textColor(UIColor.black)
        
        let lab2 = UILabel()
            .frame(CGRect(x: w, y: 0, width: w, height: 200))
            .backgroundColor(UIColor.blue)
            .text("第二个")
            .font(18)
            .textAlignment(.center)
            .textColor(UIColor.black)
        
        let lab3 = UILabel()
            .frame(CGRect(x: w * 2, y: 0, width: w, height: 200))
            .backgroundColor(UIColor.yellow)
            .text("第三个")
            .font(18)
            .textAlignment(.center)
            .textColor(UIColor.black)

        //支持所有代理回调
        scrollView.frame(CGRect(x: 0, y: 100, width: w, height: 200))
                .backgroundColor(UIColor.green)
                .isPagingEnabled(true)
                .bounces(true)
                .add(subView: lab1)
                .add(subView: lab2)
                .add(subView: lab3)
                .contentSize(CGSize(width: w * 3, height: 200))
                .add(to: view)
                .addScrollViewDidScrollBlock { (scroll) in
                    print(scroll.contentOffset)
                }
    }

    deinit {
        print(self)
    }
}
