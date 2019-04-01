//
//  DDClipperView.swift
//  DDCustomCameraDemo
//
//  Created by USER on 2018/12/10.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

class DDClipperView: UIView {

    public var clipperSize: CGSize?

    public lazy var clipperImgView: UIImageView? = {
        let clipperImgView = UIImageView(frame: CGRect.zero)
        clipperImgView.layer.borderColor = UIColor.white.cgColor
        clipperImgView.layer.borderWidth = 2
        return clipperImgView
    }()
    
    private lazy var fillLayer: CAShapeLayer? = {
        let fillLayer = CAShapeLayer()
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = 0.5
        return fillLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipperImgView?.frame = CGRect(x: 0, y: 100, width: clipperSize?.width ?? 0.0, height: clipperSize?.height ?? 0.0)
        clipperImgView?.center = center
        updateFillLayer()
    }
}

private extension DDClipperView {
    func setupUI() {
        layer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        if let clipperView = clipperImgView {
            addSubview(clipperView)
        }
        
        if let fillLayer = fillLayer {
            layer.addSublayer(fillLayer)
        }
        
    }
    
    func updateFillLayer() {
        let path = UIBezierPath.init(roundedRect: bounds, cornerRadius: 0)
        let circlePath = UIBezierPath.init(roundedRect: clipperImgView?.frame ?? CGRect.zero, cornerRadius: 0)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        fillLayer?.path = path.cgPath
    }
}
