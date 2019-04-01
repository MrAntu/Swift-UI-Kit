//
//  ToastVC.swift
//  Example
//
//  Created by senyuhao on 2018/7/26.
//  Copyright © 2018年 dd01. All rights reserved.
//

import DDKit
import UIKit

class ToastVC: UITableViewController {
    private var items = ["toast-top", "top-center", "top-bottom", "title - message", "toast-circle"]

    override init(style: UITableView.Style) {
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") {
            cell.textLabel?.text = items[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            SToast.show(msg: "244343", container: view, position: .top, duration: 3)
        } else if indexPath.row == 1 {
            SToast.show(msg: "1231231231", container: view, position: .center)
        } else if indexPath.row == 2 {
            SToast.show(msg: "12312313", container: view, position: .bottom, duration: 1.2)
        } else if indexPath.row == 3 {
            SToast.show(msg: "今日的领取次数已经用完", title: "领取成功", container: view, duration: 1.2)
        } else if indexPath.row == 4 {
            SToast.show(msg: "123123123", circle: true)
        }
    }
}
