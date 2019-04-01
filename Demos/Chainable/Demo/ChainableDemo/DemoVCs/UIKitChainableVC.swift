//
//  UIKitChainableVC.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/8.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

class UIKitChainableVC: UIViewController {
    @IBOutlet weak var lab: UILabel!
    @IBOutlet weak var slider: UISlider!
  
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var switchView: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //UIView 扩展了单击，双击，长按手势
        UIView()
//            .frame(CGRect(x: 50, y: 400, width: 50, height: 50))
            .backgroundColor(UIColor.black)
            .sizeFit()
            .isUserInteractionEnabled(true)
            .addTapGesture { (v, tap) in
                print("单击")
            }
            .addDoubleGesture { (v, tap) in
                print("双击")
            }
            .addLongGesture { (v, long) in
                print("长按")
            }
            .add(to: view)
            .makeConstraints { (make) in
                make.left.equalTo(50)
                make.top.equalTo(500)
                make.width.equalTo(50)
                make.height.equalTo(50)
            }
        
        
        lab.backgroundColor(UIColor.red)
            .alpha(0.4)
            .border(UIColor.black, 1)
            .textAlignment(.center)
            .numberOfLines(0)
            .font(12)
            .frame(CGRect(x: 50, y: 200, width: 200, height: 100))
            .text("收到货方式来开发框架地方sdfkhjjhsjfdkh是否点击康师傅")
            .textColor(UIColor.green)
            .shadowColor(UIColor.black)
            .shadowOffset(CGSize(width: 1, height: 2))
            .lineBreakMode(.byCharWrapping)
            .attributedText(NSAttributedString(string: "是打飞机了就开始发动机"))
            .highlightedTextColor(UIColor.purple)
            .isHighlighted(true)
            .isUserInteractionEnabled(true)
            .isEnabled(true)
            .adjustsFontSizeToFitWidth(true)
            .minimumScaleFactor(10)

        
        //Button扩展新功能
        //imagePosition 任意切换文字和图片混合button的位置
        // 提供TargetAction点击事件。目前只提供.touchUpInside
         UIButton(type: .system)
            .frame(CGRect(x: 150, y: 400, width: 50, height: 50))
            .setTitle("按钮", state: .normal)
            .setImage(UIImage(named: "nav_icon_back_black"), state: .normal)
            .setTitleColor(UIColor.red, state: .normal)
            .add(to: view)
            .addActionTouchUpInside({ (btn) in
                print("sdf ")
            })
            .font(18)
            .image(position: .top, space: 10)
            .setBackground(color: UIColor.red, forState: .highlighted)
        
         UIImageView()
            .frame(CGRect(x: 250, y: 400, width: 50, height: 50))
            .addTapGesture { (v, tap) in
                print("图片")
            }
            .image(UIImage(named: "nav_icon_back_black"))
            .add(to: view)

        
        slider
            .maximumValue(1.0)
            .minimumValue(0)
            .value(0)
            .maximumTrackTintColor(UIColor.red)
            .minimumTrackTintColor(UIColor.blue)
            .addAction(events: .valueChanged) {[weak self] (sender) in
                print("slider---\(sender.value)")
                self?.progressView.setProgress(sender.value, animated: true)
            }
        
        switchView
            .onTintColor(UIColor.red)
            .thumbTintColor(UIColor.black)
            .isOn(false)
            .addAction(events: .valueChanged) { (s) in
                print("switch的值：\(s.isOn)")
            }
        
        progressView
            .progress(0)
            .progressViewStyle(.bar)
            .progressTintColor(UIColor.green)
            .trackTintColor(UIColor.yellow)
        
        UISegmentedControl(items: ["吕布", "曹操", "白起","程咬金"])
            .frame(CGRect(x: 50, y: 320, width: 200, height: 30))
            .tintColor(UIColor.red)
            .apportionsSegmentWidthsByContent(true)
            .selectedSegmentIndex(1)
            .addAction(events: .valueChanged) { (sender) in
                print("选中了： \(sender.selectedSegmentIndex)")
            }
            .add(to: view)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    deinit {
        print(self)
    }
}

extension UIKitChainableVC : UITextFieldDelegate {
//   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        
//        return false
//    }
}
