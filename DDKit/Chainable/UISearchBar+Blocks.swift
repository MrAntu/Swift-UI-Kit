//
//  UISearchBar+Blocks.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/11.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    fileprivate struct SearchBarKey {
        static var SearchBarShouldBeginEditing = "SearchBarShouldBeginEditing"
        static var SearchBarTextDidBeginEditing = "SearchBarTextDidBeginEditing"
        static var SearchBarShouldEndEditing = "SearchBarShouldEndEditing"
        static var SearchBarTextDidEndEditing = "SearchBarTextDidEndEditing"
        static var SearchBarTextDidChange = "SearchBarTextDidChange"
        static var SearchBarTextShouldChangeTextInRangeReplacementText = "SearchBarTextShouldChangeTextInRangeReplacementText"
        static var SearchBarSearchButtonClicked = "SearchBarSearchButtonClicked"
        static var SearchBarBookmarkButtonClicked = "SearchBarBookmarkButtonClicked"
        static var SearchBarCancelButtonClicked = "SearchBarCancelButtonClicked"
        static var SearchBarResultsListButtonClicked = "SearchBarResultsListButtonClicked"
        static var SearchBarSelectedScopeButtonIndexDidChange = "SearchBarSelectedScopeButtonIndexDidChange"
    }
    
    fileprivate var searchBarShouldBeginEditingBlock: ((UISearchBar)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &SearchBarKey.SearchBarShouldBeginEditing) as? ((UISearchBar) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &SearchBarKey.SearchBarShouldBeginEditing, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var searchBarTextDidBeginEditingBlock: ((UISearchBar)->())? {
        get {
            return objc_getAssociatedObject(self, &SearchBarKey.SearchBarTextDidBeginEditing) as? ((UISearchBar) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &SearchBarKey.SearchBarTextDidBeginEditing, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var searchBarShouldEndEditingBlock: ((UISearchBar)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &SearchBarKey.SearchBarShouldEndEditing) as? ((UISearchBar) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &SearchBarKey.SearchBarShouldEndEditing, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var searchBarTextDidEndEditingBlock: ((UISearchBar)->())? {
        get {
            return objc_getAssociatedObject(self, &SearchBarKey.SearchBarTextDidEndEditing) as? ((UISearchBar) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &SearchBarKey.SearchBarTextDidEndEditing, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var searchBartextDidChangeBlock: ((UISearchBar,String)->())? {
        get {
            return objc_getAssociatedObject(self, &SearchBarKey.SearchBarTextDidChange) as? ((UISearchBar,String) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &SearchBarKey.SearchBarTextDidChange, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var searchBarTextShouldChangeTextInRangeReplacementTextBlock: ((UISearchBar,String)->(Bool))? {
        get {
            return objc_getAssociatedObject(self, &SearchBarKey.SearchBarTextShouldChangeTextInRangeReplacementText) as? ((UISearchBar,String) -> (Bool))
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &SearchBarKey.SearchBarTextShouldChangeTextInRangeReplacementText, value, .OBJC_ASSOCIATION_COPY);
        }
    }

    fileprivate var searchBarSearchButtonClickedBlock: ((UISearchBar)->())? {
        get {
            return objc_getAssociatedObject(self, &SearchBarKey.SearchBarSearchButtonClicked) as? ((UISearchBar) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &SearchBarKey.SearchBarSearchButtonClicked, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var searchBarBookmarkButtonClickedBlock: ((UISearchBar)->())? {
        get {
            return objc_getAssociatedObject(self, &SearchBarKey.SearchBarBookmarkButtonClicked) as? ((UISearchBar) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &SearchBarKey.SearchBarBookmarkButtonClicked, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var searchBarCancelButtonClickedBlock: ((UISearchBar)->())? {
        get {
            return objc_getAssociatedObject(self, &SearchBarKey.SearchBarCancelButtonClicked) as? ((UISearchBar) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &SearchBarKey.SearchBarCancelButtonClicked, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate var searchBarResultsListButtonClickedBlock: ((UISearchBar)->())? {
        get {
            return objc_getAssociatedObject(self, &SearchBarKey.SearchBarResultsListButtonClicked) as? ((UISearchBar) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &SearchBarKey.SearchBarResultsListButtonClicked, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    

    fileprivate var searchBarselectedScopeButtonIndexDidChangeBlock: ((UISearchBar, Int)->())? {
        get {
            return objc_getAssociatedObject(self, &SearchBarKey.SearchBarResultsListButtonClicked) as? ((UISearchBar,Int) -> ())
        }
        set(value) {
            setDelegate()
            objc_setAssociatedObject(self, &SearchBarKey.SearchBarResultsListButtonClicked, value, .OBJC_ASSOCIATION_COPY);
        }
    }
    
    fileprivate func setDelegate() {
        if delegate == nil || delegate?.isEqual(self) == false {
            delegate = self
        }
    }
}

// MARK: - public method
extension UISearchBar {
    public func setSearchBarShouldBeginEditingBlock(_ handler: @escaping((_ searchBar: UISearchBar)->(Bool))) {
        searchBarShouldBeginEditingBlock = handler
    }
    
    public func setSearchBarTextDidBeginEditingBlock(_ handler: @escaping((_ searchBar: UISearchBar)->())) {
        searchBarTextDidBeginEditingBlock = handler
    }
    
    public func setSearchBarShouldEndEditingBlock(_ handler: @escaping((_ searchBar: UISearchBar)->(Bool))) {
        searchBarShouldEndEditingBlock = handler
    }
    
    public func setSearchBarTextDidEndEditingBlock(_ handler: @escaping((_ searchBar: UISearchBar)->())) {
        searchBarTextDidEndEditingBlock = handler
    }
    
    public func setSearchBartextDidChangeBlock(_ handler: @escaping((_ searchBar: UISearchBar, _ searchText: String)->())) {
        searchBartextDidChangeBlock = handler
    }
    
    public func setSearchBarTextShouldChangeTextInRangeReplacementTextBlock(_ handler: @escaping((_ searchBar: UISearchBar, _ replacementText: String)->(Bool))) {
        searchBarTextShouldChangeTextInRangeReplacementTextBlock = handler
    }
    
    public func setSearchBarSearchButtonClickedBlock(_ handler: @escaping((_ searchBar: UISearchBar)->())) {
        searchBarSearchButtonClickedBlock = handler
    }
    
    public func setSearchBarBookmarkButtonClickedBlock(_ handler: @escaping((_ searchBar: UISearchBar)->())) {
        searchBarBookmarkButtonClickedBlock = handler
    }
    
    public func setSearchBarCancelButtonClickedBlock(_ handler: @escaping((_ searchBar: UISearchBar)->())) {
        searchBarCancelButtonClickedBlock = handler
    }
    
    public func setSearchBarResultsListButtonClickedBlock(_ handler: @escaping((_ searchBar: UISearchBar)->())) {
        searchBarResultsListButtonClickedBlock = handler
    }
    
    public func setSearchBarselectedScopeButtonIndexDidChangeBlock(_ handler: @escaping((_ searchBar: UISearchBar, _ selectedScope: Int)->())) {
        searchBarselectedScopeButtonIndexDidChangeBlock = handler
    }
}

extension UISearchBar: UISearchBarDelegate {
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if let block = searchBarShouldBeginEditingBlock {
            return block(searchBar)
        }
        return true
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarTextDidBeginEditingBlock?(searchBar)
    }
    
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if let block = searchBarShouldEndEditingBlock {
            return block(searchBar)
        }
        return true
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarTextDidEndEditingBlock?(searchBar)
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBartextDidChangeBlock?(searchBar, searchText)
    }
    
    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let block = searchBarTextShouldChangeTextInRangeReplacementTextBlock {
            return block(searchBar, text)
        }
        return true
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarSearchButtonClickedBlock?(searchBar)
    }
    
    public func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        searchBarBookmarkButtonClickedBlock?(searchBar)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarCancelButtonClickedBlock?(searchBar)
    }
    
    public func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        searchBarResultsListButtonClickedBlock?(searchBar)
    }
    
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchBarselectedScopeButtonIndexDidChangeBlock?(searchBar, selectedScope)
    }
}
