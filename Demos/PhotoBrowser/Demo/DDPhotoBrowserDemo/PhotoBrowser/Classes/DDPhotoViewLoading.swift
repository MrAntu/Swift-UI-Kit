
//
//  DDPhotoViewLoading.swift
//  DDPhotoBrowserDemo
//
//  Created by USER on 2018/11/26.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

private let kDDPhotoViewLoadingKey = "kDDPhotoViewLoadingKey.rotation"

class DDPhotoViewLoading: UIView {

    private let indicatorLayer = CAShapeLayer()
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        if let path = Bundle(for: DDPhotoViewLoading.classForCoder()).path(forResource: "DDPhotoBrowser", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "video_ratation", in: bundle, compatibleWith: nil) {
            imageView.image = image
        }
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public override init(frame : CGRect) {
        super.init(frame : frame)
        commonInit()
    }
    
    public convenience init() {
        self.init(frame:CGRect.zero)
        commonInit()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override open func layoutSubviews() {
        imageView.frame = bounds
    }

}

//MARK --- public method
extension DDPhotoViewLoading {
    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = (2 * Double.pi)
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        imageView.layer.add(animation, forKey: kDDPhotoViewLoadingKey)
    }
}

//MARK --- private method
private extension DDPhotoViewLoading {
    private func commonInit(){
        addSubview(imageView)
        startAnimating()
    }
}

