
//
//  DDVideoPlayerLoadingIndicator.swift
//  mpdemo
//
//  Created by leo on 2018/10/30.
//  Copyright © 2018年 dd01.leo. All rights reserved.
//

import UIKit

private let kRotationAnimationKey = "kRotationAnimationKey.rotation"

class DDVideoPlayerLoadingIndicator: UIView {
    
    private let indicatorLayer = CAShapeLayer()
    
    var timingFunction : CAMediaTimingFunction!
    var isAnimating = false
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        if let path = Bundle(for: DDVideoPlayerLoadingIndicator.classForCoder()).path(forResource: "DDVideoPlayer", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "video_ratation", in: bundle, compatibleWith: nil) {
            imageView.image = image
        }
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
//    public var lineWidth: CGFloat {
//        get {
//            return indicatorLayer.lineWidth
//        }
//        set(newValue) {
//            indicatorLayer.lineWidth = newValue
//            updateIndicatorLayerPath()
//        }
//    }

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
//        indicatorLayer.frame = bounds
//        updateIndicatorLayerPath()
        imageView.frame = bounds
    }
}

//MARK --- public method
extension DDVideoPlayerLoadingIndicator {
    func startAnimating() {
        if self.isAnimating {
            return
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = (2 * Double.pi)
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
//        indicatorLayer.add(animation, forKey: kRotationAnimationKey)
        imageView.layer.add(animation, forKey: kRotationAnimationKey)
        isAnimating = true;
    }
    
    func stopAnimating() {
        if !isAnimating {
            return
        }
        imageView.layer.removeAnimation(forKey: kRotationAnimationKey)
//        indicatorLayer.removeAnimation(forKey: kRotationAnimationKey)
        isAnimating = false;
    }
}

//MARK --- private method
private extension DDVideoPlayerLoadingIndicator {
    private func commonInit(){
//        timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        setupIndicatorLayer()
        addSubview(imageView)
    }
    
//    private func setupIndicatorLayer() {
//        indicatorLayer.strokeColor = UIColor.white.cgColor
//        indicatorLayer.fillColor = nil
//        indicatorLayer.lineWidth = 2.0
//        indicatorLayer.lineJoin = kCALineJoinRound;
//        indicatorLayer.lineCap = kCALineCapRound;
//        layer.addSublayer(indicatorLayer)
////        updateIndicatorLayerPath()
//    }
    
//    private func updateIndicatorLayerPath() {
//        let center = CGPoint(x: bounds.midX, y: bounds.midY)
//        let radius = min(bounds.width / 2, bounds.height / 2) - indicatorLayer.lineWidth / 2
//        let startAngle: CGFloat = 0
//        let endAngle: CGFloat = 2 * CGFloat(Double.pi)
//        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//        indicatorLayer.path = path.cgPath
//
//        indicatorLayer.strokeStart = 0.1
//        indicatorLayer.strokeEnd = 1.0
//    }
//
//    private var strokeColor: UIColor {
//        get {
//            return UIColor(cgColor: indicatorLayer.strokeColor!)
//        }
//        set(newValue) {
//            indicatorLayer.strokeColor = newValue.cgColor
//        }
//    }
}
