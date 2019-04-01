
//
//  DDPhotoPickerBottomView.swift
//  Photo
//
//  Created by USER on 2018/10/25.
//  Copyright © 2018年 leo. All rights reserved.
//

import UIKit

class DDPhotoPickerBottomView: UIView {
    private var rightBtnCallBack: (()->())?
    private var leftBtnCallBack: (()->())?
    
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton(type: .custom)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        rightBtn.addTarget(self, action: #selector(rightBtnAction(button:)), for: .touchUpInside)
        rightBtn.setTitle(Bundle.localizedString("完成"), for: .normal)
        rightBtn.backgroundColor = selectNotEnableColor
        rightBtn.layer.cornerRadius = 4.0
        rightBtn.layer.masksToBounds = true
        rightBtn.isEnabled = false
        return rightBtn
    }()
    
    lazy var leftBtn: UIButton = {
        let leftBtn = UIButton(type: .custom)
        leftBtn.backgroundColor = UIColor.clear
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        leftBtn.addTarget(self, action: #selector(leftBtnAction(button:)), for: .touchUpInside)
        leftBtn.setTitle(Bundle.localizedString("预览"), for: .normal)
        return leftBtn
    }()
    
    init(frame: CGRect, leftBtnCallBack: (() -> ())?, rightBtnCallBack: (() -> ())? ) {
        super.init(frame: frame)
        self.leftBtnCallBack = leftBtnCallBack
        self.rightBtnCallBack = rightBtnCallBack
        //背景颜色
        if let color = DDPhotoStyleConfig.shared.bottomBarBackgroudColor {
            backgroundColor = color
        } else {
            backgroundColor = UIColor(red: 25/255.0, green: 25/255.0, blue: 25/255.0, alpha: 1)
        }
        
        if let color = DDPhotoStyleConfig.shared.bottomBarTintColor {
            leftBtn.setTitleColor(color, for: .normal)
        }
        
        addSubview(rightBtn)
        addSubview(leftBtn)
        rightBtn.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.bottom.equalTo(-10)
            make.width.equalTo(64)
        }
        leftBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(0)
            make.width.equalTo(60)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DDPhotoPickerBottomView {
    //改变button状态
    func didChangeButtonStatus(count: Int) {
        if count > 0 {
            rightBtn.isEnabled = true
            rightBtn.setTitle(Bundle.localizedString("完成") + "(\(count))", for: .normal)
            if let color = DDPhotoStyleConfig.shared.bottomBarTintColor {
                rightBtn.backgroundColor = color
            } else {
                rightBtn.backgroundColor = selectEnableColor
            }

        } else {
            rightBtn.isEnabled = false
            rightBtn.setTitle(Bundle.localizedString("完成"), for: .normal)
            rightBtn.backgroundColor = selectNotEnableColor
        }
    }
}

//MARK: --- action
private extension DDPhotoPickerBottomView {
    @objc func rightBtnAction(button: UIButton) {
        if let rightBtnCallBack = rightBtnCallBack {
            rightBtnCallBack()
        }
    }
    
    @objc func leftBtnAction(button: UIButton) {
        if let leftBtnCallBack = leftBtnCallBack {
            leftBtnCallBack()
        }
    }
}

