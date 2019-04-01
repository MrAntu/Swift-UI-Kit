//
//  CityListNormalCell.swift
//  PlacePickerDemo
//
//  Created by weiwei.li on 2019/1/3.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

class CityListNormalCell: UITableViewCell {

    private lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1)
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(line)
        textLabel?.font = UIFont.systemFont(ofSize: 17)
        textLabel?.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue:
            51.0/255.0, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var lineFrame = bounds
        lineFrame.origin.x = 18
        lineFrame.origin.y = bounds.height - 1
        lineFrame.size.height = 1
        lineFrame.size.width = bounds.width - 18
        line.frame = lineFrame
    }

}
