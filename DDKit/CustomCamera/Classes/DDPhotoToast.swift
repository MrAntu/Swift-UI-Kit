//
//  DDPhotoToast.swift
//  Photo
//
//  Created by USER on 2018/11/13.
//  Copyright © 2018 leo. All rights reserved.
//

import UIKit
import SnapKit

let toastDuration: CGFloat = 1.0

class DDPhotoToast: NSObject {
    public class func showToast(msg: String) {
        if let container = UIApplication.shared.keyWindow {
            showToast(msg: msg, container: container)
        }
    }
    
    public class func showToast(msg: String, container: UIView) {
        DispatchQueue.main.async {
            let toast = UILabel(frame: .zero)
            toast.text = msg
            toast.backgroundColor = UIColor.black
            toast.textColor = UIColor.white
            toast.numberOfLines = 100
            toast.tag = 999
            toast.textAlignment = .center
            toast.lineBreakMode = .byWordWrapping
            toast.font = UIFont.systemFont(ofSize: 14)
            
            container.addSubview(toast)
            
            toast.layer.cornerRadius = 5
            toast.layer.masksToBounds = true
            let size = msg.boundingRect(with: CGSize(width: 220, height: 999),
                                        options: .usesLineFragmentOrigin,
                                        attributes: [NSAttributedString.Key.font: toast.font],
                                        context: nil).size
            let height = size.height + 15.0
            let width = size.width <= 220.0 ? size.width + 30 : 220
            toast.snp.makeConstraints { make in
                make.center.equalTo(container)
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
            
            UIView.animate(withDuration: 0.5,
                           delay: TimeInterval(toastDuration),
                           options: [.curveEaseIn, .beginFromCurrentState],
                           animations: {
                            toast.alpha = 0.0
            },
                           completion: { _ in
                            toast.removeFromSuperview()
            })
        }
    }
}
