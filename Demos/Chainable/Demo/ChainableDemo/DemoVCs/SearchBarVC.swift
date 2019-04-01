//
//  SearchBarVC.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/11.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

class SearchBarVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        //支持所有delegate回调
        searchBar
            .placeholder("点击我输入")
            .tintColor(UIColor.orange)
            .addSearchBarShouldBeginEditingBlock { (bar) -> (Bool) in
                return true
            }
            .addSearchBarTextDidBeginEditingBlock({ (bar) in
                bar.setShowsCancelButton(true, animated: true)
            })
            .addSearchBarTextShouldChangeTextInRangeReplacementTextBlock { (bar, text) -> (Bool) in
                print(text)
                return true
            }
            .addSearchBarTextDidEndEditingBlock { (bar) in
                bar.setShowsCancelButton(false, animated: true)
            }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    deinit {
        print(self)
    }

}
