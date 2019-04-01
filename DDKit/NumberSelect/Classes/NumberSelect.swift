//
//  NumberSelect.swift
//  NumberSelectDemo
//
//  Created by weiwei.li on 2019/1/7.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

//fileprivate let numberSelectWidth: CGFloat = 100.0
//fileprivate let numberSelectHeight: CGFloat = 32.0
fileprivate let numberSelectTextColor: UIColor = UIColor(red: 38.0/255.0, green: 38.0/255.0, blue: 38.0/255.0, alpha: 1)
fileprivate let numberSelectFont: UIFont = UIFont.systemFont(ofSize: 16)
fileprivate let numberSelectBorderColor: UIColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1)
fileprivate let numberSelectBorderWidth: CGFloat = 1.0


public class NumberSelect: UIView {
    /// 可选择最少数字
    public var minNumber: Int = 1
    
    /// 可选择最大数字
    public var maxNumber: Int = 10
    
    // 达到最大或最少值都允许回调
    public var isEnableCallBack = false
    
    /// 当前选择的数字
    public var currentNum: Int = 1 {
        didSet {
            if isEnableCallBack == false {
                reduceBtn.isEnabled = currentNum <= minNumber ? false : true
                addBtn.isEnabled = currentNum >= maxNumber ? false : true
            }
            currentNum = currentNum < minNumber ? minNumber : currentNum
            currentNum = currentNum > maxNumber ? maxNumber : currentNum
            numberLab.text = "\(currentNum)"
        }
    }
    
    /// 步进设置
    public var stepNumber: Int = 1
    
    
    /// 选择数字回调
    public var selectedNumberComplete: ((Int) -> ())?
    
    /// 减btn
    public lazy var reduceBtn: UIButton = {
        let btn = UIButton(type: .system)
        if let path = Bundle(for: NumberSelect.classForCoder()).path(forResource: "NumberSelect", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "icoMinus", in: bundle, compatibleWith: nil)
        {
            btn.setImage(image, for: .normal)
        }
        btn.tintColor = UIColor.black
        btn.layer.borderColor = numberSelectBorderColor.cgColor
        btn.layer.borderWidth = numberSelectBorderWidth
        btn.addTarget(self, action: #selector(reduceAction), for: .touchUpInside)
        return btn
    }()
    
    /// 加btn
    public lazy var addBtn: UIButton = {
        let btn = UIButton(type: .system)
        if let path = Bundle(for: NumberSelect.classForCoder()).path(forResource: "NumberSelect", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "icoAdd", in: bundle, compatibleWith: nil)
        {
            btn.setImage(image, for: .normal)
        }
        btn.tintColor = UIColor.black
        btn.layer.borderColor = numberSelectBorderColor.cgColor
        btn.layer.borderWidth = numberSelectBorderWidth
        btn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return btn
    }()
    
    /// 数字显示lab
    public lazy var numberLab: UILabel = {
        let lab = UILabel(frame: CGRect.zero)
        lab.font = numberSelectFont
        lab.textColor = numberSelectTextColor
        lab.textAlignment = .center
        lab.text = "1"
        lab.layer.borderColor = numberSelectBorderColor.cgColor
        lab.layer.borderWidth = numberSelectBorderWidth
        return lab
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(reduceBtn)
        addSubview(addBtn)
        addSubview(numberLab)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(reduceBtn)
        addSubview(addBtn)
        addSubview(numberLab)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let rect = frame
        
        let btnW = rect.height
        let btnH = btnW
        reduceBtn.frame = CGRect(x: 0, y: 0, width: btnW, height: btnH)
        addBtn.frame = CGRect(x: rect.width - btnW - numberSelectBorderWidth * 2, y: 0, width: btnW, height: btnH)
        numberLab.frame = CGRect(x: btnW - numberSelectBorderWidth, y: 0, width: rect.width - btnW * 2, height: btnH)
    }
}

extension NumberSelect {
    
    @objc private func reduceAction() {
        if isEnableCallBack == true && currentNum <= minNumber {
            selectedNumberComplete?(currentNum)
            return
        }
        currentNum -= stepNumber
        selectedNumberComplete?(currentNum)
    }
    
    @objc private func addAction() {
        if isEnableCallBack == true && currentNum >= maxNumber {
            selectedNumberComplete?(currentNum)
            return
        }
        currentNum += stepNumber
        selectedNumberComplete?(currentNum)
    }
}
