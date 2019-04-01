//
//  DevelopConfigVC.swift
//  Example
//
//  Created by shenzhen-dd01 on 2018/12/17.
//  Copyright © 2018 dd01. All rights reserved.
//

import UIKit
import DDKit

class DevelopConfigVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        developConfigUse()
    }
    
    func developConfigUse() {
        let environments = ["开发环境": "http://hotel-api.dadi01.net",
                            "预发布环境": "http://hotel-api.dadi01.net1",
                            "生产环境": "http://hotel-api.dadi01.net2"]
        DevelopManager.registerHost(environments: environments,
                                    notificationName: "DevelopmentsNotification")

        DevelopManager.startNetworkMonitoring { (status) in
            //网络状态发生改变...
        }
    }
    
    @IBAction func switchHostAction(_ sender: Any) {
        DevelopManager.showSettingsVC(currentHost: "http://hotel-api.dadi01.net") {
            /*
             切换地址后执行：
             1、退出登录
             2、切换Tabbar
             3、清除缓存
             ....
             */
        }
    }

}
