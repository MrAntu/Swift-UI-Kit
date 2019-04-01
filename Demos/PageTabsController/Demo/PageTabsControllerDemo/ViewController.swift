//
//  ViewController.swift
//  PageTabsControllerDemo
//
//  Created by USER on 2018/12/18.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
    }
    
    @IBAction func pushAction(_ sender: Any) {
        let vc = SubViewController()
//        present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func segmentedAction(_ sender: Any) {
        let vc = Sub2ViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tabAction(_ sender: Any) {
        let vc = Sub3ViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
