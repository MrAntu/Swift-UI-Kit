//
//  TextFieldVC.swift
//  ChainableDemo
//
//  Created by weiwei.li on 2019/1/10.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

class TextFieldVC: UIViewController {
    @IBOutlet weak var input1: UITextField!
    @IBOutlet weak var input2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // input1 不需要设置代理
        //支持最大长度限制
        // 支持所有代理协议回调
        // 支持输入抖动动画
        //通过系统方法设置代理，只走协议方法
        //不会走链式block回调
        input1.placeholder("我是input1")
            .addShouldBegindEditingBlock { (field) -> (Bool) in
                return true
            }
            .addShouldChangeCharactersInRangeBlock { (field, range, text) -> (Bool) in
                print("input1: \(text)")
                return true
            }
            .maxLength(5)
            .shake(true)
        
        
        //通过系统方法设置代理，只走协议方法
        //不会走链式block回调
        input2.placeholder("我是input2")
            .addShouldBegindEditingBlock({ (input) -> (Bool) in
                print("不会调用")
                return false
            })
            .addShouldChangeCharactersInRangeBlock { (input, range, text) -> (Bool) in
                print("input2:不会调用调我：\(text)")
                return true
            }
            .delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    deinit {
        print(self)
    }
}

extension TextFieldVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.isEqual(input2) {
            print("input2:调代理方法: \(string)")
            return true
        }
        
        return false
    }
}
