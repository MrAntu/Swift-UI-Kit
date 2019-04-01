//
//  UITableView+Chainable.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UITableView
public extension UIKitChainable where Self: ChainableTableView {
  
    /// 刷新 `reloadData`
    ///
    /// - Returns: self
    @discardableResult
    func reload() -> Self {
        reloadData()
        return self
    }

//    @discardableResult
//    @available(iOS 10.0, *)
//    func prefetchDataSource(_ prefetching: UITableViewDataSourcePrefetching?) -> UITableView {
//        prefetchDataSource = prefetching
//        return self
//    }
//
//    @discardableResult
//    @available(iOS 11.0, *)
//    func dragDelegate(_ delegate: UITableViewDragDelegate?) -> UITableView {
//        dragDelegate = delegate
//        return self
//    }
//
//    @discardableResult
//    @available(iOS 11.0, *)
//    func dropDelegate(_ delegate: UITableViewDropDelegate?) -> UITableView {
//        dropDelegate = delegate
//        return self
//    }
//
    @discardableResult
    func rowHeight(_ height: CGFloat) -> Self {
        rowHeight = height
        return self
    }
    
    @discardableResult
    func sectionHeaderHeight(_ height: CGFloat) -> Self {
        sectionHeaderHeight = height
        return self
    }
    
    @discardableResult
    func sectionFooterHeight(_ height: CGFloat) -> Self {
        sectionFooterHeight = height
        return self
    }
    
    @discardableResult
    func estimatedRowHeight(_ height: CGFloat) -> Self {
        estimatedRowHeight = height
        return self
    }
    
    @discardableResult
    func estimatedSectionHeaderHeight(_ height: CGFloat) -> Self {
        estimatedSectionHeaderHeight = height
        return self
    }
    
    @discardableResult
    func estimatedSectionFooterHeight(_ height: CGFloat) -> Self {
        estimatedSectionFooterHeight = height
        return self
    }
    
    @discardableResult
    func separatorInset(_ inset: UIEdgeInsets) -> Self {
        separatorInset = inset
        return self
    }
    
    @discardableResult
    @available(iOS 11.0, *)
    func separatorInsetReference(_ reference: UITableView.SeparatorInsetReference) -> Self {
        separatorInsetReference = reference
        return self
    }
    
    @discardableResult
    func backgroundView(_ view: UIView?) -> Self {
        backgroundView = view
        return self
    }
    
    @discardableResult
    func isEditing(_ bool: Bool) -> Self {
        isEditing = bool
        return self
    }
    
    @discardableResult
    func allowsSelection(_ bool: Bool) -> Self {
        allowsSelection = bool
        return self
    }
    
    @discardableResult
    func allowsSelectionDuringEditing(_ bool: Bool) -> Self {
        allowsSelectionDuringEditing = bool
        return self
    }
    
    @discardableResult
    func allowsMultipleSelection(_ bool: Bool) -> Self {
        allowsMultipleSelection = bool
        return self
    }
    
    @discardableResult
    func allowsMultipleSelectionDuringEditing(_ bool: Bool) -> Self {
        allowsMultipleSelectionDuringEditing = bool
        return self
    }
    
    @discardableResult
    func sectionIndexMinimumDisplayRowCount(_ count: Int) -> Self {
        sectionIndexMinimumDisplayRowCount = count
        return self
    }
    
    @discardableResult
    func sectionIndexColor(_ color: UIColor?) -> Self {
        sectionIndexColor = color
        return self
    }
    
    @discardableResult
    func sectionIndexBackgroundColor(_ color: UIColor?) -> Self {
        sectionIndexBackgroundColor = color
        return self
    }
    
    @discardableResult
    func sectionIndexTrackingBackgroundColor(_ color: UIColor?) -> Self {
        sectionIndexTrackingBackgroundColor = color
        return self
    }
    
    @discardableResult
    func separatorStyle(_ style: UITableViewCell.SeparatorStyle) -> Self {
        separatorStyle = style
        return self
    }
    
    @discardableResult
    func separatorColor(_ color: UIColor?) -> Self {
        separatorColor = color
        return self
    }
    
    @discardableResult
    func separatorEffect(_ effect: UIVisualEffect?) -> Self {
        separatorEffect = effect
        return self
    }
    
    @discardableResult
    func cellLayoutMarginsFollowReadableWidth(_ bool: Bool) -> Self {
        cellLayoutMarginsFollowReadableWidth = bool
        return self
    }
    
    @discardableResult
    @available(iOS 11.0, *)
    func insetsContentViewsToSafeArea(_ bool: Bool) -> Self {
        insetsContentViewsToSafeArea = bool
        return self
    }
    
    @discardableResult
    func tableHeaderView(_ view: UIView?) -> Self {
        tableHeaderView = view
        return self
    }
    
    @discardableResult
    func tableFooterView(_ view: UIView?) -> Self {
        tableFooterView = view
        return self
    }
    
    @discardableResult
    func register(for nib: UINib?, cellReuseIdentifier identifier: String) -> Self {
        register(nib, forCellReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    func register(for cellClass: AnyClass?, cellReuseIdentifier identifier: String) -> Self {
        register(cellClass, forCellReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    func register(for nib: UINib?, headerFooterViewReuseIdentifier identifier: String) -> Self {
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    func register(for aClass: AnyClass?, headerFooterViewReuseIdentifier identifier: String) -> Self {
        register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    func remembersLastFocusedIndexPath(_ bool: Bool) -> Self {
        remembersLastFocusedIndexPath = bool
        return self
    }
    
    @discardableResult
    @available(iOS 11.0, *)
    func dragInteractionEnabled(_ enabled: Bool) -> Self {
        dragInteractionEnabled = enabled
        return self
    }
}

// MARK: - UITableViewDataSource
public extension UIKitChainable where Self: ChainableTableView {
    @discardableResult
    func addNumberOfRowsInSectionBlock(_ handler: @escaping((_ tableView: UITableView,_ section: Section)->(Int))) -> Self {
        self.numberOfRowsInSectionBlock = handler
        return self
    }
    
    @discardableResult
    public func addCellForRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->(UITableViewCell))) -> Self {
        self.cellForRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    public func addNumberOfSectionsBlock(_ handler: @escaping((_ tableView: UITableView)->(Int))) -> Self {
        self.numberOfSectionsBlock = handler
        return self
    }
    
    @discardableResult
    func addTitleForHeaderInSectionBlock(_ handler: @escaping((_ tableView: UITableView, _ section: Section)->(String))) -> Self {
        self.titleForHeaderInSectionBlock = handler
        return self
    }
    
    @discardableResult
    func addTitleForFooterInSectionBlock(_ handler: @escaping((_ tableView: UITableView, _ section: Int)->(String))) -> Self {
        self.titleForFooterInSectionBlock = handler
        return self
    }
    
    @discardableResult
    func addCanEditRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView, _ indexPath: IndexPath)->(Bool))) -> Self {
        self.canEditRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    func addCanMoveRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView, _ indexPath: IndexPath)->(Bool))) -> Self {
        self.canMoveRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    func addSectionIndexTitlesBlock(_ handler: @escaping((_ tableView: UITableView)->([String]?))) -> Self {
        self.sectionIndexTitlesBlock = handler
        return self
    }
    
    @discardableResult
    func addSectionForSectionIndexTitleAtIndexBlock(_ handler: @escaping((_ tableView: UITableView, _ title: String, _ index: Int)->(Int))) -> Self {
        self.sectionForSectionIndexTitleAtIndexBlock = handler
        return self
    }
    
    @discardableResult
    func addCommitEditingStyleForRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView, _ editingStyle: UITableViewCell.EditingStyle, _ indexPath: IndexPath)->())) -> Self {
        self.commitEditingStyleForRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    func addMoveRowAtSourceIndexPathtoDestinationIndexPathBlock(_ handler: @escaping((_ tableView: UITableView, _ sourceIndexPath: IndexPath,_ destinationIndexPath: IndexPath)->())) -> Self {
        self.moveRowAtSourceIndexPathtoDestinationIndexPathBlock = handler
        return self
    }
}

// MARK: - UITableVieDelegate
public extension UIKitChainable where Self: ChainableTableView {
    @discardableResult
    public func addWillDisplayCellForRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ cell: UITableViewCell, _ indexPath: IndexPath)->())) -> Self {
        self.willDisplayCellForRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    public func addWillDisplayHeaderViewForSectionBlock(_ handler: @escaping((_ tableView: UITableView,_ view: UIView, _ section: Section)->())) -> Self {
        self.willDisplayHeaderViewForSectionBlock = handler
        return self
    }
    
    @discardableResult
    public func addWillDisplayFooterViewForSectionBlock(_ handler: @escaping((_ tableView: UITableView,_ view: UIView, _ section: Section)->())) -> Self {
        self.willDisplayFooterViewForSectionBlock = handler
        return self
    }
    
    @discardableResult
    public func addDidEndDisplayingforRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ cell: UITableViewCell, _ indexPath: IndexPath)->())) -> Self {
        self.didEndDisplayingforRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    public func addDidEndDisplayingHeaderViewForSectionBlock(_ handler: @escaping((_ tableView: UITableView,_ view: UIView, _ section: Section)->())) -> Self {
        self.didEndDisplayingHeaderViewForSectionBlock = handler
        return self
    }
    
    @discardableResult
    public func addDidEndDisplayingFooterViewforSectionBlock(_ handler: @escaping((_ tableView: UITableView,_ view: UIView, _ section: Section)->())) -> Self {
        self.didEndDisplayingFooterViewforSectionBlock = handler
        return self
    }
    
    @discardableResult
    public func addHeightForRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->(CGFloat))) -> Self {
        self.heightForRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    public func addHeightForHeaderInSectionBlock(_ handler: @escaping((_ tableView: UITableView,_ section: Section)->(CGFloat))) -> Self {
        self.heightForHeaderInSectionBlock = handler
        return self
    }
    
    @discardableResult
    public func addHeightForFooterInSectionBlock(_ handler: @escaping((_ tableView: UITableView,_ section: Section)->(CGFloat))) -> Self {
        self.heightForFooterInSectionBlock = handler
        return self
    }
    
//    @discardableResult
//    public func addEstimatedHeightForRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->(CGFloat))) -> UITableView {
//        setEstimatedHeightForRowAtIndexPathBlock(handler)
//        return self
//    }
//
//    @discardableResult
//    public func addEstimatedHeightForHeaderInSectionBlock(_ handler: @escaping((_ tableView: UITableView,_ section: Section)->(CGFloat))) -> UITableView {
//        setEstimatedHeightForHeaderInSectionBlock(handler)
//        return self
//    }
//
//    @discardableResult
//    public func addEstimatedHeightForFooterInSectionBlock(_ handler: @escaping((_ tableView: UITableView,_ section: Section)->(CGFloat))) -> UITableView {
//        setEstimatedHeightForFooterInSectionBlock(handler)
//        return self
//    }
    
    @discardableResult
    public func addViewForHeaderInSectionBlock(_ handler: @escaping((_ tableView: UITableView,_ section: Section)->(UIView?))) -> Self {
        self.viewForHeaderInSectionBlock = handler
        return self
    }
    
    @discardableResult
    public func addViewForFooterInSectionBlock(_ handler: @escaping((_ tableView: UITableView,_ section: Section)->(UIView?))) -> Self {
        self.viewForFooterInSectionBlock = handler
        return self
    }
    
    @discardableResult
    public func addAccessoryButtonTappedForRowWithBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->())) -> Self {
        self.accessoryButtonTappedForRowWithBlock = handler
        return self
    }
    
    @discardableResult
    public func addShouldHighlightRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->(Bool))) -> Self {
        self.shouldHighlightRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    public func addDidHighlightRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->())) -> Self {
        self.didHighlightRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    public func addDidUnhighlightRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->())) -> Self {
        self.didUnhighlightRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    public func addWillSelectRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->(IndexPath?))) -> Self {
        self.willSelectRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    public func addWillDeselectRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->(IndexPath?))) -> Self {
        self.willDeselectRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    public func addDidSelectRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->())) -> Self {
        self.didSelectRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    public func addDidDeselectRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->())) -> Self {
        self.didDeselectRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    public func addEditingStyleForRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->(UITableViewCell.EditingStyle))) -> Self {
        self.editingStyleForRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    public func addTitleForDeleteConfirmationButtonForRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->(String?))) -> Self {
        self.titleForDeleteConfirmationButtonForRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    public func addEditActionsForRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->([UITableViewRowAction]?))) -> Self {
        self.editActionsForRowAtIndexPathBlock = handler
        return self
    }
    
//    @discardableResult
//    @available(iOS 11.0, *)
//    public func addLeadingSwipeActionsConfigurationForRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->(UISwipeActionsConfiguration?))) -> Self {
//        self.addLeadingSwipeActionsConfigurationForRowAtIndexPathBlock = handler
//        return self
//    }
//
//    @discardableResult
//    @available(iOS 11.0, *)
//    public func addTrailingSwipeActionsConfigurationForRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->(UISwipeActionsConfiguration?))) -> Self {
//        setTrailingSwipeActionsConfigurationForRowAtIndexPathBlock(handler)
//        return self
//    }
    
    @discardableResult
    public func addShouldIndentWhileEditingRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->(Bool))) -> Self {
        self.shouldIndentWhileEditingRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    public func addWillBeginEditingRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath)->())) -> Self {
        self.willBeginEditingRowAtIndexPathBlock = handler
        return self
    }
    
    @discardableResult
    public func addDidEndEditingRowAtIndexPathBlock(_ handler: @escaping((_ tableView: UITableView,_ indexPath: IndexPath?)->())) -> Self {
        self.didEndEditingRowAtIndexPathBlock = handler
        return self
    }
}
