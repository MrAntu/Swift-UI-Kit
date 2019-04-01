//
//  ViewController.swift
//  ToastDemo
//
//  Created by USER on 2018/12/10.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func toastAction(_ sender: Any) {
        navigationController?.pushViewController(ToastVC(style: .grouped), animated: true)
    }
    
    @IBAction func hudAction(_ sender: Any) {
        navigationController?.pushViewController(HudVC(style: .grouped), animated: true)
    }
}

