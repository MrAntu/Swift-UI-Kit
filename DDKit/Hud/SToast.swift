//
//  SToast.swift
//  EatojoyBiz
//
//  Created by senyuhao on 2/24/2018.
//  Copyright © 2018 dd01. All rights reserved.
//

import SnapKit
import UIKit

public enum ToastPosition: Int {
    case top = 0
    case bottom = 1
    case center = 2
}

public class SToast: NSObject {

    public static let shared = SToast()
    public var backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)                                         // 背景颜色
    public var backgroundCorner: CGFloat = 5                                // 统一圆角设置；若设置circle为true时，该属性无效
    public var titleFont = UIFont.systemFont(ofSize: 16)                    // 标题字体
    public var messageFont = UIFont.systemFont(ofSize: 14)                  // 内容字体
    public var padding: CGFloat = 30.0                                     // position = top 时 距上距离； position = bottom 时， 距下距离
    // position = center时。提示框距离中心点的距离 往上移为正，向下为负
    public var centerPadding: CGFloat = 80.0
    
    public class func show(msg: String, title: String? = nil, container: UIView? = nil, position: ToastPosition? = nil, duration: CGFloat? = nil, circle: Bool? = nil) {
        if let target = container ?? UIApplication.shared.keyWindow {
            if !msg.isEmpty {
                let place = position ?? .center
                let time = duration ?? 2
                DispatchQueue.main.async {
                    SToast.showToast(msg: msg, title: title, container: target, duration: time, position: place, circle: circle)
                }
            }
        }
    }
    
    private class func showToast(msg: String, title: String? = nil, container: UIView, duration: CGFloat, position: ToastPosition, circle: Bool? = nil) {
        let baseview = baseView()
        baseview.tag = 3001
        //防止重复添加
        for subView in container.subviews {
            if subView.tag == baseview.tag {
                subView.removeFromSuperview()
            }
        }
        container.addSubview(baseview)
        
        var height: CGFloat = 10
        if let title = title, !title.isEmpty {
            let titleLabel = self.titleLabel(title: title)
            baseview.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(baseview).offset(8)
                make.centerX.equalTo(baseview)
                make.height.equalTo(20)
            }
            height = 36
        }

        let toast = toastLabel(msg: msg)
        baseview.addSubview(toast)
        let value = SToast.locationInfo(width: container.frame.width * 3 / 4 - 20, toast: toast)
        toast.snp.makeConstraints { make in
            make.top.equalTo(baseview).offset(height)
            make.left.equalTo(baseview).offset(10)
            make.right.equalTo(baseview).offset(-10)
            make.height.equalTo(value.height)
        }

        baseview.snp.makeConstraints { make in
            make.height.equalTo(value.height + height + 12)
            make.width.equalTo(value.width + 20)
            make.centerX.equalTo(container)
            switch position {
            case .top:
                make.top.equalTo(container).offset(SToast.shared.padding)
            case .center:
                make.centerY.equalTo(container).offset(-SToast.shared.centerPadding)
            case .bottom:
                if let container = container as? UIScrollView {
                    make.top.equalTo(container).offset(scrollViewHeight(container: container) - (value.height + height + 12) - SToast.shared.padding)
                } else {
                    make.bottom.equalTo(container.snp.bottom).offset(-SToast.shared.padding)
                }
            }
        }

        if let circle = circle, circle {
            let baseHeight = value.height + height + 12
            baseview.layer.cornerRadius = baseHeight / 2.0
        } else {
            baseview.layer.cornerRadius = SToast.shared.backgroundCorner
        }
        toastAnimate(view: baseview, duration: duration)
    }

    // animate动画
    static func toastAnimate(view: UIView, duration: CGFloat) {
        UIView.animate(withDuration: 0.5,
                       delay: TimeInterval(duration),
                       options: [.curveEaseIn, .beginFromCurrentState],
                       animations: {
                        view.alpha = 0.0
        },
                       completion: { _ in
                        view.removeFromSuperview()
        })
    }

    // toast消失
    static public func dismissToast(container: UIView? = nil) {
        if let toast = container?.subviews.last {
            if toast.tag == 999 {
                toast.removeFromSuperview()
            }
        } else {
            if let toast = UIApplication.shared.keyWindow?.subviews.last {
                if toast.tag == 999 {
                    toast.removeFromSuperview()
                }
            }
        }
    }

    // label自适应高度
    static func locationInfo(width: CGFloat, toast: UILabel) -> CGSize {
        var frame = toast.frame
        frame.size.width = width
        toast.frame = frame
        toast.sizeToFit()
        return toast.frame.size
    }

    // container为scrollview时高度计算
    static func scrollViewHeight(container: UIScrollView) -> CGFloat {
        return container.frame.size.height + container.contentOffset.y
    }
}

extension SToast {
    private class func toastLabel(msg: String) -> UILabel {
        let toast = UILabel(frame: .zero)
        toast.text = msg
        toast.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        toast.numberOfLines = 100
        toast.textAlignment = .center
        toast.lineBreakMode = .byWordWrapping
        toast.font = SToast.shared.messageFont
        return toast
    }

    private class func titleLabel(title: String) -> UILabel {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = title
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleLabel.font = SToast.shared.titleFont
        return titleLabel
    }

    private class func baseView() -> UIView {
        let baseview = UIView(frame: .zero)
        baseview.backgroundColor = SToast.shared.backgroundColor
        baseview.layer.masksToBounds = true
        baseview.tag = 999
        return baseview
    }
}


extension UIView {
    
    /// Toast show
    ///
    /// - Parameters:
    ///   - msg: 提示文字
    ///   - title: 标题
    ///   - position: 位置
    ///   - duration: 时长
    ///   - circle: 是否需要圆角
    public func showToast(msg: String, title: String? = nil, position: ToastPosition? = .center, duration: CGFloat? = 2.0, circle: Bool? = false) {
        SToast.show(msg: msg, title: title, container: self, position: position, duration: duration, circle: circle)
    }
}
