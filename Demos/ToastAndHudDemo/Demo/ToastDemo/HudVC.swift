//
//  HudVC.swift
//  Example
//
//  Created by leo on 2018/7/18.
//  Copyright © 2018年 dd01. All rights reserved.
//

import MBProgressHUD
import UIKit

class HudVC: UITableViewController {
    var items = ["hud-show",
                 "hud-title-show",
                 "hud-title-mode",
                 "hud-annularDeterminate",
                 "hud-circle-determinate",
                 "hud-determinateHorizontalBar",
                 "hud-bgcolor",
                 "hud-clear",
                 "hud- window"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //隐藏hud
        NSObject.dispathTimer(timeInterval: 5) {[weak self] (timer) in
            self?.view.hiddenHud()
            UIApplication.shared.keyWindow?.hiddenHud()
        }
    }

    public func load(add: Bool) {
       
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
            view.showHud(backgroundColor: UIColor.red)
        } else if indexPath.row == 1 {
            view.showHud(title: "加载中...")
        } else if indexPath.row == 2 {
            view.showHud(title: "加载中...", mode: .indeterminate)
        } else if indexPath.row == 3 {
           let hud = view.showHud(mode:.annularDeterminate)
            var progress: Float = 0
            NSObject.dispathTimer {[weak self] (timer) in
                progress += 0.2
                hud?.progress = progress
                if progress == 1.0 {
                    timer?.cancel()
                    self?.view.hiddenHud()
                }
            }
        } else if indexPath.row == 4 {
            let hud = view.showHud(mode: .determinate)
            var progress: Float = 0
            NSObject.dispathTimer {[weak self] (timer) in
                progress += 0.2
                hud?.progress = progress
                if progress == 1.0 {
                    timer?.cancel()
                    self?.view.hiddenHud()
                }
            }
        } else if indexPath.row == 5 {
            let hud = view.showHud(mode:.determinateHorizontalBar)
            var progress: Float = 0
            NSObject.dispathTimer {[weak self] (timer) in
                progress += 0.2
                hud?.progress = progress
                if progress == 1.0 {
                    timer?.cancel()
                    self?.view.hiddenHud()
                }
            }
        } else if indexPath.row == 6 {
            view.showHud(backgroundColor: UIColor.red)
        } else if indexPath.row == 7 {
            view.showHud(backgroundColor: .clear, style: .solidColor)
        } else if indexPath.row == 8 {
            //不允许用户做任何操作，可使用此方法
            UIApplication.shared.keyWindow?.showHud(title: "加载中...")
        }
      }
}
