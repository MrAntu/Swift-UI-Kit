//
//  SheetTableVC.swift
//  Example
//
//  Created by senyuhao on 2018/7/4.
//  Copyright © 2018年 dd01. All rights reserved.
//

import DDKit
import UIKit

class SheetTableVC: UITableViewController {
    
    var items = ["Sheet-normal", "Sheet-title", "Sheet-message", "Sheet-message-title", "Sheet-destructive"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            SheetTool.shared.show(cancel: "取消", titles: ["2", "1"], target: view) { tag in
                print(tag)
            }
        } else if indexPath.row == 1 {
            SheetTool.shared.show(value: (title: "提示", message: nil), cancel: "取消", titles: ["2", "1"], target: view) { tag in
                print(tag)
            }
        } else if indexPath.row == 2 {
            SheetTool.shared.show(value: (title: nil, message: "infomessage"), cancel: "取消", titles: ["2", "1"], target: view) { tag in
                print(tag)
                let alertinfo = AlertInfo(sure: "确定", targetView: self.view)
                Alert.shared.show(info: alertinfo, handler: { value in
                    print(value)
                })
            }
        } else if indexPath.row == 3 {
            SheetTool.shared.show(value: (title: "提示", message: "infomessage"), cancel: "取消", titles: ["2", "1"], target: view) { tag in
                print(tag)
            }
        } else if indexPath.row == 4 {
            SheetTool.shared.show(value: (title: "提示", message: nil, destructive: "退出登录"), cancel: "取消", titles: [], target: view) {
                print($0)
            }
        }
    }
}
