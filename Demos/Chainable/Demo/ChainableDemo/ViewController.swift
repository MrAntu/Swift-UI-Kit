//
//  ViewController.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit
import SnapKit
class ViewController: UIViewController {
    @IBOutlet weak var tableView: ChainableTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1. removeConstraints
        // 2. makeConstraints
        // 3. remakeConstraints
        // 4. updateConstraints
        UILabel()
            .add(to: view)
            .backgroundColor(UIColor.red)
            .removeConstraints()
            .makeConstraints { (make) in
                make.top.equalTo(100)
                make.left.equalTo(100)
                make.width.equalTo(100)
                make.height.equalTo(100)
            }
            .remakeConstraints { (make) in
                make.top.equalTo(100)
                make.left.equalTo(100)
                make.width.equalTo(200)
                make.height.equalTo(100)
                
            }
            .updateConstraints { (make) in
                make.height.equalTo(200)
            }
        
        
        //接受通知 。无需再deinit中释放
        addNotifiObserver(name: "a") { (notifi) in
            print("ViewController接收到: \(notifi.userInfo.debugDescription)")
        }
        
        addNotifiObserver(name: "b") { (notifi) in
            print("ViewController接收到: \(notifi.userInfo.debugDescription)")
        }
        
        let titles = [
            "1、UITextField",
            "2、UIKit+Chainable(UIView，UILabel， UIButton, UIImageView等.....)",
            "3、TableView",
            "4、TextView",
            "5、ScrollView",
            "6、CollectionView",
            "7、SearchBar",
            "8、Notification",
            "9、设置navigationItem & 导航栏渐变"
            ]
        
        
        tableView
            .register(for: UITableViewCell.self, cellReuseIdentifier: "ChainableVCCell")
            .estimatedRowHeight(50)
            .estimatedSectionHeaderHeight(0.1)
            .estimatedSectionFooterHeight(0.1)
            .addNumberOfRowsInSectionBlock { (tab, sec) -> (Int) in
                return titles.count
            }
            .addCellForRowAtIndexPathBlock {[weak self] (tab, indexPath) -> (UITableViewCell) in
                if let cell = self?.tableView.dequeueReusableCell(withIdentifier: "ChainableVCCell", for: indexPath) {
                    cell.textLabel?.text = titles[indexPath.row]
                    return  cell
                }
                
                return UITableViewCell()
            }
            .addDidSelectRowAtIndexPathBlock({[weak self] (tab, indexPath) in
                tab.deselectRow(at: indexPath, animated: true)
                if indexPath.row == 0 {
                    let vc = TextFieldVC()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                    //测试通知使用
                    self?.postNotification(name: "a", object: nil, userInfo: ["name": "lisi"])
                    self?.postNotification(name: "b", object: nil, userInfo: ["name": "wangwu"])
                    return
                }
                
                if indexPath.row == 1 {
                    let vc = UIKitChainableVC()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                
                if indexPath.row == 2 {
                    let vc = TableViewVC()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                
                if indexPath.row == 3 {
                    let vc = TextViewVC()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                
                if indexPath.row == 4 {
                    let vc = ScrollViewVC()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                
                if indexPath.row == 5 {
                    let vc = CollectionViewVC()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                
                if indexPath.row == 6 {
                    let vc = SearchBarVC()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                
                if indexPath.row == 7 {
                    let vc = NotificationVC()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                
                if indexPath.row == 8 {
                    let vc = TableViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    return
                }
            })
            .reload()
        
    }


}

