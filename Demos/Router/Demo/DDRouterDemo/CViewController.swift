//
//  CViewController.swift
//  DDRouterDemo
//
//  Created by USER on 2018/12/5.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

class CViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(params)
    }

    //pop到下一层控制器
    @IBAction func popAction(_ sender: Any) {
        //回调
        complete?("我要pop了")
        pop(animated: true)
    }
    
    // pop到指定的控制器
    @IBAction func popToController(_ sender: Any) {
        pop(ToViewController: "BViewController")
    }
    
    // pop到根控制器
    @IBAction func popToRootController(_ sender: Any) {
        pop(ToRootViewController: true)
    }
    
    //dismiss
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(true)
    }
}
