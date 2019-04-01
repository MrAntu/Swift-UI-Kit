//
//  UISearchBar+Chainable.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/11.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

public extension UIKitChainable where Self: UISearchBar {

    @discardableResult
    func barStyle(_ style: UIBarStyle) -> Self {
        barStyle = style
        return self
    }
    
    @discardableResult
    func text(_ text: String?) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    func prompt(_ text: String?) -> Self {
        prompt = text
        return self
    }
    
    @discardableResult
    func placeholder(_ holder: String?) -> Self {
        placeholder = holder
        return self
    }
    
    @discardableResult
    func showsBookmarkButton(_ bool: Bool) -> Self {
        showsBookmarkButton = bool
        return self
    }
    
    @discardableResult
    func showsCancelButton(_ bool: Bool) -> Self {
        showsCancelButton = bool
        return self
    }
    
    @discardableResult
    func showsSearchResultsButton(_ bool: Bool) -> Self {
        showsSearchResultsButton = bool
        return self
    }
    
    @discardableResult
    func isSearchResultsButtonSelected(_ selected: Bool) -> Self {
        isSearchResultsButtonSelected = selected
        return self
    }
    
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }
    
    @discardableResult
    func barTintColor(_ color: UIColor) -> Self {
        barTintColor = color
        return self
    }
    
    @discardableResult
    func searchBarStyle(_ style: UISearchBar.Style) -> Self {
        searchBarStyle = style
        return self
    }
    
    @discardableResult
    func isTranslucent(_ bool: Bool) -> Self {
        isTranslucent = bool
        return self
    }
    
    @discardableResult
    func scopeButtonTitles(_ titles: [String]?) -> Self {
        scopeButtonTitles = titles
        return self
    }
    
    @discardableResult
    func selectedScopeButtonIndex(_ index: Int) -> Self {
        selectedScopeButtonIndex = index
        return self
    }
    
    @discardableResult
    func showsScopeBar(_ bool: Bool) -> Self {
        showsScopeBar = bool
        return self
    }
    
    @discardableResult
    func inputAccessoryView(_ view: UIView?) -> Self {
        inputAccessoryView = view
        return self
    }
    
    @discardableResult
    func backgroundImage(_ image: UIImage?) -> Self {
        backgroundImage = image
        return self
    }
    
    @discardableResult
    func scopeBarBackgroundImage(_ image: UIImage?) -> Self {
        scopeBarBackgroundImage = image
        return self
    }
    
    @discardableResult
    func searchFieldBackgroundPositionAdjustment(_ offset: UIOffset) -> Self {
        searchFieldBackgroundPositionAdjustment = offset
        return self
    }
    
    @discardableResult
    func searchTextPositionAdjustment(_ offset: UIOffset) -> Self {
        searchTextPositionAdjustment = offset
        return self
    }
}

public extension UIKitChainable where Self: UISearchBar {
    @discardableResult
    public func addSearchBarShouldBeginEditingBlock(_ handler: @escaping((_ searchBar: UISearchBar)->(Bool))) -> Self {
        setSearchBarShouldBeginEditingBlock(handler)
        return self
    }
    
    @discardableResult
    public func addSearchBarTextDidBeginEditingBlock(_ handler: @escaping((_ searchBar: UISearchBar)->())) -> Self {
        setSearchBarTextDidBeginEditingBlock(handler)
        return self
    }
    
    @discardableResult
    public func addSearchBarShouldEndEditingBlock(_ handler: @escaping((_ searchBar: UISearchBar)->(Bool))) -> Self {
        setSearchBarShouldEndEditingBlock(handler)
        return self
    }
    
    @discardableResult
    public func addSearchBarTextDidEndEditingBlock(_ handler: @escaping((_ searchBar: UISearchBar)->())) -> Self {
        setSearchBarTextDidEndEditingBlock(handler)
        return self
    }
    
    @discardableResult
    public func addSearchBartextDidChangeBlock(_ handler: @escaping((_ searchBar: UISearchBar, _ searchText: String)->()))  -> Self {
        setSearchBartextDidChangeBlock(handler)
        return self
    }
    
    @discardableResult
    public func addSearchBarTextShouldChangeTextInRangeReplacementTextBlock(_ handler: @escaping((_ searchBar: UISearchBar, _ replacementText: String)->(Bool))) -> Self {
        setSearchBarTextShouldChangeTextInRangeReplacementTextBlock(handler)
        return self
    }
    
    @discardableResult
    public func addSearchBarSearchButtonClickedBlock(_ handler: @escaping((_ searchBar: UISearchBar)->())) -> Self {
        setSearchBarSearchButtonClickedBlock(handler)
        return self
    }
    
    @discardableResult
    public func addSearchBarBookmarkButtonClickedBlock(_ handler: @escaping((_ searchBar: UISearchBar)->())) -> Self {
        setSearchBarBookmarkButtonClickedBlock(handler)
        return self
    }
    
    @discardableResult
    public func addSearchBarCancelButtonClickedBlock(_ handler: @escaping((_ searchBar: UISearchBar)->())) -> Self {
        setSearchBarCancelButtonClickedBlock(handler)
        return self
    }
    
    @discardableResult
    public func addSearchBarResultsListButtonClickedBlock(_ handler: @escaping((_ searchBar: UISearchBar)->())) -> Self {
        setSearchBarResultsListButtonClickedBlock(handler)
        return self
    }
    
    @discardableResult
    public func setSearchBarselectedScopeButtonIndexDidChangeBlock(_ handler: @escaping((_ searchBar: UISearchBar, _ selectedScope: Int)->())) -> Self {
        setSearchBarselectedScopeButtonIndexDidChangeBlock(handler)
        return self
    }
}
