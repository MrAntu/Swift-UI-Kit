//
//  PageSegmentViewCell.swift
//  PageTabsControllerDemo
//
//  Created by USER on 2018/12/18.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

class PageSegmentViewCell: UICollectionViewCell {
    public lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    public lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.clipsToBounds = true
        bottomLine.backgroundColor = UIColor.red
        return bottomLine
    }()
    
    public var lineHeight: CGFloat = 2.0
    
    public var lineWidth: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bottomLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutFrame()
    }
    
    private func layoutFrame() {
        let lineW = lineWidth == 1.0 ? bounds.width : lineWidth
        let lineFrame = CGRect(x: (bounds.width - lineW) / 2.0, y: bounds.height - lineHeight, width: lineW, height: lineHeight)
        bottomLine.frame = lineFrame
        
        var titleFrame = bounds
        titleFrame.size.height = titleFrame.height - lineHeight
        titleLabel.frame = titleFrame
    }
    
    func displayCell(title: String,
                     font: UIFont,
                     itemTitleSelectedColor: UIColor,
                     itemTitleNormalColor: UIColor,
                     itemBackgroudNormalColor: UIColor,
                     itemBackgroudSelectedColor: UIColor,
                     bottomLineWidth: CGFloat,
                     bottomLineHeight: CGFloat,
                     bottomLineColor: UIColor,
                     currentIndex: Int,
                     indexPath: IndexPath) {
        titleLabel.text = title
        titleLabel.font = font
        titleLabel.textColor = (currentIndex == indexPath.row ? itemTitleSelectedColor : itemTitleNormalColor)
        if currentIndex == indexPath.row {
            bottomLine.isHidden = false
            bottomLine.backgroundColor = bottomLineColor
            
            lineWidth = bottomLineWidth
            lineHeight = bottomLineHeight
            setNeedsLayout()
            layoutIfNeeded()
        } else {
            bottomLine.isHidden = true
        }
    }
    
}
