//
//  TableViewVC.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

class TableViewVC: UIViewController {

    @IBOutlet weak var tableView: ChainableTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: --
        //若用此链式添加UITableViewDelegate代理方法，请注意：
        //1、若需要实现自动估值计算。请实现链式中属性方法进行设置，UITableViewDelegate代理方法中的估值方法不再提供接口
        
        //2. 若通过链式获取代理回调，请不要通过系统方法设置代理，tableVie.delegate = self, tableVie.dataSource = self，否则会无效。
        
        //3. 若链式代理无法满足需求。请设置tableVie.delegate = self, tableVie.dataSource = self再自行实现代理
        
        //扩展全部UITableViewDatasource协议
        //扩展了90%协议，未扩展协议为冷门协议，对日常使用无影响
        tableView
            .register(for: UITableViewCell.self, cellReuseIdentifier: "cell")
            .register(for: UITableViewHeaderFooterView.self, headerFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
//            .estimatedRowHeight(50)
//            .estimatedSectionHeaderHeight(100)
//            .estimatedSectionFooterHeight(0.1)
            .addNumberOfSectionsBlock { (tab) -> (Int) in
                return 5
            }
            .addNumberOfRowsInSectionBlock { (tab, sec) -> (Int) in
                return 10
            }
            .addHeightForRowAtIndexPathBlock({ (tab, indexPath) -> (CGFloat) in
                return 100
            })
            .addHeightForHeaderInSectionBlock({ (tab, section) -> (CGFloat) in
                return 50
            })
            .addViewForHeaderInSectionBlock({ (tab, section) -> (UIView?) in
                if let header = tab.dequeueReusableHeaderFooterView(withIdentifier: "UITableViewHeaderFooterView") {
                    header.textLabel?
                        .text("我是第\(section)组")
                        .font(18)
                        .textColor(UIColor.red)
                    return header
                }
                return UIView()
            })
            .addViewForFooterInSectionBlock({ (tab, section) -> (UIView?) in
                return UIView()
            })
            .addCellForRowAtIndexPathBlock {[weak self] (tab, indexPath) -> (UITableViewCell) in
                if let cell = self?.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) {
                    cell.textLabel?.text = "\(indexPath.section)组" + "-- \(indexPath.row)行"
                    return  cell
                }
                
                return UITableViewCell()
            }
            .addDidSelectRowAtIndexPathBlock({ (tab, indexPath) in
                tab.deselectRow(at: indexPath, animated: true)
                print("点击了第\(indexPath.section)组，第\(indexPath.row)行")
            })
            .addScrollViewDidScrollBlock({ (scrollView) in
                print(scrollView.contentOffset)
            })
            .reload()
    }
    
    deinit {
        print(self)
    }

}
