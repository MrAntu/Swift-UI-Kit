//
//  TableViewController.swift
//  CoreDemo
//
//  Created by USER on 2018/12/28.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setRightButtonItem(image: UIImage(named: "nav_icon_back_black")) {[weak self] (btn) in
            //点击事件回调
            self?.navigationController?.popViewController(animated: true)
        }
        setRightButtonItem(title: "关闭") { (btn) in
            //点击事件回调
        }
        
//        setLeftButtonItem(image: UIImage(named: "nav_icon_back_black")) { (btn) in
//            
//        }
    
        setLeftButtonItem(image: UIImage(named: "nav_icon_back_black")) {[weak self] (btn) in
            //点击事件回调
            self?.navigationController?.popViewController(animated: true)
        }

        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
        changeNavBackgroundImageWithAlpha(alpha: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changeNavBackgroundImageWithAlpha(alpha: 1)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.y
        let alpha = value / 64
        changeNavBackgroundImageWithAlpha(alpha: alpha)
        
    }

}
