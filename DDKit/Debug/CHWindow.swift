//
//  CHWindow.swift
//  CHLog
//
//  Created by wanggw on 2018/5/28.
//  Copyright © 2018年 UnionInfo. All rights reserved.
//

import UIKit

class CHWindow: UIWindow {
    
    ///重写 hitTest，传递触摸事件到下面的视图
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView: UIView? = super.hitTest(point, with: event)
        if hitView == self {
            return nil
        }
        return hitView
    }
}
