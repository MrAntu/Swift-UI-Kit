//
//  CityListViewModel.swift
//  PlacePickerDemo
//
//  Created by weiwei.li on 2019/1/2.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

protocol CityListViewModelDelegate: NSObjectProtocol {
    func reloadData()
}

protocol ViewModelProtocol {
    associatedtype ViewModel
    func bindViewModel(model: ViewModel ,indexPath: IndexPath)
}

class CityListViewModel {
    /// 当前城市名
    var currentCity:String? {
        didSet {
            reloadData()
        }
    }
    /// 热门城市
    var hotCitys: [String]? {
        didSet {
            reloadData()
        }
    }
    /// tableView当前的sections
    var numberSections: Int = 0
    //所有城市哈希对象
    var cityDatas: [String: [String]]? {
        didSet {
            loadKeys()
            reloadData()
        }
    }
    //代理
    weak var delegate: CityListViewModelDelegate?
    //所有城市的key
    var cityDataKeys:[String]?
    
    init() {
    }
}


// MARK: - public Method
extension CityListViewModel {
    /// 加载本地数据
    func requestNativeData() {
        guard let path = Bundle(for: CityListViewController.classForCoder()).path(forResource: "CityList", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let plistPath = bundle.path(forResource: "city", ofType: "plist")
            else {
                return
        }
        let dic = NSDictionary(contentsOfFile: plistPath)
        if let tmp = dic as? [String: [String]] {
            cityDatas = tmp
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 1
        }
        if let cityDataKeys = cityDataKeys {
            let key = cityDataKeys[section]
            let count = cityDatas?[key]?.count
            return count ?? 0
        }
        return 0
    }
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && currentCity == nil {
            return 0.0
        }
        
        if indexPath.section == 1 && hotCitys == nil {
            return 0.0
        }
        
        if indexPath.section == 0 {
            return 40 + 10
        }
        
        if indexPath.section == 1 {
            let count = ((hotCitys?.count ?? 0) - 1) / 3 + 1
            return CGFloat(40 * count + (count - 1) * 10) + 10
        }
        
        return 44.0
    }
    
    func heightForHeaderInSection(section: Int) -> CGFloat {
        if section == 0 && currentCity == nil {
            return 0.0
        }
        
        if section == 1 && hotCitys == nil {
            return 0.0
        }
        return 35.0
    }
    
    func viewForHeaderInSection(tableView: UITableView, section: Int) -> UIView? {
        if section == 0 && currentCity == nil {
            return UIView()
        }
        if section == 1 && hotCitys == nil {
            return UIView()
        }
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderFooterView") else {
            return UIView()
        }
        header.backgroundColor = UIColor.clear
        header.textLabel?.font = UIFont.systemFont(ofSize: 13)
        header.textLabel?.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
        if section == 0 {
            header.textLabel?.text = "当前城市"
        } else if section == 1 {
            header.textLabel?.text = "热门城市"
        } else {
            let key = cityDataKeys?[section]
            header.textLabel?.text = key
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, identifier: String) -> UITableViewCell {
        if indexPath.section < 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityListHotCell", for: indexPath) as? CityListHotCell else {
                return UITableViewCell()
            }
            cell.bindViewModel(model: self, indexPath: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        guard let key = cityDataKeys?[indexPath.section],
            let citys = cityDatas?[key] else {
                return cell
        }
        cell.textLabel?.text = citys[indexPath.row]
        return cell
    }
    
    func sectionIndexTitles() -> [String]? {
        //在每个字母的后面加上空格字符串
        var newKeys = [String]()
        for key in cityDataKeys ?? [] {
            newKeys.append(key)
            newKeys.append(" ")
        }
        return newKeys
    }
}

// MARK: - private Method
extension CityListViewModel {
    private func reloadData() {
        //初始化sections
        numberSections = 0
        if let cityDataKeys = cityDataKeys {
            numberSections = cityDataKeys.count
        }
        //代理回调
        delegate?.reloadData()
    }
    
    private func loadKeys() {
        if let tmp = cityDatas {
            var keys = Array(tmp.keys).sorted()
            //当前城市索引key设为空
            keys.insert("", at: 0)
            keys.insert("热", at: 1)
            cityDataKeys = keys
        }
        
    }
}
