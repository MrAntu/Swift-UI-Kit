//
//  NumberSelectVC.swift
//  Example
//
//  Created by weiwei.li on 2019/1/7.
//  Copyright © 2019 dd01. All rights reserved.
//

import UIKit
import DDKit
class NumberSelectVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // size 120 * 30 为ui设置标准大小。
        let number = NumberSelect(frame: CGRect(x: 100, y: 200, width: 120, height: 32))
        number.minNumber = 1
        number.maxNumber = 20
        number.currentNum = 10
        number.stepNumber = 2
        number.selectedNumberComplete = {
            print($0)
        }
        view.addSubview(number)
    }
}
