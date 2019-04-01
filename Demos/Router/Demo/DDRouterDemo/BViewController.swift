//
//  BViewController.swift
//  DDRouterDemo
//
//  Created by USER on 2018/12/4.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

class BViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(params)
        let model = params?["model"] as? Model
        print(model)
        
        complete?("111111")
    }
  
    @IBAction func pushCAction(_ sender: Any) {
        pushViewController("CViewController", params: params, animated: true) { (res) in
            print(res)
        }
    }
    
    @IBAction func presentCAction(_ sender: Any) {
        presentViewController("CViewController", params: params, animated: true, complete: nil)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(true)
    }
}
