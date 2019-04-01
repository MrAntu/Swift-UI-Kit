//
//  RequestTableVC.swift
//  Example
//
//  Created by senyuhao on 2018/7/11.
//  Copyright © 2018年 dd01. All rights reserved.
//

import DDKit
import UIKit

class RequestTableVC: UITableViewController {

    @IBOutlet weak var requestTextView: UITextView!
    @IBOutlet weak var cacheTextView: UITextView!
    
    var items = ["normal-login"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "网络请求"
        DDRequest.shared.api = "https://eatojoy-api.hktester.com/api/1.0/ios/1.0"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "清除缓存", style: .plain, target: self, action: #selector(clearCache))
        normalLogin()
        
    }
    
    @objc private func clearCache() {
        CacheManager.share.removeAllCache {
            print($0)
        }
    }
    
    private func normalLogin() {
        DDRequest.login(mobile: "56789012", password: "cc123456") {[weak self] value in
            if let data = value.data {
                self?.cacheTextView.text = "\(data)"
            }
        }.done {[weak self] value in
            if let data = value.data {
                self?.requestTextView.text = "\(data)"
            }
        }.catch { error in
                print(error.localizedDescription)
        }
    }
}
