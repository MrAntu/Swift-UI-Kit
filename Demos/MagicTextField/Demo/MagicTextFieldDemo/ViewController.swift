//
//  ViewController.swift
//  MagicTextFieldDemo
//
//  Created by USER on 2018/12/7.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let accountInput = MagicTextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func setupUI() {
        
        accountInput.placeholder = "請輸入手機號碼"
        accountInput.animatedText = "手机号码"
        accountInput.font = UIFont.systemFont(ofSize: 14)
        accountInput.animatedFont = UIFont.systemFont(ofSize: 12)
        accountInput.textAlignment = .left
        accountInput.marginLeft = 10
        accountInput.placeholderColor = UIColor.red
        accountInput.animatedPlaceholderColor = UIColor.blue
        accountInput.moveDistance = 30
        accountInput.borderStyle = .line
        accountInput.frame = CGRect(x: 100, y: 100, width: 200, height: 30)
        view.addSubview(accountInput)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

