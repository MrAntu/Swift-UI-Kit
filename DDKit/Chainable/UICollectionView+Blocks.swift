//
//  UICollectionView+Blocks.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    fileprivate struct CollectionViewKey {
        // MARK: - UICollectionViewDataSource
        static var UICollectionViewNumberOfItemsInSectionKey = "UICollectionViewNumberOfItemsInSectionKey"
        static var UICollectionViewCellForItemAtIndexPathKey = "UICollectionViewCellForItemAtIndexPathKey"
        static var UICollectionViewNumberOfSectionsKey = "UICollectionViewNumberOfSectionsKey"
        static var UICollectionViewViewForSupplementaryElementOfKindAtIndexPathKey = "UICollectionViewViewForSupplementaryElementOfKindAtIndexPathKey"
        static var UICollectionViewCanMoveItemAtIndexPathKey = "UICollectionViewCanMoveItemAtIndexPathKey"
        static var UICollectionViewMoveItemAtSourceIndexPathToDestinationIndexPathKey = "UICollectionViewMoveItemAtSourceIndexPathToDestinationIndexPathKey"
        static var UICollectionViewIndexTitlesKey = "UICollectionViewIndexTitlesKey"
        static var UICollectionViewIndexPathForIndexTitleAtIndexKey = "UICollectionViewIndexPathForIndexTitleAtIndexKey"

        // MARK: - UICollectionViewDelegate
        static var UICollectionViewShouldHighlightItemAtIndexPathKey = "UICollectionViewShouldHighlightItemAtIndexPathKey"
        static var UICollectionViewDidHighlightItemAtIndexPathKey = "UICollectionViewDidHighlightItemAtIndexPathKey"
        static var UICollectionViewDidUnhighlightItemAtIndexPathKey = "UICollectionViewDidUnhighlightItemAtIndexPathKey"
        static var UICollectionViewShouldSelectItemAtIndexPathKey = "UICollectionViewShouldSelectItemAtIndexPathKey"
        static var UICollectionViewShouldDeselectItemAtIndexPathKey = "UICollectionViewShouldDeselectItemAtIndexPathKey"
        static var UICollectionViewDidSelectItemAtIndexPathKey = "UICollectionViewDidSelectItemAtIndexPathKey"
        static var UICollectionViewDidDeselectItemAtIndexPathKey = "UICollectionViewDidDeselectItemAtIndexPathKey"
        static var UICollectionViewWillDisplayCellforItemAtIndexPathKey = "UICollectionViewWillDisplayCellforItemAtIndexPathKey"
        static var UICollectionViewWillDisplaySupplementaryViewForElementKindKey = "UICollectionViewWillDisplaySupplementaryViewForElementKindKey"
        static var UICollectionViewDidEndDisplayingCellForItemAtIndexPathKey = "UICollectionViewDidEndDisplayingCellForItemAtIndexPathKey"
        static var UICollectionViewDidEndDisplayingSupplementaryViewForElementOfKindKey = "UICollectionViewDidEndDisplayingSupplementaryViewForElementOfKindKey"
        static var UICollectionViewShouldShowMenuForItemAtIndexPathKey = "UICollectionViewShouldShowMenuForItemAtIndexPathKey"
        static var UICollectionViewCanPerformActionforItemAtIndexPathWithSenderKey = "UICollectionViewCanPerformActionforItemAtIndexPathWithSenderKey"
        static var UICollectionViewPerformActionforItemAtIndexPathWithSenderKey = "UICollectionViewPerformActionforItemAtIndexPathWithSenderKey"
        //下述两种代理暂不提供
        //custom transition layout
        //focus
        
        // MARK: - UICollectionViewDelegateFlowLayout
        static var UICollectionViewLayoutCollectionViewLayoutSizeForItemAtIndexPathKey = "UICollectionViewLayoutCollectionViewLayoutSizeForItemAtIndexPathKey"
        static var UICollectionViewLayoutCollectionViewLayoutInsetForSectionAtSectionKey = "UICollectionViewLayoutCollectionViewLayoutInsetForSectionAtSectionKey"
        static var UICollectionViewLayoutCollectionViewLayoutMinimumLineSpacingForSectionAtSectionKey = "UICollectionViewLayoutCollectionViewLayoutMinimumLineSpacingForSectionAtSectionKey"
        static var UICollectionViewLayoutCollectionViewLayoutMinimumInteritemSpacingForSectionAtSectionKey = "UICollectionViewLayoutCollectionViewLayoutMinimumInteritemSpacingForSectionAtSectionKey"
        static var UICollectionViewLayoutCollectionViewLayoutReferenceSizeForHeaderInSectionSectionKey = "UICollectionViewLayoutCollectionViewLayoutReferenceSizeForHeaderInSectionSectionKey"
        static var UICollectionViewLayoutCollectionViewLayoutReferenceSizeForFooterInSectionSectionKey = "UICollectionViewLayoutCollectionViewLayoutReferenceSizeForFooterInSectionSectionKey"


    }
    
    // MARK: - UICollectionViewDataSource
    
    fileprivate var numberOfItemsInSectionBlock: ((UICollectionView, Section)->(Int))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewNumberOfItemsInSectionKey) as? ((UICollectionView, Section) -> (Int))
        }
        set(value) {
            setDataSource()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewNumberOfItemsInSectionKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }

    fileprivate var cellForItemAtIndexPathBlock: ((UICollectionView, IndexPath)->(UICollectionViewCell))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewCellForItemAtIndexPathKey) as? ((UICollectionView, IndexPath) -> (UICollectionViewCell))
        }
        set(value) {
            setDataSource()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewCellForItemAtIndexPathKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var numberOfSectionsBlock: ((UICollectionView)->(Int))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewNumberOfSectionsKey) as? ((UICollectionView) -> (Int))
        }
        set(value) {
            setDataSource()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewNumberOfSectionsKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
   
    fileprivate var viewForSupplementaryElementOfKindAtIndexPathBlock: ((UICollectionView, ElementKind, IndexPath)->(UICollectionReusableView))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewViewForSupplementaryElementOfKindAtIndexPathKey) as? ((UICollectionView, ElementKind, IndexPath) -> (UICollectionReusableView))
        }
        set(value) {
            setDataSource()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewViewForSupplementaryElementOfKindAtIndexPathKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var canMoveItemAtIndexPathBlock: ((UICollectionView, IndexPath)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewCanMoveItemAtIndexPathKey) as? ((UICollectionView, IndexPath) -> (Bool))
        }
        set(value) {
            setDataSource()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewCanMoveItemAtIndexPathKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var moveItemAtSourceIndexPathToDestinationIndexPathBlock: ((UICollectionView, IndexPath,IndexPath)->())? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewMoveItemAtSourceIndexPathToDestinationIndexPathKey) as? ((UICollectionView, IndexPath,IndexPath) -> ())
        }
        set(value) {
            setDataSource()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewMoveItemAtSourceIndexPathToDestinationIndexPathKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var indexTitlesBlock: ((UICollectionView)->([String]?))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewIndexTitlesKey) as? ((UICollectionView) -> ([String]?))
        }
        set(value) {
            setDataSource()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewIndexTitlesKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var indexPathForIndexTitleAtIndexBlock: ((UICollectionView, String, Int)->(IndexPath))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewIndexPathForIndexTitleAtIndexKey) as? ((UICollectionView, String, Int) -> (IndexPath))
        }
        set(value) {
            setDataSource()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewIndexPathForIndexTitleAtIndexKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate func setDataSource() {
        if dataSource == nil || dataSource?.isEqual(self) == false {
            dataSource = self
        }
    }
    
    // MARK: - UICollectionViewDelegate
    fileprivate func setDelegate() {
        if delegate == nil || delegate?.isEqual(self) == false {
            delegate = self
        }
    }
    
    fileprivate var shouldHighlightItemAtIndexPathBlock: ((UICollectionView,IndexPath)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewShouldHighlightItemAtIndexPathKey) as? ((UICollectionView, IndexPath) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewShouldHighlightItemAtIndexPathKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }

    fileprivate var didHighlightItemAtIndexPathBlock: ((UICollectionView,IndexPath)->())? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewDidHighlightItemAtIndexPathKey) as? ((UICollectionView, IndexPath) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewDidHighlightItemAtIndexPathKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var didUnhighlightItemAtIndexPathBlock: ((UICollectionView,IndexPath)->())? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewDidUnhighlightItemAtIndexPathKey) as? ((UICollectionView, IndexPath) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewDidUnhighlightItemAtIndexPathKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var shouldSelectItemAtIndexPathBlock: ((UICollectionView,IndexPath)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewShouldSelectItemAtIndexPathKey) as? ((UICollectionView, IndexPath) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewShouldSelectItemAtIndexPathKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var shouldDeselectItemAtIndexPathBlock: ((UICollectionView,IndexPath)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewShouldDeselectItemAtIndexPathKey) as? ((UICollectionView, IndexPath) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewShouldDeselectItemAtIndexPathKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var didSelectItemAtIndexPathBlock: ((UICollectionView,IndexPath)->())? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewDidSelectItemAtIndexPathKey) as? ((UICollectionView, IndexPath) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewDidSelectItemAtIndexPathKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var didDeselectItemAtIndexPathBlock: ((UICollectionView,IndexPath)->())? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewDidDeselectItemAtIndexPathKey) as? ((UICollectionView, IndexPath) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewDidDeselectItemAtIndexPathKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var willDisplayCellforItemAtIndexPathBlock: ((UICollectionView,UICollectionViewCell,IndexPath)->())? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewWillDisplayCellforItemAtIndexPathKey) as? ((UICollectionView, UICollectionViewCell,IndexPath) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewWillDisplayCellforItemAtIndexPathKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }

    fileprivate var willDisplaySupplementaryViewForElementKindBlock: ((UICollectionView,UICollectionReusableView,String,IndexPath)->())? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewWillDisplaySupplementaryViewForElementKindKey) as? ((UICollectionView,UICollectionReusableView,String,IndexPath) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewWillDisplaySupplementaryViewForElementKindKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var didEndDisplayingCellForItemAtIndexPathBlock: ((UICollectionView,UICollectionViewCell,IndexPath)->())? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewDidEndDisplayingCellForItemAtIndexPathKey) as? ((UICollectionView,UICollectionViewCell,IndexPath) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewDidEndDisplayingCellForItemAtIndexPathKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var didEndDisplayingSupplementaryViewForElementOfKindBlock: ((UICollectionView,UICollectionReusableView,String,IndexPath)->())? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewDidEndDisplayingSupplementaryViewForElementOfKindKey) as? ((UICollectionView,UICollectionReusableView,String,IndexPath) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewDidEndDisplayingSupplementaryViewForElementOfKindKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var shouldShowMenuForItemAtIndexPathBlock: ((UICollectionView,IndexPath)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewShouldShowMenuForItemAtIndexPathKey) as? ((UICollectionView,IndexPath) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewShouldShowMenuForItemAtIndexPathKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }

    fileprivate var canPerformActionforItemAtIndexPathWithSenderBlock: ((UICollectionView,Selector,IndexPath,Any?)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewCanPerformActionforItemAtIndexPathWithSenderKey) as? ((UICollectionView,Selector,IndexPath,Any?) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewCanPerformActionforItemAtIndexPathWithSenderKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var performActionforItemAtIndexPathWithSenderBlock: ((UICollectionView,Selector,IndexPath,Any?)->())? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewPerformActionforItemAtIndexPathWithSenderKey) as? ((UICollectionView,Selector,IndexPath,Any?) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewPerformActionforItemAtIndexPathWithSenderKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    fileprivate var layoutCollectionViewLayoutSizeForItemAtIndexPathBlock: ((UICollectionView,UICollectionViewLayout,IndexPath)->(CGSize))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewLayoutCollectionViewLayoutSizeForItemAtIndexPathKey) as? ((UICollectionView,UICollectionViewLayout,IndexPath) -> (CGSize))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewLayoutCollectionViewLayoutSizeForItemAtIndexPathKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var layoutCollectionViewLayoutInsetForSectionAtSectionBlock: ((UICollectionView,UICollectionViewLayout,Section)->(UIEdgeInsets))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewLayoutCollectionViewLayoutInsetForSectionAtSectionKey) as? ((UICollectionView,UICollectionViewLayout,Section) -> (UIEdgeInsets))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewLayoutCollectionViewLayoutInsetForSectionAtSectionKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var layoutCollectionViewLayoutMinimumLineSpacingForSectionAtSectionBlock: ((UICollectionView,UICollectionViewLayout,Section)->(CGFloat))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewLayoutCollectionViewLayoutMinimumLineSpacingForSectionAtSectionKey) as? ((UICollectionView,UICollectionViewLayout,Section) -> (CGFloat))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewLayoutCollectionViewLayoutMinimumLineSpacingForSectionAtSectionKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var layoutCollectionViewLayoutMinimumInteritemSpacingForSectionAtSectionBlock: ((UICollectionView,UICollectionViewLayout,Section)->(CGFloat))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewLayoutCollectionViewLayoutMinimumInteritemSpacingForSectionAtSectionKey) as? ((UICollectionView,UICollectionViewLayout,Section) -> (CGFloat))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewLayoutCollectionViewLayoutMinimumInteritemSpacingForSectionAtSectionKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var layoutCollectionViewLayoutReferenceSizeForHeaderInSectionSectionBlock: ((UICollectionView,UICollectionViewLayout,Section)->(CGSize))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewLayoutCollectionViewLayoutReferenceSizeForHeaderInSectionSectionKey) as? ((UICollectionView,UICollectionViewLayout,Section) -> (CGSize))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewLayoutCollectionViewLayoutReferenceSizeForHeaderInSectionSectionKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var layoutCollectionViewLayoutReferenceSizeForFooterInSectionSectionBlock: ((UICollectionView,UICollectionViewLayout,Section)->(CGSize))? {
        get {
            return objc_getAssociatedObject(self, &CollectionViewKey.UICollectionViewLayoutCollectionViewLayoutReferenceSizeForFooterInSectionSectionKey) as? ((UICollectionView,UICollectionViewLayout,Section) -> (CGSize))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &CollectionViewKey.UICollectionViewLayoutCollectionViewLayoutReferenceSizeForFooterInSectionSectionKey, value, .OBJC_ASSOCIATION_COPY);
        }
    }
}

// MARK: - UICollectionViewDataSource
extension UICollectionView {
    public func setNumberOfItemsInSectionBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ section: Section)->(Int))) {
        numberOfItemsInSectionBlock = handler
    }
    
    public func setCellForItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->(UICollectionViewCell))) {
        cellForItemAtIndexPathBlock = handler
    }
    
    public func setNumberOfSectionsBlock(_ handler: @escaping((_ collectionView: UICollectionView)->(Int))) {
        numberOfSectionsBlock = handler
    }
    
    public func setViewForSupplementaryElementOfKindAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ kind: ElementKind, _ indexPath: IndexPath)->(UICollectionReusableView))) {
        viewForSupplementaryElementOfKindAtIndexPathBlock = handler
    }
    
    public func setCanMoveItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->(Bool))) {
        canMoveItemAtIndexPathBlock = handler
    }
    
    public func setMoveItemAtSourceIndexPathToDestinationIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath)->())) {
        moveItemAtSourceIndexPathToDestinationIndexPathBlock = handler
    }
    
    public func setIndexTitlesBlock(_ handler: @escaping((_ collectionView: UICollectionView)->([String]?))) {
        indexTitlesBlock = handler
    }
    
    public func setIndexPathForIndexTitleAtIndexBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ title: String, _ index: Int)->(IndexPath))) {
        indexPathForIndexTitleAtIndexBlock = handler
    }
}

// MARK: - UICollectionViewDelegate
extension UICollectionView {
    public func setShouldHighlightItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->(Bool))) {
        shouldHighlightItemAtIndexPathBlock = handler
    }
    
    public func setDidHighlightItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->())) {
        didHighlightItemAtIndexPathBlock = handler
    }
    
    public func setDidUnhighlightItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->())) {
        didUnhighlightItemAtIndexPathBlock = handler
    }
    
    public func setShouldSelectItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->(Bool))) {
        shouldSelectItemAtIndexPathBlock = handler
    }
    
    public func setShouldDeselectItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->(Bool))) {
        shouldDeselectItemAtIndexPathBlock = handler
    }

    public func setDidSelectItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->())) {
        didSelectItemAtIndexPathBlock = handler
    }
    
    public func setDidDeselectItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->())) {
        didDeselectItemAtIndexPathBlock = handler
    }
    
    public func setWillDisplayCellforItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath)->())) {
        willDisplayCellforItemAtIndexPathBlock = handler
    }
    
    public func setWillDisplaySupplementaryViewForElementKindBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ view: UICollectionReusableView, _ elementKind: String, _ indexPath: IndexPath)->())) {
        willDisplaySupplementaryViewForElementKindBlock = handler
    }
    
    public func setDidEndDisplayingCellForItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ cell: UICollectionViewCell,_ indexPath: IndexPath)->())) {
        didEndDisplayingCellForItemAtIndexPathBlock = handler
    }
    
    public func setDidEndDisplayingSupplementaryViewForElementOfKindBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ view: UICollectionReusableView, _ elementKind: String, _ indexPath: IndexPath)->())) {
        didEndDisplayingSupplementaryViewForElementOfKindBlock = handler
    }
    
    public func setShouldShowMenuForItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ indexPath: IndexPath)->(Bool))) {
        shouldShowMenuForItemAtIndexPathBlock = handler
    }
    
    public func setCanPerformActionforItemAtIndexPathWithSenderBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ action: Selector,_ indexPath: IndexPath, _ sender: Any?)->(Bool))) {
        canPerformActionforItemAtIndexPathWithSenderBlock = handler
    }
    
    public func setPerformActionforItemAtIndexPathWithSenderBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ action: Selector,_ indexPath: IndexPath, _ sender: Any?)->())) {
        performActionforItemAtIndexPathWithSenderBlock = handler
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension UICollectionView {
    public func setLayoutCollectionViewLayoutSizeForItemAtIndexPathBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ layout: UICollectionViewLayout,_ indexPath: IndexPath)->(CGSize))) {
        layoutCollectionViewLayoutSizeForItemAtIndexPathBlock = handler
    }
    
    public func setLayoutCollectionViewLayoutInsetForSectionAtSectionBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ layout: UICollectionViewLayout,_ section: Section)->(UIEdgeInsets))) {
        layoutCollectionViewLayoutInsetForSectionAtSectionBlock = handler
    }
    
    public func setLayoutCollectionViewLayoutMinimumLineSpacingForSectionAtSectionBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ layout: UICollectionViewLayout,_ section: Section)->(CGFloat))) {
        layoutCollectionViewLayoutMinimumLineSpacingForSectionAtSectionBlock = handler
    }
    
    public func setLayoutCollectionViewLayoutMinimumInteritemSpacingForSectionAtSectionBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ layout: UICollectionViewLayout,_ section: Section)->(CGFloat))) {
        layoutCollectionViewLayoutMinimumInteritemSpacingForSectionAtSectionBlock = handler
    }
    
    public func setLayoutCollectionViewLayoutReferenceSizeForHeaderInSectionSectionBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ layout: UICollectionViewLayout,_ section: Section)->(CGSize))) {
        layoutCollectionViewLayoutReferenceSizeForHeaderInSectionSectionBlock = handler
    }
    
    public func setLayoutCollectionViewLayoutReferenceSizeForFooterInSectionSectionBlock(_ handler: @escaping((_ collectionView: UICollectionView, _ layout: UICollectionViewLayout,_ section: Section)->(CGSize))) {
        layoutCollectionViewLayoutReferenceSizeForFooterInSectionSectionBlock = handler
    }

}

extension UICollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        if let block = shouldHighlightItemAtIndexPathBlock {
            return block(collectionView, indexPath)
        }
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        didHighlightItemAtIndexPathBlock?(collectionView, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        didUnhighlightItemAtIndexPathBlock?(collectionView, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let block = shouldSelectItemAtIndexPathBlock {
            return block(collectionView, indexPath)
        }
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if let block = shouldDeselectItemAtIndexPathBlock {
            return block(collectionView, indexPath)
        }
         return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemAtIndexPathBlock?(collectionView, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        didDeselectItemAtIndexPathBlock?(collectionView, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayCellforItemAtIndexPathBlock?(collectionView, cell, indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        willDisplaySupplementaryViewForElementKindBlock?(collectionView, view, elementKind, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didEndDisplayingCellForItemAtIndexPathBlock?(collectionView, cell, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        didEndDisplayingSupplementaryViewForElementOfKindBlock?(collectionView, view, elementKind, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        if let block = shouldShowMenuForItemAtIndexPathBlock {
            return block(collectionView, indexPath)
        }
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if let block = canPerformActionforItemAtIndexPathWithSenderBlock {
            return block(collectionView, action, indexPath, sender)
        }
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        performActionforItemAtIndexPathWithSenderBlock?(collectionView, action, indexPath, sender)
    }

}

extension UICollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let block = numberOfItemsInSectionBlock {
            return block(collectionView, section)
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let block = cellForItemAtIndexPathBlock {
            return block(collectionView, indexPath)
        }
        return UICollectionViewCell()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let block = numberOfSectionsBlock {
            return block(collectionView)
        }
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let block = viewForSupplementaryElementOfKindAtIndexPathBlock {
            return block(collectionView, kind, indexPath)
        }
        return UICollectionReusableView()
    }

    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if let block = canMoveItemAtIndexPathBlock {
            return block(collectionView, indexPath)
        }
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveItemAtSourceIndexPathToDestinationIndexPathBlock?(collectionView, sourceIndexPath, destinationIndexPath)
    }

    public func indexTitles(for collectionView: UICollectionView) -> [String]? {
        if let block = indexTitlesBlock {
            return block(collectionView)
        }
        return nil
    }

    public func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        if let block = indexPathForIndexTitleAtIndexBlock {
            return block(collectionView, title, index)
        }
        return IndexPath(row: 0, section: 0)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension UICollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let block = layoutCollectionViewLayoutSizeForItemAtIndexPathBlock {
            return block(collectionView, collectionViewLayout, indexPath)
        }
        return CGSize(width: 0, height: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let block = layoutCollectionViewLayoutInsetForSectionAtSectionBlock {
            return block(collectionView, collectionViewLayout, section)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let block = layoutCollectionViewLayoutMinimumLineSpacingForSectionAtSectionBlock {
            return block(collectionView, collectionViewLayout, section)
        }
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let block = layoutCollectionViewLayoutMinimumInteritemSpacingForSectionAtSectionBlock {
            return block(collectionView, collectionViewLayout, section)
        }
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let block = layoutCollectionViewLayoutReferenceSizeForHeaderInSectionSectionBlock {
            return block(collectionView, collectionViewLayout, section)
        }
        return CGSize(width: 0, height: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let block = layoutCollectionViewLayoutReferenceSizeForFooterInSectionSectionBlock {
            return block(collectionView, collectionViewLayout, section)
        }
        return CGSize(width: 0, height: 0)
    }
}
