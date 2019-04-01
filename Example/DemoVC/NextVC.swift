//
//  NextVC.swift
//  Example
//
//  Created by senyuhao on 2018/7/2.
//  Copyright © 2018年 dd01. All rights reserved.
//

import DDKit
import UIKit
import MJRefresh

class NextVC: UITableViewController {
    private var items = ["gif-header", "gif-footer", "gif-nodata"]
    private var index = 0
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.mj_header = MJRefreshGifHeader.inits(gifName: "mj1", handler: { [weak self] in
            self?.resetNormal()
        })
        tableView.mj_footer = MJRefreshBackGifFooter.inits(gifName: "mj1", handler: { [weak self] in
            self?.resetNormal()
        })
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
            tableView.mj_header.beginRefreshing()
        } else if indexPath.row == 1 {
            index = 1
            tableView.mj_footer.beginRefreshing()
        } else if indexPath.row == 2 {
            index = 2
            tableView.mj_footer.beginRefreshing()
        }
    }

}

extension NextVC {
    private func resetNormal() {
        let deadLineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadLineTime) { [weak self] in
            self?.tableView.mj_footer.endRefreshing()
            if self?.index == 1 {
                self?.tableView.mj_header.endRefreshing()
            } else {
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        }
        
    }
}
