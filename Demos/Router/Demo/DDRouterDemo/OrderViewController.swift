//
//  OrderViewController.swift
//  DDRouterDemo
//
//  Created by weiwei.li on 2019/3/4.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(params)
    }
    
    @IBAction func callBackAction(_ sender: Any) {
        pop(animated: true)
//        dismiss()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
