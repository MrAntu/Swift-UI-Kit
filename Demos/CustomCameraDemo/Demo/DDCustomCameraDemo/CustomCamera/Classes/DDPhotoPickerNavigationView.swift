//
//  DDPhotoPickerNavigationView.swift
//  Photo
//
//  Created by USER on 2018/10/24.
//  Copyright © 2018年 leo. All rights reserved.
//

import UIKit
import SnapKit

class DDPhotoPickerNavigationView: UIView {
    private var rightBtnCallBack: (()->())?
    private var leftBtnCallBack: (()->())?

    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.clear
        return containerView
    }()
    
    lazy var titleLabel: UILabel = {
       let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textAlignment = .center
        if let color = DDPhotoStyleConfig.shared.navigationTintColor {
            titleLabel.textColor = color
        } else {
            titleLabel.textColor = UIColor.white
        }
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.text = Bundle.localizedString("相册")
        return titleLabel
    }()
    
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton(type: .custom)
        rightBtn.backgroundColor = UIColor.clear
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightBtn.addTarget(self, action: #selector(rightBtnAction(button:)), for: .touchUpInside)
        return rightBtn
    }()
    
    lazy var leftBtn: UIButton = {
        let leftBtn = UIButton(type: .custom)
        leftBtn.backgroundColor = UIColor.clear
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        leftBtn.addTarget(self, action: #selector(leftBtnAction(button:)), for: .touchUpInside)
        if let image = DDPhotoStyleConfig.shared.navigationBackImage {
            leftBtn.setImage(image, for: .normal)
        } else {
            if let path = Bundle(for: DDPhotoPickerNavigationView.classForCoder()).path(forResource: "DDPhotoPicker", ofType: "bundle"),
                let bundle = Bundle(path: path),
                let image = UIImage(named: "photo_nav_icon_back_black", in: bundle, compatibleWith: nil)
            {
                leftBtn.setImage(image, for: .normal)
            }
        }
        leftBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        return leftBtn
    }()
    
    init(frame: CGRect, leftBtnCallBack: (() -> ())?, rightBtnCallBack: (() -> ())? ) {
        super.init(frame: frame)
        self.leftBtnCallBack = leftBtnCallBack
        self.rightBtnCallBack = rightBtnCallBack
        if let color = DDPhotoStyleConfig.shared.navigationBackgroudColor {
            backgroundColor = color
        } else {
            backgroundColor = UIColor.black
        }
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(rightBtn)
        containerView.addSubview(leftBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: --- action
extension DDPhotoPickerNavigationView {
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

extension DDPhotoPickerNavigationView {
    private func addConstraint() {
        containerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(DDPhotoNavigationHeight)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(containerView)
            make.center.equalTo(containerView)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(containerView).offset(0)
            make.width.equalTo(50)
            make.right.equalTo(containerView).offset(-12)
        }
        leftBtn.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(containerView).offset(0)
            make.width.equalTo(50)
            make.left.equalTo(containerView).offset(10)
        }
    }
}
