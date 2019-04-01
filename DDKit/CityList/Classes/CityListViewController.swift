//
//  CityListViewController.swift
//  PlacePickerDemo
//
//  Created by weiwei.li on 2019/1/2.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

public class CityListViewController: UITableViewController {
//MARK: - 私有属性
    private let listViewModel = CityListViewModel()

//MARK: - public属性
    /// 当前城市
    public var currentCity: String? {
        didSet {
            listViewModel.currentCity = currentCity
        }
    }
    /// 热门城市
    public var hotCitys: [String]? {
        didSet {
            listViewModel.hotCitys = hotCitys
        }
    }
    /// 所有城市哈希对象
    public var cityDatas: [String: [String]]? {
        didSet {
            listViewModel.cityDatas = cityDatas
        }
    }
    /// 是否加载本地的city.plist数据
    public var isLoadingNativeCityPlist: Bool = true
    
    /// 选中回调
    public var selectedComplete: ((String?)->())?
    
    public override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //addNotification
        NotificationCenter.default.addObserver(self, selector: #selector(selectedCityName(notification:)), name: NSNotification.Name.init("kSelectedCityNameKey"), object: nil)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CityListViewController: CityListViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - Table view data source
extension CityListViewController {
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return listViewModel.numberSections
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.numberOfRowsInSection(section: section)
    }
    
    override public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return listViewModel.viewForHeaderInSection(tableView: tableView, section: section)
    }
    
    public override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listViewModel.heightForRowAt(indexPath: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return listViewModel.heightForHeaderInSection(section: section)
    }
    
    public override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < 2 {
            return listViewModel.tableView(tableView, cellForRowAt: indexPath, identifier: "CityListHotCell")
        }
       return listViewModel.tableView(tableView, cellForRowAt: indexPath, identifier: "CityListNormalCell")
    }
    
    public override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return listViewModel.sectionIndexTitles()
    }
    
    public override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if index < 2 {
            return 1
        }
        return index / 2
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let key = listViewModel.cityDataKeys?[indexPath.section],
            let citys = listViewModel.cityDatas?[key] else {
                return
        }
        let city = citys[indexPath.row]
        NotificationCenter.default.post(name: NSNotification.Name.init("kSelectedCityNameKey"), object: nil, userInfo: ["city": city])
    }
}

// MARK: - private Method
extension CityListViewController {
    private func setupUI() {
        //注册Cell
        tableView.register(CityListHotCell.self, forCellReuseIdentifier: "CityListHotCell")
        tableView.register(CityListNormalCell.self, forCellReuseIdentifier: "CityListNormalCell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "HeaderFooterView")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)
        tableView.separatorStyle = .none
        //设置delegate
        listViewModel.delegate = self
        
        //是否加载本地数据
        if isLoadingNativeCityPlist == true {
            listViewModel.requestNativeData()
        }
    }
    
    @objc private func selectedCityName(notification: Notification) {
        selectedComplete?(notification.userInfo?["city"] as? String)
        navigationController?.popViewController(animated: true)
    }
}

