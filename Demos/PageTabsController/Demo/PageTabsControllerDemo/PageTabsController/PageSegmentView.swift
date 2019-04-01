//
//  PageSegmentView.swift
//  PageTabsControllerDemo
//
//  Created by USER on 2018/12/18.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

public protocol PageSegmentViewDelegate: NSObjectProtocol {
    func segmentView(segmentView: PageSegmentView, didScrollTo index: Int)
}

let kPageSegmentViewCell = "kPageSegmentViewCell"

public class PageSegmentView: UIView {

    public var itemWidth: CGFloat = 0.0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var itemFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var itemTitleNormalColor: UIColor = UIColor(red: 139.0/255.0, green: 142.0/255.0, blue: 147.0/255.0, alpha: 1) {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var itemTitleSelectedColor: UIColor = UIColor(red: 41.0/255.0, green: 41.0/255.0, blue: 41.0/255.0, alpha: 1) {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var itemBackgroudNormalColor: UIColor = UIColor.red {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var itemBackgroudSelectedColor: UIColor = UIColor.white {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var bottomLineWidth: CGFloat = 20 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var bottomLineHeight: CGFloat = 2.0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var bottomLineColor: UIColor = UIColor(red: 67.0/255.0, green: 116.0/255.0, blue: 1, alpha: 1) {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var segmentBackgroudColor: UIColor = UIColor.white {
        didSet {
            collectionView.backgroundColor = segmentBackgroudColor
        }
    }
    
    public var itemList: [String]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public weak var delegate: PageSegmentViewDelegate?

    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PageSegmentViewCell.self, forCellWithReuseIdentifier: kPageSegmentViewCell)
        return collectionView
    }()
    
    private var currentIndex = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        /// 调整所有item的尺寸，保证item高度和segmentView高度相等
        collectionView.frame = bounds
        collectionViewLayout.itemSize = CGSize(width: itemWidth, height: frame.height)
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    public func scrollToIndex(_ index: Int) {
        if currentIndex == index {
            return
        }
        
        if index >= itemList?.count ?? -1 {
            return
        }
        setSelectIndex(IndexPath(row: index, section: 0))
    }
}

extension PageSegmentView: UICollectionViewDataSource, UICollectionViewDelegate {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPageSegmentViewCell, for: indexPath) as! PageSegmentViewCell
    
        cell.displayCell(title: itemList?[indexPath.row] ?? "",
                         font: itemFont,
                         itemTitleSelectedColor: itemTitleSelectedColor,
                         itemTitleNormalColor: itemTitleNormalColor,
                         itemBackgroudNormalColor: itemBackgroudNormalColor,
                         itemBackgroudSelectedColor: itemBackgroudSelectedColor,
                         bottomLineWidth: bottomLineWidth ,
                         bottomLineHeight: bottomLineHeight,
                         bottomLineColor: bottomLineColor,
                         currentIndex: currentIndex,
                         indexPath: indexPath)
    
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setSelectIndex(indexPath)
    }
}

extension PageSegmentView {
    private func setSelectIndex(_ indexPath: IndexPath) {
        currentIndex = indexPath.row
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.segmentView(segmentView: self, didScrollTo: currentIndex)
    }
}
