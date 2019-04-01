//
//  CHButton.swift
//  CHLog
//
//  Created by wanggw on 2018/5/28.
//  Copyright © 2018年 UnionInfo. All rights reserved.
//

import UIKit


/// 自定义 UIButton
class CHButton: UIButton {
    private var moveEnable: Bool = true  //是否可以移动
    private var isMoving: Bool = true //设置正在移动的标志
    private var beginpoint: CGPoint?
}

extension CHButton {
    
    // MARK: touch event
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoving = false
        super.touchesBegan(touches, with: event)
        if !moveEnable {
            return
        }
        let touch = touches.first
        beginpoint = touch?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoving = true
        if !moveEnable {
            return
        }
        let touch = touches.first
        let currentPosition: CGPoint? = touch?.location(in: self)
        //偏移量
        let offsetX = Float((currentPosition?.x ?? 0.0) - (beginpoint?.x ?? 0.0))
        let offsetY = Float((currentPosition?.y ?? 0.0) - (beginpoint?.y ?? 0.0))
        //移动后的中心坐标
        center = CGPoint(x: CGFloat(center.x + CGFloat(offsetX)), y: CGFloat(center.y + CGFloat(offsetY)))
        //x轴左右极限坐标
        if let superview = superview,
            center.x > (superview.frame.size.width - frame.size.width / 2) {
            let x: CGFloat = superview.frame.size.width - frame.size.width / 2
            center = CGPoint(x: x, y: CGFloat(center.y + CGFloat(offsetY)))
        } else if center.x < frame.size.width / 2 {
            let x: CGFloat = frame.size.width / 2
            center = CGPoint(x: x, y: CGFloat(center.y + CGFloat(offsetY)))
        }
        //y轴上下极限坐标
        if let superview = superview,
            center.y > (superview.frame.size.height - frame.size.height / 2) {
            let x: CGFloat = center.x
            let y: CGFloat = superview.frame.size.height - frame.size.height / 2
            center = CGPoint(x: x, y: y)
        } else if center.y <= frame.size.height / 2 {
            let x: CGFloat = center.x
            let y: CGFloat = frame.size.height / 2
            center = CGPoint(x: x, y: y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoving = false
        if !moveEnable {
            return
        }

        updatePosition()
        
        //不加此句话，UIButton将一直处于按下状态
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        updatePosition()
    }
    
    // MARK: update position
    
    private func updatePosition() {
        if let superview = superview,
            center.x >= superview.frame.size.width / 2 {
            UIView.beginAnimations("move", context: nil)
            UIView.setAnimationDuration(0.35)
            UIView.setAnimationDelegate(self)
            frame = CGRect(x: superview.frame.size.width - 60 - 10, y: center.y - 30, width: 60.0, height: 60.0)
            UIView.commitAnimations()
        } else {
            UIView.beginAnimations("move", context: nil)
            UIView.setAnimationDuration(0.35)
            UIView.setAnimationDelegate(self)
            frame = CGRect(x: 0.0 + 10, y: center.y - 30, width: 60.0, height: 60.0)
            UIView.commitAnimations()
        }
    }
}
