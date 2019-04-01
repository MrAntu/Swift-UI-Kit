//
//  ViewController.swift
//  DDRouterDemo
//
//  Created by USER on 2018/12/4.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import DDKit
import TestSDK
struct Model {
    var name: String = "liming"
    var old: Int = 18
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

    }
    
    //定义的路由 key
    // MARK: ---  "BViewController"等,必须为对应的控制器名字

    @IBAction func pushBAction(_ sender: Any) {
        let model = Model()
        pushViewController("BViewController", params: ["model": model,"title": "hello"], animated: true) { (res) in
            //上级界面回调
            print(res)
        }
    }
    
    @IBAction func presentBAction(_ sender: Any) {
        presentViewController("BViewController", params: nil, animated: true) { (res) in
            print(res)
        }
    }
    
    // MARK: ---  模块之间通信，后续会出方法
    //本路由只适合用项目间控制器中的跳转和传值
    @IBAction func pushTestSDKAction(_ sender: Any) {
        //若为SDK中的控制器，前面必须加命名空间
       pushViewController("TestSDK.TestViewController", params: nil, animated: true, complete: nil)
    }

    @IBAction func pushPosAction(_ sender: Any) {
        //若为Pods中的控制器，前面必须加命名空间
        pushViewController("DDKit.DDScanViewController", params: nil, animated: true, complete: nil)

    }
    
    
    /// 跳转Storybord控制器
    ///
    @IBAction func pushOrderAction(_ sender: Any) {
        pushSBViewController("Main", identifier: "OrderViewController", params: ["name": "lisi"])
//        presentSBViewController("Main", identifier: "OrderViewController")

    }
    
}

