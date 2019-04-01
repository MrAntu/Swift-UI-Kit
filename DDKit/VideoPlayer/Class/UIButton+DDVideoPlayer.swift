
//
//  UIButton+DDVideoPlayer.swift
//  mpdemo
//
//  Created by leo on 2018/10/30.
//  Copyright © 2018年 dd01.leo. All rights reserved.
//


import Foundation
import UIKit

fileprivate let minimumHitArea = CGSize(width: 50, height: 50)

extension UIButton {
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if the button is hidden/disabled/transparent it can't be hit
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 { return nil }
        
        // increase the hit frame to be at least as big as `minimumHitArea`
        let buttonSize = self.bounds.size
        let widthToAdd = max(minimumHitArea.width - buttonSize.width, 0)
        let heightToAdd = max(minimumHitArea.height - buttonSize.height, 0)
        let largerFrame = self.bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        
        // perform hit test on larger frame
        return (largerFrame.contains(point)) ? super.hitTest(point, with: event) : nil
    }
    
}
