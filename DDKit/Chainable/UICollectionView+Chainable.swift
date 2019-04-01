//
//  UICollectionView+Chainable.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

public extension UIKitChainable where Self: UICollectionView {
    
    @discardableResult
    func collectionViewLayout(_ layout: UICollectionViewLayout) -> Self {
        collectionViewLayout = layout
        return self
    }
    
    @discardableResult
    @available(iOS 10.0, *)
    func isPrefetchingEnabled(_ enabled: Bool) -> Self {
        isPrefetchingEnabled = enabled
        return self
    }
    
    @discardableResult
    @available(iOS 11.0, *)
    func dragInteractionEnabled(_ enabled: Bool)  -> Self {
        dragInteractionEnabled = enabled
        return self
    }
    
    @discardableResult
    @available(iOS 11.0, *)
    func reorderingCadence(_ cadence: UICollectionView.ReorderingCadence)  -> Self {
        reorderingCadence = cadence
        return self
    }
    
    @discardableResult
    func backgroundView(_ view: UIView?) -> Self {
        backgroundView = view
        return self
    }
    
    @discardableResult
    func registerCell(_ cellClass: AnyClass?, ReuseIdentifier identifier: String) -> Self {
        register(cellClass, forCellWithReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    func registerCellNib(_ nib: UINib?, ReuseIdentifier identifier: String) -> Self {
        register(nib, forCellWithReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    func registerSupplementaryView(_ viewClass: AnyClass?,forSupplementaryViewOfKind kind: String, ReuseIdentifier identifier: String) -> Self {
        register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    func registerSupplementaryViewNib(_ nib: UINib?,forSupplementaryViewOfKind kind: String, ReuseIdentifier identifier: String) -> Self {
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    func allowsSelection(_ bool: Bool) -> Self {
        allowsSelection = bool
        return self
    }
    
    @discardableResult
    func allowsMultipleSelection(_ bool: Bool) -> Self {
        allowsMultipleSelection = bool
        return self
    }
    
    @discardableResult
    func reload() -> Self {
        reloadData()
        return self
    }
}

// MARK: - UICollectionViewDataSource
public extension UIKitChainable where Self: UICollectionView {
    @discardableResult
    public func addNumberOfItemsInSectionBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ section: Section)->(Int))) -> Self {
        setNumberOfItemsInSectionBlock(handler)
        return self
    }
    
    @discardableResult
    public func addCellForItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->(UICollectionViewCell))) -> Self {
        setCellForItemAtIndexPathBlock(handler)
        return self
    }
    
    @discardableResult
    public func addNumberOfSectionsBlock(_ handler: @escaping((_ collectionView: UICollectionView)->(Int))) -> Self {
        setNumberOfSectionsBlock(handler)
        return self
    }
    
    @discardableResult
    public func addViewForSupplementaryElementOfKindAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ kind: ElementKind, _ indexPath: IndexPath)->(UICollectionReusableView))) -> Self {
        setViewForSupplementaryElementOfKindAtIndexPathBlock(handler)
        return self
    }
    
    @discardableResult
    public func addCanMoveItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->(Bool))) -> Self {
        setCanMoveItemAtIndexPathBlock(handler)
        return self
    }
    
    @discardableResult
    public func addMoveItemAtSourceIndexPathToDestinationIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath)->())) -> Self {
        setMoveItemAtSourceIndexPathToDestinationIndexPathBlock(handler)
        return self
    }
    
    @discardableResult
    public func addIndexTitlesBlock(_ handler: @escaping((_ collectionView: UICollectionView)->([String]?))) -> Self {
        setIndexTitlesBlock(handler)
        return self
    }
    
    @discardableResult
    public func addIndexPathForIndexTitleAtIndexBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ title: String, _ index: Int)->(IndexPath))) -> Self {
        setIndexPathForIndexTitleAtIndexBlock(handler)
        return self
    }
}

// MARK: - UICollectionViewDelegate
public extension UIKitChainable where Self: UICollectionView {
    @discardableResult
    public func addShouldHighlightItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->(Bool))) -> Self {
        setShouldHighlightItemAtIndexPathBlock(handler)
        return self
    }
    
    @discardableResult
    public func addDidHighlightItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->())) -> Self {
        setDidHighlightItemAtIndexPathBlock(handler)
        return self
    }
    
    @discardableResult
    public func addDidUnhighlightItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->())) -> Self {
        setDidUnhighlightItemAtIndexPathBlock(handler)
        return self
    }
    
    @discardableResult
    public func addShouldSelectItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->(Bool))) -> Self {
        setShouldSelectItemAtIndexPathBlock(handler)
        return self
    }
    
    @discardableResult
    public func addShouldDeselectItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->(Bool))) -> Self  {
        setShouldDeselectItemAtIndexPathBlock(handler)
        return self
    }
    
    @discardableResult
    public func addDidSelectItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->())) -> Self {
        setDidSelectItemAtIndexPathBlock(handler)
        return self
    }
    
    @discardableResult
    public func addDidDeselectItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->())) -> Self {
        setDidDeselectItemAtIndexPathBlock(handler)
        return self
    }
    
    @discardableResult
    public func addWillDisplayCellforItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath)->())) -> Self {
        setWillDisplayCellforItemAtIndexPathBlock(handler)
        return self
    }
    
    @discardableResult
    public func addWillDisplaySupplementaryViewForElementKindBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ view: UICollectionReusableView, _ elementKind: String, _ indexPath: IndexPath)->())) -> Self {
        setWillDisplaySupplementaryViewForElementKindBlock(handler)
        return self
    }
    
    @discardableResult
    public func addDidEndDisplayingCellForItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ cell: UICollectionViewCell,_ indexPath: IndexPath)->())) -> Self {
        setDidEndDisplayingCellForItemAtIndexPathBlock(handler)
        return self
    }
    
    @discardableResult
    public func addDidEndDisplayingSupplementaryViewForElementOfKindBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ view: UICollectionReusableView, _ elementKind: String, _ indexPath: IndexPath)->())) -> Self {
        setDidEndDisplayingSupplementaryViewForElementOfKindBlock(handler)
        return self
    }
    
    @discardableResult
    public func addShouldShowMenuForItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->(Bool))) -> Self {
        setShouldShowMenuForItemAtIndexPathBlock(handler)
        return self
    }
    
    @discardableResult
    public func addCanPerformActionforItemAtIndexPathWithSenderBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ action: Selector,_ indexPath: IndexPath, _ sender: Any?)->(Bool))) -> Self {
        setCanPerformActionforItemAtIndexPathWithSenderBlock(handler)
        return self
    }
    
    @discardableResult
    public func addPerformActionforItemAtIndexPathWithSenderBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ action: Selector,_ indexPath: IndexPath, _ sender: Any?)->())) -> Self {
        setPerformActionforItemAtIndexPathWithSenderBlock(handler)
        return self
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
public extension UIKitChainable where Self: UICollectionView {
    @discardableResult
    public func addLayoutCollectionViewLayoutSizeForItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ layout: UICollectionViewLayout,_ indexPath: IndexPath)->(CGSize))) -> Self {
        setLayoutCollectionViewLayoutSizeForItemAtIndexPathBlock(handler)
        return self
    }
    
    @discardableResult
    public func addLayoutCollectionViewLayoutInsetForSectionAtSectionBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ layout: UICollectionViewLayout,_ section: Section)->(UIEdgeInsets))) -> Self {
        setLayoutCollectionViewLayoutInsetForSectionAtSectionBlock(handler)
        return self
    }
    
    @discardableResult
    public func addLayoutCollectionViewLayoutMinimumLineSpacingForSectionAtSectionBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ layout: UICollectionViewLayout,_ section: Section)->(CGFloat))) -> Self {
        setLayoutCollectionViewLayoutMinimumLineSpacingForSectionAtSectionBlock(handler)
        return self
    }
    
    @discardableResult
    public func addLayoutCollectionViewLayoutMinimumInteritemSpacingForSectionAtSectionBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ layout: UICollectionViewLayout,_ section: Section)->(CGFloat))) -> Self {
        setLayoutCollectionViewLayoutMinimumInteritemSpacingForSectionAtSectionBlock(handler)
        return self
    }
    
    @discardableResult
    public func addLayoutCollectionViewLayoutReferenceSizeForHeaderInSectionSectionBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ layout: UICollectionViewLayout,_ section: Section)->(CGSize))) -> Self {
        setLayoutCollectionViewLayoutReferenceSizeForHeaderInSectionSectionBlock(handler)
        return self
    }
    
    @discardableResult
    public func addLayoutCollectionViewLayoutReferenceSizeForFooterInSectionSectionBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ layout: UICollectionViewLayout,_ section: Section)->(CGSize))) -> Self {
        setLayoutCollectionViewLayoutReferenceSizeForFooterInSectionSectionBlock(handler)
        return self
    }

}
