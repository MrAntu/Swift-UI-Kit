//
//  ViewController.swift
//  EmptyDataViewDemo
//
//  Created by USER on 2018/12/11.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func nodataAction(_ sender: Any) {
        let vc = TableViewController()
        vc.dataType = 0
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func licenseAction(_ sender: Any) {
        let vc = TableViewController()
        vc.dataType = 1
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func activityAction(_ sender: Any) {
        let vc = TableViewController()
        vc.dataType = 2
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func integralAction(_ sender: Any) {
        let vc = TableViewController()
        vc.dataType = 3
        navigationController?.pushViewController(vc, animated: true)
    }
    
   
    @IBAction func noNetAction(_ sender: Any) {
        let vc = TableViewController()
        vc.dataType = 4
        navigationController?.pushViewController(vc, animated: true)
    }

}

