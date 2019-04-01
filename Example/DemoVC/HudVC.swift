//
//  HudVC.swift
//  Example
//
//  Created by senyuhao on 2018/7/18.
//  Copyright © 2018年 dd01. All rights reserved.
//

import DDKit
import MBProgressHUD
import MJRefresh
import UIKit

class HudVC: UITableViewController {

    var items = ["1、hud-show",
                 "2、hud-title-show",
                 "3、hud-title-mode",
                 "4、hud-annularDeterminate",
                 "5、hud-circle-determinate",
                 "6、hud-determinateHorizontalBar",
                 "7、hud-hidden",
                 "8、hud-bgcolor",
                 "9、hud-clear",
                 "10、ProgressHUD Usage：just loading",
                 "11、ProgressHUD Usage：loading with note",
                 "12、ProgressHUD Usage：just show alert note",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.mj_header = MJRefreshGifHeader.inits(gifName: "mj", handler: {
            self.load(add: false)
        })
        tableView.mj_footer = MJRefreshBackGifFooter.inits(gifName: "mj", handler: {
            self.load(add: true)
        })
    }

    public func load(add: Bool) {
        MBProgressHUD.show(base: self.view, backgroundColor: .clear, style: .solidColor)
        if add {
            items.append(contentsOf: ["1", "2", "3", "4", "5", "6", "7", "8", "10"])
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) { [weak self] in
            self?.tableView.reloadData()
            MBProgressHUD.hidden(base: self?.view)
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
        }
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
            MBProgressHUD.show(base: view)
        } else if indexPath.row == 1 {
            MBProgressHUD.show(base: view, title: "加载中...")
        } else if indexPath.row == 2 {
            MBProgressHUD.show(base: view, title: "加载中...", mode: MBProgressHUDMode.indeterminate)
        } else if indexPath.row == 3 {
            MBProgressHUD.show(base: view, mode: MBProgressHUDMode.annularDeterminate)
        } else if indexPath.row == 4 {
            MBProgressHUD.show(base: view, mode: MBProgressHUDMode.determinate)
        } else if indexPath.row == 5 {
            MBProgressHUD.show(base: view, mode: MBProgressHUDMode.determinateHorizontalBar)
        } else if indexPath.row == 6 {
            MBProgressHUD.hidden(base: view)
        } else if indexPath.row == 7 {
            MBProgressHUD.show(base: view, backgroundColor: UIColor.red)
        } else if indexPath.row == 8 {
            MBProgressHUD.show(base: view, backgroundColor: .clear, style: .solidColor)
        } else if indexPath.row == 9 {
            ProgressHUD.show(vc: self)
            dismissProgressHUD()
        } else if indexPath.row == 10 {
            ProgressHUD.show(vc: self, status: "加载中...")
            dismissProgressHUD()
        } else if indexPath.row == 11 {
            ProgressHUD.showInfo(vc: self, info: "这是一个提示信息")
        }
      }
    
    func dismissProgressHUD() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
            ProgressHUD.dismiss()
        }
    }
}
