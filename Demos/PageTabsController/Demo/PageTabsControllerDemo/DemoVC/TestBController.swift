//
//  TestBController.swift
//  PageTabsControllerDemo
//
//  Created by USER on 2018/12/19.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import MJRefresh
class TestBController: PageTabsBaseController {

    var dataCount = 20
    
    deinit {
        print(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TestBController")
        tableView.reloadData()
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            self?.loadData()
        })
    }
    
    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataCount += 20
            self.tableView.mj_footer.resetNoMoreData()
            
            if self.dataCount >= 100 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            self.tableView.reloadData()
        }
    }
    
    override func requesetPullData(currentIndex: Int) {
        super.requesetPullData(currentIndex: currentIndex)
        //若正在刷新的tab不是本tab,就不做任何操作
        //currentIndex ：从0升序。以viewcontrollerList数组中的位置为准
        if currentIndex != 1 {
            return
        }
        //实现下拉刷新业务
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataCount = 20
            self.tableView.mj_footer.state = .idle
            //调用父类方法，发送结束通知
            self.endPullData()
            
            self.tableView.reloadData()
        }
    }
}

extension TestBController: UITableViewDelegate, UITableViewDataSource {
    /// 下面两个方法重写即可，禁止调用super
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestBController", for: indexPath)
        cell.textLabel?.text = "列表2-----\(indexPath.row)"
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
