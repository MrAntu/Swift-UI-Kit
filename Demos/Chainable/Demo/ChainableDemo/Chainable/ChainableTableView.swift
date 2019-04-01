//
//  ChainableTableView.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/3/27.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

open class ChainableTableView: UITableView {
    public var numberOfRowsInSectionBlock:((UITableView,Int)->(Int))?
    
    public var cellForRowAtIndexPathBlock:((UITableView,IndexPath)->(UITableViewCell))?
    
    public var numberOfSectionsBlock:((UITableView)->(Int))?
    
    public var titleForHeaderInSectionBlock:((UITableView, Int)->(String))?
    public var titleForFooterInSectionBlock:((UITableView, Int)->(String))?
    
    
    public var canEditRowAtIndexPathBlock:((UITableView, IndexPath)->(Bool))?
    
    public var canMoveRowAtIndexPathBlock:((UITableView, IndexPath)->(Bool))?
    
    public var sectionIndexTitlesBlock:((UITableView)->([String]?))?
    
    public var sectionForSectionIndexTitleAtIndexBlock:((UITableView, String, Int)->(Int))?
    
    public var commitEditingStyleForRowAtIndexPathBlock:((UITableView, UITableViewCell.EditingStyle, IndexPath)->())?
    
    public var moveRowAtSourceIndexPathtoDestinationIndexPathBlock:((UITableView, IndexPath, IndexPath)->())?
    
    public var willDisplayCellForRowAtIndexPathBlock:((UITableView, UITableViewCell, IndexPath)->())?
    public var willDisplayHeaderViewForSectionBlock:((UITableView, UIView, Section)->())?
    public var willDisplayFooterViewForSectionBlock:((UITableView, UIView, Section)->())?
    
    public var didEndDisplayingforRowAtIndexPathBlock:((UITableView, UITableViewCell, IndexPath)->())?
    public var didEndDisplayingHeaderViewForSectionBlock:((UITableView, UIView, Section)->())?
    
    public var didEndDisplayingFooterViewforSectionBlock:((UITableView, UIView, Section)->())?
    
    public var heightForRowAtIndexPathBlock:((UITableView, IndexPath)->(CGFloat))?
    public var heightForHeaderInSectionBlock:((UITableView, Section)->(CGFloat))?
    
    public var heightForFooterInSectionBlock:((UITableView, Section)->(CGFloat))?
    
    public var estimatedHeightForRowAtIndexPathBlock:((UITableView, IndexPath)->(CGFloat))?
    
    public var estimatedHeightForHeaderInSectionBlock:((UITableView, Section)->(CGFloat))?
    public var estimatedHeightForFooterInSectionBlock:((UITableView, Section)->(CGFloat))?
    
    public var viewForHeaderInSectionBlock:((UITableView, Section)->(UIView?))?
    
    public var viewForFooterInSectionBlock:((UITableView, Section)->(UIView?))?
    public var accessoryButtonTappedForRowWithBlock:((UITableView, IndexPath)->())?
    
    public var shouldHighlightRowAtIndexPathBlock:((UITableView, IndexPath)->(Bool))?
    
    public var didHighlightRowAtIndexPathBlock:((UITableView, IndexPath)->())?
    public var didUnhighlightRowAtIndexPathBlock:((UITableView, IndexPath)->())?
    
    public var willSelectRowAtIndexPathBlock:((UITableView, IndexPath)->(IndexPath?))?
    public var willDeselectRowAtIndexPathBlock:((UITableView, IndexPath)->(IndexPath?))?
    
    public var didSelectRowAtIndexPathBlock:((UITableView, IndexPath)->())?
    public var didDeselectRowAtIndexPathBlock:((UITableView, IndexPath)->())?
    public var editingStyleForRowAtIndexPathBlock:((UITableView, IndexPath)->(UITableViewCell.EditingStyle))?
    
    public var titleForDeleteConfirmationButtonForRowAtIndexPathBlock:((UITableView, IndexPath)->(String?))?
    
    public var editActionsForRowAtIndexPathBlock:((UITableView, IndexPath)->([UITableViewRowAction]?))?
    //    @available(iOS 11.0, *)
    //    fileprivate var leadingSwipeActionsConfigurationForRowAtIndexPathBlock:((UITableView, IndexPath)->(UISwipeActionsConfiguration?))?
//        @available(iOS 11.0, *)
//        fileprivate var trailingSwipeActionsConfigurationForRowAtIndexPathBlock:((UITableView, IndexPath)->(UISwipeActionsConfiguration?))?
    
    public var shouldIndentWhileEditingRowAtIndexPathBlock:((UITableView, IndexPath)->(Bool))?
    
    public var willBeginEditingRowAtIndexPathBlock:((UITableView, IndexPath)->())?
    
    public var didEndEditingRowAtIndexPathBlock:((UITableView, IndexPath?)->())?
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setDelegate()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDelegate()
    }
    
    private func setDelegate() {
        delegate = self
        dataSource = self
    }
}

extension ChainableTableView: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let block = numberOfRowsInSectionBlock {
            return block(tableView, section)
        }
        return 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let block = cellForRowAtIndexPathBlock {
            return block(tableView, indexPath)
        }
        return UITableViewCell()
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        if let block = numberOfSectionsBlock {
            return block(tableView)
        }
        return 1
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let block = titleForHeaderInSectionBlock {
            return block(tableView, section)
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let block = titleForFooterInSectionBlock {
            return block(tableView, section)
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let block = canEditRowAtIndexPathBlock {
            return block(tableView, indexPath)
        }
        return false
    }

    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if let block = canMoveRowAtIndexPathBlock {
            return block(tableView, indexPath)
        }
        return false
    }

    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if let block = sectionIndexTitlesBlock {
            return block(tableView)
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if let block = sectionForSectionIndexTitleAtIndexBlock {
            return block(tableView, title, index)
        }
        return 0
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        commitEditingStyleForRowAtIndexPathBlock?(tableView, editingStyle, indexPath)
    }

    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveRowAtSourceIndexPathtoDestinationIndexPathBlock?(tableView, sourceIndexPath, destinationIndexPath)
    }


    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplayCellForRowAtIndexPathBlock?(tableView, cell, indexPath)
    }

    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        willDisplayHeaderViewForSectionBlock?(tableView, view, section)
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        willDisplayFooterViewForSectionBlock?(tableView, view, section)
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        didEndDisplayingforRowAtIndexPathBlock?(tableView, cell, indexPath)
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        didEndDisplayingHeaderViewForSectionBlock?(tableView, view, section)
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        didEndDisplayingFooterViewforSectionBlock?(tableView, view, section)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let block = heightForRowAtIndexPathBlock {
            return block(tableView, indexPath)
        }
        return tableView.estimatedRowHeight
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let block = heightForHeaderInSectionBlock {
            return block(tableView, section)
        }
        return tableView.estimatedSectionHeaderHeight
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let block = heightForFooterInSectionBlock {
            return block(tableView, section)
        }
        return tableView.estimatedSectionFooterHeight
    }

    //    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        if let block = estimatedHeightForRowAtIndexPathBlock {
    //            return block(tableView, indexPath)
    //        }
    //        return tableView.estimatedRowHeight
    //    }
    //
    //    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    //        if let block = estimatedHeightForHeaderInSectionBlock {
    //            return block(tableView, section)
    //        }
    //        return tableView.estimatedSectionHeaderHeight
    //    }
    //
    //    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
    //        if let block = estimatedHeightForFooterInSectionBlock {
    //            return block(tableView, section)
    //        }
    //        return tableView.estimatedSectionFooterHeight
    //    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let block = viewForHeaderInSectionBlock {
            return block(tableView, section)
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let block = viewForFooterInSectionBlock {
            return block(tableView, section)
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        accessoryButtonTappedForRowWithBlock?(tableView, indexPath)
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if let block = shouldHighlightRowAtIndexPathBlock {
            return block(tableView, indexPath)
        }
        return true
    }

    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        didHighlightRowAtIndexPathBlock?(tableView, indexPath)
    }

    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        didUnhighlightRowAtIndexPathBlock?(tableView, indexPath)
    }

    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let block = willSelectRowAtIndexPathBlock {
            return block(tableView, indexPath)
        }
        return indexPath
    }

    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if let block = willDeselectRowAtIndexPathBlock {
            return block(tableView, indexPath)
        }
        return indexPath
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAtIndexPathBlock?(tableView, indexPath)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectRowAtIndexPathBlock?(tableView, indexPath)
    }

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if let block = editingStyleForRowAtIndexPathBlock {
            return block(tableView, indexPath)
        }
        return .none
    }

    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if let block = titleForDeleteConfirmationButtonForRowAtIndexPathBlock {
            return block(tableView, indexPath)
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if let block = editActionsForRowAtIndexPathBlock {
            return block(tableView, indexPath)
        }
        return nil
    }

    //    @available(iOS 11.0, *)
    //    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        if let block = leadingSwipeActionsConfigurationForRowAtIndexPathBlock {
    //            return block(tableView, indexPath)
    //        }
    //        return nil
    //    }
    //
    //    @available(iOS 11.0, *)
    //    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        if let block = trailingSwipeActionsConfigurationForRowAtIndexPathBlock {
    //            return block(tableView, indexPath)
    //        }
    //        return nil
    //    }

    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        if let block = shouldIndentWhileEditingRowAtIndexPathBlock {
            return block(tableView, indexPath)
        }
        return true
    }

    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        willBeginEditingRowAtIndexPathBlock?(tableView, indexPath)
    }

    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        didEndEditingRowAtIndexPathBlock?(tableView, indexPath)
    }
}
