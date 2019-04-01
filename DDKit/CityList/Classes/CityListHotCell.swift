//
//  CityListHotCell.swift
//  PlacePickerDemo
//
//  Created by weiwei.li on 2019/1/3.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

class CityListHotCell: UITableViewCell {
    
    private let containerView = UIView()
    private let flowLayout = UICollectionViewFlowLayout()
    private var indexPath: IndexPath?
    private var viewModel: CityListViewModel?
    
    private lazy var collectionView: UICollectionView = { [weak self] in
        flowLayout.scrollDirection = .vertical
        //  collectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        //  设置 cell
        collectionView.register(CityHotCollectionCell.self, forCellWithReuseIdentifier: "CityHotCollectionCell")
        return collectionView
        }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = CGRect(x: 18, y: 0, width: bounds.width - 18*2, height: bounds.height)
        let width: CGFloat = containerView.frame.width
        let padding: CGFloat = 10
        let cellW: CGFloat = (width - 2 * padding) / 3.0
        let cellH: CGFloat = 40.0
        flowLayout.itemSize = CGSize(width: cellW, height: cellH)
        flowLayout.minimumLineSpacing = padding
        flowLayout.minimumInteritemSpacing = padding
        
        collectionView.frame = containerView.bounds
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(containerView)
        containerView.addSubview(collectionView)
        backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CityListHotCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let indexPath = indexPath {
            if indexPath.section == 0 {
                return 1
            }
            
            if indexPath.section == 1 {
                return viewModel?.hotCitys?.count ?? 0
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityHotCollectionCell", for: indexPath) as? CityHotCollectionCell else {
            return UICollectionViewCell()
        }
        if self.indexPath?.section == 0 {
            cell.textLab.text = viewModel?.currentCity
        } else {
            cell.textLab.text = viewModel?.hotCitys?[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //当前城市
        if self.indexPath?.section == 0 {
            NotificationCenter.default.post(name: NSNotification.Name.init("kSelectedCityNameKey"), object: nil, userInfo: ["city": viewModel?.currentCity ?? ""])
            return
        }
        
        //热门城市
        if self.indexPath?.section == 1 {
            let city = viewModel?.hotCitys?[indexPath.row]
            NotificationCenter.default.post(name: NSNotification.Name.init("kSelectedCityNameKey"), object: nil, userInfo: ["city": city ?? ""])
            return
        }
       
    }
}


extension CityListHotCell: ViewModelProtocol {
    func bindViewModel(model: CityListViewModel, indexPath: IndexPath) {
        self.indexPath = indexPath
        viewModel = model
        collectionView.reloadData()
    }
}
