//
//  ViewController.swift
//  Example
//
//  Created by USER on 2018/5/22.
//  Copyright © 2018年 dd01. All rights reserved.
//

import DDKit
import UIKit

class ViewController: UIViewController {
    var names = ["0、Toast 参照README 0.5.6",
                 "1、Alert",
                 "2、Sheet",
                 "3、pop",
                 "4、PhotoPicker",
                 "5、Refresh 请直接参照源码",
                 "6、Request",
                 "7、Hud  参照README 0.5.6",
                 "8、VideoPlayer",
                 "9、WebJS",
                 "10、player tableView",
                 "11、Request 请直接参照源码",
                 "12、PhotoBrowser 参照READNE O.5.9",
                 "13、CustomCamera",
                 "14、Scan",
                 "15、Mediator(用于不同模块间通信)",
                 "16、Router（页面之间的跳转)",
                 "17、MagicTextField（参照README 0.5.2）",
                 "18、EmptyDataView空白页占位图，参照README 0.5.7",
                 "19、DevelopConfig 使用",
                 "20、PageTabsController （参照README 0.6.0）",
                 "21、Picker （参照README 0.6.3）",
                 "22、Core（参照README 0.6.4）",
                 "23、CityList（参照README 0.6.16）",
                 "24、NumberSelect(数字选择)",
                 "25、Chainalbe(参照README 0.7.5)",
                 ]

    @IBOutlet weak var tbView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tbView.rowHeight = 80
        
        setRightButtonItem(titles: ["关闭", "关闭"]) { (btn) in
            
        }
        
        setLeftButtonItem(title: "返回") { (btn) in
            print("2222")
        }
        
        print(UIViewController.getTopViewController as Any)
        
        title = "DDKit大全"
//        // 先注册 （一般情况在app启动是就注册）scheme://module/page
//        let error = Router.register(route: "Example://user/login") { routerURL in
//            print(routerURL.route)
//            print(routerURL.params ?? "")
//            print("push loginViewController")
//            let pushViewController = UIViewController()
//            pushViewController.view.backgroundColor = UIColor.white
//            return pushViewController
//        }
//        print(error ?? "")
//
//        let error2 = Router.register(route: "Example://user/present") { routerURL in
//            print(routerURL.route)
//            print(routerURL.params ?? "")
//            print("present ViewController")
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let presentViewController = storyBoard.instantiateViewController(withIdentifier: "PresentController")
//            return presentViewController
//        }
//        print(error2 ?? "")
//
//        //注册模块 （一般情况在app启动是就注册）
//        ServiceManager.registerAll(serviceMap: ["AccountServiceAPI": "AccountService"])
//
//        //模块实例
//        let accountModule: AccountServiceAPI? = API()
//        accountModule?.register(userName: "", passWord: "", verifyCode: "", complete: { _ in
//
//        })
//        accountModule?.login(userName: "", passWord: "", complete: { _ in
//
//        })
//        accountModule?.logout()
    }
    
    private func pop(_ indexPath: IndexPath) {
        var items = [MenuItem]()
        let commodityManageItem = MenuItem(title: NSLocalizedString("分類管理", comment: ""), image: nil, isShowRedDot: false) {
        }
        
        items.append(commodityManageItem)
        let addCommodityItem = MenuItem(title: NSLocalizedString("添加商品", comment: ""), image: nil, isShowRedDot: false) {
        }
        items.append(addCommodityItem)
        let menuViewController = MenuViewController(items: items)
        if let cell = tbView.cellForRow(at: indexPath) {
            menuViewController.popoverPresentationController?.sourceView = cell
            menuViewController.popoverPresentationController?.sourceRect = cell.bounds
        }
        present(menuViewController, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if let cell = cell {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = names[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if indexPath.row == 0 {
//            Router.push(urlStr: "Example://user/login?username=dd01&password=123456")
//        } else if indexPath.row == 1 {
//            Router.present(urlStr: "Example://user/present") {
//
//            }
//        } else if indexPath.row == 2 {
//            print("公共模块")
//        } else
        if indexPath.row == 0 {
//            navigationController?.pushViewController(ToastVC(style: .grouped), animated: true)
            return
        } else if indexPath.row == 1 {
            navigationController?.pushViewController(AlertVC(), animated: true)
        } else if indexPath.row == 2 {
            navigationController?.pushViewController(SheetTableVC(), animated: true)
        } else if indexPath.row == 3 {
            pop(indexPath)
        } else if indexPath.row == 4 {
            DDPhotoPickerManager.show { (arr) in
                
            }
        } else if indexPath.row == 5 {
//            navigationController?.pushViewController(NextVC(style: .grouped), animated: true)
            return
        } else if indexPath.row == 6 {
            performSegue(withIdentifier: "RequestTableVC", sender: nil)
        } else if indexPath.row == 7 {
            navigationController?.pushViewController(HudVC(), animated: true)
            return
        } else if indexPath.row == 8 {
            navigationController?.pushViewController(PlayerViewController(), animated: true)
        } else if indexPath.row == 9 {
                navigationController?.pushViewController(WKWeb(), animated: true)
        } else if indexPath.row == 10 {
            navigationController?.pushViewController(TablePlayerController(), animated: true)
        } else if indexPath.row == 11 {
//            navigationController?.pushViewController(PhotoTableVC(), animated: true)
            return
        } else if indexPath.row == 12 {
            return
//            navigationController?.pushViewController(BrowserController(), animated: true)
        } else if indexPath.row == 13 {
            return
//            navigationController?.pushViewController(CustomPhotoController(), animated: true)
        } else if indexPath.row == 14 {
            navigationController?.pushViewController(ScanController(), animated: true)
        } else if indexPath.row == 15 {
            navigationController?.pushViewController(MediatorController(), animated: true)
        } else if indexPath.row == 16 {
            navigationController?.pushViewController(RouterController(), animated: true)
        } else if indexPath.row == 17 {
            return
        } else if indexPath.row == 18 {
            return
        } else if indexPath.row == 19 {
            navigationController?.pushViewController(DevelopConfigVC(nibName: "DevelopConfigVC", bundle: nil), animated: true)
        } else if indexPath.row == 20 {
           return
        } else if indexPath.row == 21 {
            Picker(stringPickerOrigin: view, rows: ["白起","李白","曹操","妲己", "貂蝉", "刘备"], initialSelection: 0) { (selectedIndex, value) in
                //            print(selectedIndex)
                //            print(value)
            }
            return
        } else if indexPath.row == 22 {
            return
        } else if indexPath.row == 23 {
            let vc = CityListViewController(style: .grouped)
            vc.hotCitys = ["深圳对方水电费健康","广州", "北京", "上海"]
            vc.currentCity = "深圳"
            vc.selectedComplete = { city in
                // print(city)
            }
            vc.title = "城市选择"
            navigationController?.pushViewController(vc, animated: true)
            return
        } else if indexPath.row == 24 {
            navigationController?.pushViewController(NumberSelectVC(), animated: true)
            return
        } else if indexPath.row == 25 {
            return
        }
    }
}
