//
//  PhotoBrowserSlider.swift
//  DDPhotoBrowserDemo
//
//  Created by weiwei.li on 2019/1/23.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

class PhotoBrowserSlider: UISlider {

    public var progressView : UIProgressView = UIProgressView()
    public var touchChangedCallBack: ((Float) -> ())?
    private var sliderPercent: CGFloat = 0.0
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureSlider()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let rect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let newRect = CGRect(x: rect.origin.x, y: rect.origin.y + 1, width: rect.width, height: rect.height)
        return newRect
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.trackRect(forBounds: bounds)
        let newRect = CGRect(origin: rect.origin, size: CGSize(width: rect.size.width, height: 2.0))
        configureProgressView(newRect)
        return newRect
    }
    
    func configureSlider() {
        maximumValue = 1.0
        minimumValue = 0.0
        value = 0.0
        maximumTrackTintColor = UIColor.clear
        minimumTrackTintColor = #colorLiteral(red: 0.262745098, green: 0.4549019608, blue: 1, alpha: 1)
        
        if let path = Bundle(for: PhotoBrowserSlider.classForCoder()).path(forResource: "DDPhotoBrowser", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let thumbImage = UIImage(named: "dd_photo_slider_thumb", in: bundle, compatibleWith: nil) {
            let normalThumbImage = imageSize(image: thumbImage, scaledToSize: CGSize(width: 20, height: 20))
            setThumbImage(normalThumbImage, for: .normal)
            let highlightedThumbImage = imageSize(image: thumbImage, scaledToSize: CGSize(width: 25, height: 25))
            setThumbImage(highlightedThumbImage, for: .highlighted)
        }
        
        backgroundColor = UIColor.clear
        progressView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7988548801)
        progressView.trackTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2964201627)
    }
    
    func imageSize(image: UIImage?, scaledToSize newSize: CGSize) -> UIImage? {
        
        guard let tmpImage = image else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        tmpImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage;
    }
    
    func configureProgressView(_ frame: CGRect) {
        progressView.frame = frame
        insertSubview(progressView, at: 0)
    }
    
    public func setProgress(_ progress: Float, animated: Bool) {
        progressView.setProgress(progress, animated: animated)
    }
}

extension PhotoBrowserSlider {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateTouchPoint(touches)
        callbackTouchEnd(false)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateTouchPoint(touches)
        callbackTouchEnd(false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateTouchPoint(touches)
        callbackTouchEnd(true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateTouchPoint(touches)
        callbackTouchEnd(true)
    }
    
    private func updateTouchPoint(_ touches: Set<UITouch>) {
        let touchPoint = touches.first?.location(in: self)
        let width = frame.size.width
        sliderPercent = (touchPoint?.x ?? 0.0) / width
        self.value = Float(sliderPercent)
    }
    
    private func callbackTouchEnd(_ isTouchEnd: Bool) {
        
        if isTouchEnd == true {
            self.sendActions(for: .valueChanged)
            //回调
            if let callBack = touchChangedCallBack {
                callBack(Float(sliderPercent))
            }
        }
    }
}
