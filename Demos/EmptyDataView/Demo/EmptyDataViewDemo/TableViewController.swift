//
//  TableViewController.swift
//  EmptyDataViewDemo
//
//  Created by USER on 2018/12/11.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

// MARK: - 注册时：一定要从0依次升序，否则出问题
extension EmptyDataConfig.Name {
    static let common = EmptyDataConfig.Name(rawValue: 0)
    static let license = EmptyDataConfig.Name(rawValue: 1)
    static let activity = EmptyDataConfig.Name(rawValue: 2)
    static let integral = EmptyDataConfig.Name(rawValue: 3)
    static let wifi = EmptyDataConfig.Name(rawValue: 4)
}

class TableViewController: UITableViewController {

    public var dataType = 0
    
    var rows:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        rows = 0
        
        /// 注册EmptydataSources， 在实际使用中，在AppdDelegate中提前注册好
        let config1 = EmptyDataConfig(name: EmptyDataConfig.Name.common, title: "暂无内容", image: UIImage(named: "blankpage_common"))
        let config2 = EmptyDataConfig(name: EmptyDataConfig.Name.license, title: "您目前没有绑定任何车牌", image: UIImage(named: "blankpage_search"))
        let config3 = EmptyDataConfig(name: EmptyDataConfig.Name.activity, title: "暂无活动", image: UIImage(named: "blankpage_activity"))
        let config4 = EmptyDataConfig(name: EmptyDataConfig.Name.integral, title: "暂无卡券", image: UIImage(named: "blankpage_integral"))
        let config5 = EmptyDataConfig(name: EmptyDataConfig.Name.wifi, title: "oops!沒有网络讯号", image: UIImage(named: "blankpage_wifi"))
        let arr = [config1, config2, config3, config4, config5]
        EmptyDataManager.shared.dataSources = arr
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.tableFooterView = UIView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.asyncAfter()
        }
    }
    
    deinit {
        print(self)
    }
    
    func asyncAfter() {
        switch dataType {
        case 0:
            tableView.emptyDataView(name: EmptyDataConfig.Name.common, hasData: false)
            break
        case 1:
            tableView.emptyDataView(name: EmptyDataConfig.Name.license, hasData: false, showButton: true, btnTitle: "添加") { [weak self] in
                self?.clickAction()
            }
            break
        case 2:
            tableView.emptyDataView(name: EmptyDataConfig.Name.activity, hasData: false)
            break
        case 3:
            tableView.emptyDataView(name: EmptyDataConfig.Name.integral, hasData: false)
            break
        case 4:
            tableView.emptyDataView(name: EmptyDataConfig.Name.wifi, hasData: false, showButton: true, btnTitle: "点击重试") {[weak self] in
                 self?.clickAction()
            }
            break
        default:
            break
        }

        rows = 0
        tableView.reloadData()
    }
    
    
    func clickAction() {

        self.rows = 10
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
}
