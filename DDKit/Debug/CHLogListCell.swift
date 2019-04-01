//
//  CHLogListCell.swift
//  CHLog
//
//  Created by wanggw on 2018/6/30.
//  Copyright © 2018年 UnionInfo. All rights reserved.
//

import UIKit

class CHLogListCell: UITableViewCell {
    private var titleLabel = UILabel()

    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        backgroundColor = UIColor.groupTableViewBackground
        contentView.backgroundColor = UIColor.groupTableViewBackground
        
        if (self.responds(to: #selector(setter: UIView.layoutMargins))) {
            self.layoutMargins = UIEdgeInsets.zero
        }
        if (self.responds(to: #selector(setter: UITableViewCell.separatorInset))) {
            self.separatorInset = UIEdgeInsets.zero
        }
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: -
    
    private func setupUI() {
        titleLabel.frame = contentView.bounds
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
    }

    // MARK: - updateContent
    
    public func updateContent(response: CHLogItem) {
        titleLabel.text = response.requstType
        titleLabel.textColor = response.isRequestError ? UIColor.red : UIColor.black
        titleLabel.frame = CGRect(x: 60, y: 0, width: self.bounds.size.width - 75, height: self.bounds.size.height)
    }
}
