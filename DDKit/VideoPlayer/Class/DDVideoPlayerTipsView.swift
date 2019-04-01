//
//  DDVideoPlayerTipsView.swift
//  DDKit
//
//  Created by leo on 2018/11/1.
//  Copyright © 2018年 dd01. All rights reserved.
//

import UIKit
import SnapKit
public class DDVideoPlayerTipsView: UIView {
    
    lazy private var contentLab: UILabel = {
       let lab = UILabel()
        lab.text = "您正在使用非wifi网络"
        lab.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.textAlignment = .center
        return lab
    }()
    
    lazy private var continuePlayBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("点击继续播放", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    
    public var continuePlayBtnCallBack: (()->())?

    public override init(frame : CGRect) {
        super.init(frame : frame)
        setupUI()
    }
    
    public convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
}

private extension DDVideoPlayerTipsView {
    func setupUI() {
        addSubview(contentLab)
        addSubview(continuePlayBtn)
        
        continuePlayBtn.addTarget(self, action: #selector(continueBtnAction(btn:)), for: .touchUpInside)
        
        contentLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(20)
        }
        
        continuePlayBtn.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.top.equalTo(self.contentLab.snp_bottomMargin).offset(10)
            make.centerX.equalTo(self)
        }
    }
    
    @objc func continueBtnAction(btn: UIButton) {
        if let callBack = continuePlayBtnCallBack {
            isHidden = true
            callBack()
        }
    }
}

