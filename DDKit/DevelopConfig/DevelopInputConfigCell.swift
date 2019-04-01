//
//  DevelopInputConfigCell.swift
//  Hotel
//
//  Created by senyuhao on 2018/12/3.
//  Copyright © 2018 HK01. All rights reserved.
//

import UIKit
import SnapKit

class DevelopInputConfigCell: UITableViewCell {

    public var inputBlock: ((_ value: String, _ isBeginEdit: Bool) -> Void)?

    private var textField = UITextField(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configView()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configView()
    }

    public func updateCell(_ sender: String) {
        textField.text = sender
    }

    private func configView() {
        textField.placeholder = "输入环境"
        textField.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldDidBeginAction(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldChangedAction(_:)), for: .editingChanged) //allEditingEvents
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
    }

    @objc private func textFieldDidBeginAction(_ sender: UITextField) {
        let value = textField.text ?? ""
        let settingValue = value.count > 0 ? value : "http://"
        textField.text = settingValue
        inputBlock?(settingValue, true)
    }
    
    @objc private func textFieldChangedAction(_ sender: UITextField) {
        inputBlock?(sender.text ?? "", false)
    }

}
