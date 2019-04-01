//
//  UICell+Extension.swift
//  SBase
//
//  Created by weiwei.li on 2018/6/21.
//  Copyright © 2018年 dd01. All rights reserved.
//
import UIKit

extension UITableViewCell {
    public static func registerNib(mTable: UITableView) {
        mTable.register(UINib(nibName: String(describing: self), bundle: nil), forCellReuseIdentifier: NSStringFromClass(self))
    }
    
    public static func register(mTable: UITableView) {
        mTable.register(self, forCellReuseIdentifier: String(describing: self))
    }
}

extension UICollectionViewCell {
    public static func registerNib(mCollectin: UICollectionView) {
        mCollectin.register(UINib(nibName: String(describing: self), bundle: nil), forCellWithReuseIdentifier: NSStringFromClass(self))
    }
    
    public static func register(mCollectin: UICollectionView) {
        mCollectin.register(self, forCellWithReuseIdentifier: NSStringFromClass(self))
    }
}

public protocol ViewNib {}
extension UIView: ViewNib {}
extension UIViewController: ViewNib{}

extension ViewNib where Self: UIView  {
    public static func loadNib() -> Self? {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as? Self
    }
}

extension ViewNib where Self: UIViewController {
    public static func storyboard(name: String) -> UIViewController? {
      return  UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: String(describing: self)) as? Self
    }
}
