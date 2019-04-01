//
//  CityHotCollectionCell.swift
//  PlacePickerDemo
//
//  Created by weiwei.li on 2019/1/3.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

class CityHotCollectionCell: UICollectionViewCell {
    
    public lazy var textLab: UILabel = {
       let lab = UILabel(frame: CGRect.zero)
        lab.textAlignment = .center
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1)
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(textLab)
        contentView.backgroundColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var textLabFrame = bounds
        textLabFrame.origin.x = 10
        textLabFrame.size.width = bounds.width - 10 * 2
        textLab.frame = textLabFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
