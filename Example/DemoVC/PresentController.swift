//
//  PresentController.swift
//  Example
//
//  Created by 鞠鹏 on 2018/6/7.
//  Copyright © 2018年 dd01. All rights reserved.
//

import DDKit
import UIKit

class PresentController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func dismissClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        SToast.shared.padding = 30
        SToast.shared.backgroundCorner = 17
        SToast.show(msg: "234234234234234", position: .bottom)
    }
    
}
