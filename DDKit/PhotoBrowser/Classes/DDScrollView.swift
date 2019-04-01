
//
//  DDScrollView.swift
//  DDPhotoBrowserDemo
//
//  Created by USER on 2018/11/22.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

class DDScrollView: UIScrollView {

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panGestureRecognizer {
            if gestureRecognizer.state == .possible {
                if isScrollViewOnTopOrBottom() == true {
                    return false
                }
            }
        }
        return true
    }
    
    func isScrollViewOnTopOrBottom() -> Bool {
        let translation = panGestureRecognizer.translation(in: self)
        if translation.y > 0 && contentOffset.y <= 0 {
            return true
        }
        
        let distance = contentSize.height - bounds.size.height
        
        let maxOffsetY = floor(distance)
        if translation.y < 0 && contentOffset.y >= maxOffsetY {
            return true
        }
        return false
    }

}
