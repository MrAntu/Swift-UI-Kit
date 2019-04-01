//
//  CollectionViewVC.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/11.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

class CollectionViewVC: UIViewController {
    var collectionView: UICollectionView?
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let w = UIScreen.main.bounds.size.width
    let h = UIScreen.main.bounds.size.height

    override func viewDidLoad() {
        super.viewDidLoad()

        flowLayout.scrollDirection = .vertical

        //将所有90%的delegate代理方法支持回调
        //所有的datasource支持回调
        //所有的UICollectionViewDelegateFlowLayout支持回调
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: w, height: h), collectionViewLayout: flowLayout)
                    .isPagingEnabled(false)
                    .registerCell(UICollectionViewCell.self, ReuseIdentifier: "UICollectionViewCell")
            .registerSupplementaryView(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, ReuseIdentifier: "UICollectionReusableView")
                    .addNumberOfSectionsBlock({ (collection) -> (Int) in
                        return 10
                    })
                    .addNumberOfItemsInSectionBlock({ (collection, section) -> (Int) in
                        return 10
                    })
                    .addLayoutCollectionViewLayoutSizeForItemAtIndexPathBlock({[weak self] (collection, layout, indexPath) -> (CGSize) in
                        return CGSize(width: self?.w ?? 0, height: 200)
                    })
                    .addLayoutCollectionViewLayoutReferenceSizeForHeaderInSectionSectionBlock({[weak self] (collection, layout, section) -> (CGSize) in
                        return CGSize(width: self?.w ?? 0, height: 130)
                    })
                    .addCellForItemAtIndexPathBlock({[weak self] (collection, indexPath) -> (UICollectionViewCell) in
                        if  let cell = self?.collectionView?.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath) {
                            let lab = UILabel(frame: cell.bounds)
                                .text("\(indexPath.section) : \(indexPath.row)")
                                .textAlignment(.center)
                                .font(20)
                                .backgroundColor(UIColor.green)
                            
                            cell.contentView
                                .removeAllSubViews()
                                .add(subView: lab)
                            
                            return cell
                        }
                        
                        return UICollectionViewCell()
                    })
                    .addViewForSupplementaryElementOfKindAtIndexPathBlock({ (collection, kind, indexPath) -> (UICollectionReusableView) in
                        if kind == UICollectionView.elementKindSectionHeader {
                            let header = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
                            let lab = UILabel()
                                .frame(header.bounds)
                                .text("我是第\(indexPath.section)组")
                                .textColor(UIColor.red)
                                .font(18)
                                .textAlignment(.center)
                            
                            header.removeAllSubViews()
                                  .add(subView: lab)
                            
                            return header
                        }
                        return UICollectionReusableView()
                    })
                    .addDidSelectItemAtIndexPathBlock({ (collection, indexPath) in
                        print("\(indexPath.section): \(indexPath.row)")
                    })
                    .backgroundColor(UIColor.white)
                    .addLongGesture({[weak self](collection, longPress) in
                        let point = longPress.location(in: collection)
                        let indexPath = collection.indexPathForItem(at: point)

                        switch longPress.state {
                        case .began:
                            if let index = indexPath {
                                //开始移动
                                self?.collectionView?.beginInteractiveMovementForItem(at: index)
                            }
                            print("began")
                        case .changed:
                            //更新位置坐标
                            self?.collectionView?.updateInteractiveMovementTargetPosition(point)
                            print("changed")

                        case .ended:
                            //停止移动调用此方法
                            self?.collectionView?.endInteractiveMovement()
                            print("end")
                        default:
                            //取消移动
                            self?.collectionView?.cancelInteractiveMovement()
                            print("default")

                            break
                        }
                    })
                    .addCanMoveItemAtIndexPathBlock({ (collection, indexPath) -> (Bool) in
                        return true
                    })
                    .addMoveItemAtSourceIndexPathToDestinationIndexPathBlock({ (collection, sourceIndexPath, targetIndexPath) in
                        print("source: \(sourceIndexPath.section): \(sourceIndexPath.row)")
                        print("target: \(targetIndexPath.section): \(targetIndexPath.row)")

                    })
                    .add(to: view)
                    .reload()

    }
    
    deinit {
        print(self)
    }
   
}
