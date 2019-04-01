//
//  NotificationVC.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/11.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    @IBOutlet weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //接受通知 。无需再deinit中释放
        addNotifiObserver(name: "a") { (notifi) in
            print("NotificationVC接收到: \(notifi.userInfo.debugDescription)")
        }

        btn.addActionTouchUpInside {[weak self](sender) in
            self?.postNotification(name: "a", object: nil, userInfo: ["name": "lisi"])
            self?.postNotification(name: "b", object: nil, userInfo: ["name": "wangwu"])
        }
        
    }

    deinit {
        print(self)
    }
}
