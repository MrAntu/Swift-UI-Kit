//
//  AlertVC.swift
//  Example
//
//  Created by senyuhao on 2018/7/12.
//  Copyright © 2018年 dd01. All rights reserved.
//

import DDKit
import UIKit

class AlertVC: UITableViewController {

    var items = ["alert-normal",
                 "alert- cancle color",
                 "alert - button color",
                 "title - color",
                 "content - color",
                 "subtitle"]
    
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
            normalAlert()
            normalAlert()
            normalAlert()
            normalAlert()
            normalAlert()
            normalAlert()
            normalAlert()
            normalAlert()
            normalAlert()
            normalAlert()
        } else if indexPath.row == 1 {
            alertButtonColor()
        } else if indexPath.row == 2 {
            hasHeader()
        } else if indexPath.row == 3 {
            titleColor()
        } else if indexPath.row == 4 {
            versionUpgrade()
        } else if indexPath.row == 5 {
            subTitle()
        }
    }
    
    private func normalAlert() {
        let alert = AlertInfo(title: "123", sure: "知道", content: "123", targetView: view)
        Alert.shared.show(info: alert, handler: { tag in
            print(tag)
        })
    }
    
    private func alertButtonColor() {
        Alert.shared.cancelColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        let alert = AlertInfo(title: "123", sure: "知道", content: "123", targetView: view)
        Alert.shared.show(info: alert, handler: { tag in
            print(tag)
        })
    }
    
    private func hasHeader() {
        Alert.shared.cancelColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        Alert.shared.sureColor = #colorLiteral(red: 0, green: 0.5254901961, blue: 1, alpha: 1)
        let alert = AlertInfo(title: "123", cancel: "取消", sure: "知道", targetView: view)
        Alert.shared.show(info: alert, handler: { tag in
            print(tag)
        })
    }
    
    private func titleColor() {
        Alert.shared.titleColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        let alert = AlertInfo(title: "123", cancel: "取消", sure: "知道", targetView: view)
        Alert.shared.show(info: alert, handler: { tag in
            print(tag)
        })
    }
    
    private func versionUpgrade() {
        Alert.shared.contentColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        let alert = AlertInfo(title: "123", cancel: "取消", sure: "知道", content: "wakakakakkakakak", targetView: view)
        Alert.shared.show(info: alert, handler: { tag in
            print(tag)
        })
    }

    private func subTitle() {
        let string = NSLocalizedString("請回到 香港01首頁>個人中心\n修改個人資料及綁定帳戶", comment: "")
        let attributedString = NSMutableAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1)])
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)], range: NSRange(location: 4, length: 6))
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)], range: NSRange(location: 11, length: 4))
        let info = AlertInfo(subTitle: attributedString,
                             sure: NSLocalizedString("確定", comment: ""),
                             targetView: view)
        Alert.shared.show(info: info) { _ in

        }
    }
}
