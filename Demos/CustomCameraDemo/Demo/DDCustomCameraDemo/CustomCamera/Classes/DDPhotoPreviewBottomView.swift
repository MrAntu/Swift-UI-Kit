
//
//  DDPhotoPreviewBottomView.swift
//  Photo
//
//  Created by USER on 2018/11/12.
//  Copyright © 2018 leo. All rights reserved.
//

import UIKit

let selectedBackBtnColor = UIColor(red: 67.0 / 255.0, green: 116.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
let normalBackBtnColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)

class DDPhotoPreviewBottomView: UIView {
    public var rightBtnCallBack: (()->())?
    public var leftBtnCallBack: (()->())?
    
    private lazy var selectCircle: UILabel = {
        let selectCircle = UILabel()
        selectCircle.layer.borderWidth = 1
        selectCircle.layer.borderColor = UIColor.white.cgColor
        selectCircle.layer.backgroundColor = normalBackBtnColor.cgColor
        selectCircle.layer.cornerRadius = 9
        selectCircle.layer.masksToBounds = true
        selectCircle.isUserInteractionEnabled = true
        selectCircle.textColor = UIColor.white
        selectCircle.font = UIFont.systemFont(ofSize: 13)
        selectCircle.textAlignment = .center
        return selectCircle
    }()
    
    private lazy var textLab: UILabel = {
        let textLab = UILabel()
        textLab.text = Bundle.localizedString("选择")
        if let color = DDPhotoStyleConfig.shared.bottomBarTintColor {
            textLab.textColor = color
        } else {
            textLab.textColor = UIColor.white
        }
        textLab.font = UIFont.systemFont(ofSize: 12)
        textLab.isUserInteractionEnabled = true
        return textLab
    }()
    
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
    
    private lazy var leftContainer: UIView = {
       let leftContainer = UIView()
        leftContainer.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(leftContainerGesture(_:)))
        leftContainer.addGestureRecognizer(tap)
        return leftContainer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DDPhotoPreviewBottomView {
    func changeSelectedBtnStatus(_ res: Bool? = false, text: String? = "") {
        if res == true {
            if let color = DDPhotoStyleConfig.shared.bottomBarTintColor {
                selectCircle.layer.borderColor = color.cgColor
                selectCircle.layer.backgroundColor = color.cgColor
            } else {
                selectCircle.layer.borderColor = selectedBackBtnColor.cgColor
                selectCircle.layer.backgroundColor = selectedBackBtnColor.cgColor
            }
            selectCircle.text = text
        } else {
            selectCircle.layer.borderColor = UIColor.white.cgColor
            selectCircle.layer.backgroundColor = normalBackBtnColor.cgColor
            selectCircle.text = ""
        }
    }
    
    func changeCompleteBtnStatus(_ count: Int, total: Int = 0) {
        if count > 0 {
            rightBtn.isEnabled = true
            if total > 0 {
                rightBtn.setTitle(Bundle.localizedString("完成") + " (\(count)/\(total))", for: .normal)
            } else {
                rightBtn.setTitle(Bundle.localizedString("完成") + " (\(count))", for: .normal)
            }
            if let color = DDPhotoStyleConfig.shared.bottomBarTintColor {
                rightBtn.backgroundColor = color
            } else {
                rightBtn.backgroundColor = selectEnableColor
            }
        } else {
            rightBtn.isEnabled = false
            if total > 0 {
                rightBtn.setTitle(Bundle.localizedString("完成") + " (\(count)/\(total))", for: .normal)
            } else {
                rightBtn.setTitle(Bundle.localizedString("完成") + " (\(count))", for: .normal)
            }
            rightBtn.backgroundColor = selectNotEnableColor
        }
    }
}

private extension DDPhotoPreviewBottomView {
    func setupUI() {
        if let color = DDPhotoStyleConfig.shared.bottomBarBackgroudColor {
            backgroundColor = color.withAlphaComponent(0.8)
        } else {
            backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        }
        addSubview(leftContainer)
        addSubview(rightBtn)
        leftContainer.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(16)
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.width.equalTo(64)
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-16)
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.width.equalTo(63)
        }
        
        leftContainer.addSubview(selectCircle)
        selectCircle.snp.makeConstraints { (make) in
            make.left.equalTo(leftContainer)
            make.centerY.equalTo(leftContainer)
            make.width.height.equalTo(18)
        }
        
        leftContainer.addSubview(textLab)
        textLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(leftContainer)
            make.left.equalTo(selectCircle.snp.right).offset(8)
        }
    }
}

//MARK: --- action
private extension DDPhotoPreviewBottomView {
    @objc func rightBtnAction(button: UIButton) {
        if let rightBtnCallBack = rightBtnCallBack {
            rightBtnCallBack()
        }
    }
    
    @objc func leftContainerGesture(_ tap: UITapGestureRecognizer) {
        if let leftBtnCallBack = leftBtnCallBack {
            leftBtnCallBack()
        }
    }
}


