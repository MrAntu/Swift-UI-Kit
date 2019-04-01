//
//  UIButton+EdgeInsets.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/7.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

public enum ButtonImagePosition {
    case top
    case left
    case bottom
    case right
}

extension UIButton {
    
    /// 设置UIButton图片的位置，可为上左下右四个方向
    ///
    /// - Parameters:
    ///   - position: 位置
    ///   - space: 间隔
    public func imagePosition(_ position: ButtonImagePosition, space: CGFloat) {
        switch position {
        case .top:
            resetEdgeInsets()
            setNeedsLayout()
            layoutIfNeeded()
            
            let contentRect = self.contentRect(forBounds: bounds)
            let titleSize = self.titleRect(forContentRect: contentRect).size
            let imageSize = self.imageRect(forContentRect: contentRect).size
            
            let halfWidth: CGFloat = (titleSize.width + imageSize.width) / 2.0
            let halfHeight: CGFloat = (titleSize.height + imageSize.height) / 2.0
            
            let topInset: CGFloat = CGFloat.minimum(halfHeight, titleSize.height)
            let leftInset: CGFloat = (titleSize.width - imageSize.width) > 0 ? (titleSize.height - imageSize.height) / 2.0 : 0
            let bottomInset = (titleSize.height - imageSize.height) > 0 ? (titleSize.height - imageSize.height) / 2.0 : 0
            let rightInset = CGFloat.minimum(halfWidth, titleSize.width)
            
            titleEdgeInsets = UIEdgeInsets(top: imageSize.height + space, left: -halfWidth, bottom: -titleSize.height - space, right: halfWidth)
            contentEdgeInsets = UIEdgeInsets(top: -bottomInset, left: leftInset, bottom: topInset + space, right: -rightInset)
            
        case .bottom:
            resetEdgeInsets()
            setNeedsLayout()
            layoutIfNeeded()
            
            let contentRect = self.contentRect(forBounds: bounds)
            let titleSize = self.titleRect(forContentRect: contentRect).size
            let imageSize = self.imageRect(forContentRect: contentRect).size
            
            let halfWidth: CGFloat = (titleSize.width + imageSize.width) / 2.0
            let halfHeight: CGFloat = (titleSize.height + imageSize.height) / 2.0
            
            let topInset: CGFloat = CGFloat.minimum(halfHeight, titleSize.height)
            let leftInset: CGFloat = (titleSize.width - imageSize.width) > 0 ? (titleSize.height - imageSize.height) / 2.0 : 0
            let bottomInset = (titleSize.height - imageSize.height) > 0 ? (titleSize.height - imageSize.height) / 2.0 : 0
            let rightInset = CGFloat.minimum(halfWidth, titleSize.width)
            
            titleEdgeInsets = UIEdgeInsets(top: -titleSize.height - space, left: -halfWidth, bottom: imageSize.height + space, right: halfWidth)
            contentEdgeInsets = UIEdgeInsets(top: topInset + space, left: leftInset, bottom: -bottomInset, right: -rightInset)
        
        case .left:
            resetEdgeInsets()
            setNeedsLayout()
            layoutIfNeeded()
            
            titleEdgeInsets = UIEdgeInsets(top: 0, left: space, bottom: 0, right: -space)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: space)
            
        case .right:
            resetEdgeInsets()
            setNeedsLayout()
            layoutIfNeeded()
            
            let contentRect = self.contentRect(forBounds: bounds)
            let titleSize = self.titleRect(forContentRect: contentRect).size
            let imageSize = self.imageRect(forContentRect: contentRect).size
            
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: space)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: 0, right: imageSize.width)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize.width + space, bottom: 0, right: -titleSize.width - space)
        }
    }
    
    fileprivate func resetEdgeInsets() {
        contentEdgeInsets = UIEdgeInsets.zero
        imageEdgeInsets = UIEdgeInsets.zero
        titleEdgeInsets = UIEdgeInsets.zero
    }
}
