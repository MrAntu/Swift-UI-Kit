//
//  TextViewVC.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

class TextViewVC: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //
        // TODO: 注意
        // 若同时初始化 text 和 placeholder，一定要注意先后顺序，placeholder在前，text在后。否则会有点小bug，是系统的问题
        
        //支持最大字数限制
        //支持设置placeholder
        textView.textColor(UIColor.red)
                .backgroundColor(UIColor.gray)
                .addShouldBegindEditingBlock { (t) -> (Bool) in
                    print("addShouldBegindEditingBlock")
                    return true
                }
                .addDidChangeBlock { (t) in
                    print("addDidChangeBlock")
                }
                .addShouldChangeTextInRangeReplacementTextBlock { (t, range, text) -> (Bool) in
                    print(text)
                    return true
                }
                .maxLength(5)
                .placeholder("我是是否带回家sdfsdf")
//                .text("qwqweqew")
        
        // 不提供设置代理方法。若需要直接调用系统设置代理。链式回调就不在返回
    }

    deinit {
        print(self)
    }
}
