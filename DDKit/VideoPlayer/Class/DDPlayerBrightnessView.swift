//
//  DDPlayerBrightnessView.swift
//  mpdemo
//
//  Created by leo on 2018/10/31.
//  Copyright © 2018年 dd01.leo. All rights reserved.
//

import UIKit

class DDPlayerBrightnessView: UIView {
    
    lazy private var backImage: UIImageView = {
        let backImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 79, height: 76))
        if let path = Bundle(for: DDPlayerBrightnessView.classForCoder()).path(forResource: "DDVideoPlayer", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "ZFPlayer_brightness", in: bundle, compatibleWith: nil) {
            backImage.image = image
        }
        return backImage
    }()
    
    lazy private var titleLab: UILabel = {
        let titleLab = UILabel(frame: CGRect(x: 0, y: 5, width: self.bounds.size.width, height: 30))
        titleLab.font = UIFont.boldSystemFont(ofSize: 16)
        titleLab.textColor = UIColor(red: 0.25, green: 0.22, blue: 0.21, alpha: 1)
        titleLab.textAlignment = .center
        titleLab.text = "亮度"
        return titleLab
    }()
    
    lazy private var longView: UIView = {
        let longView = UIView(frame: CGRect(x: 13, y: 132, width: self.bounds.size.width - 26, height: 7))
        longView.backgroundColor =  UIColor(red: 0.25, green: 0.22, blue: 0.21, alpha: 1)
        return longView
    }()
    
    private var tipArr = [UIImageView]()
    private var orientationDidChange = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: DDVPScreenWidth * 0.5, y: DDVPScreenHeight * 0.5, width: 155, height: 155)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        // 使用UIToolbar实现毛玻璃效果，简单粗暴，支持iOS7+
        let toolBar: UIToolbar = UIToolbar(frame: self.bounds)
        toolBar.alpha = 0.97
        
        addSubview(toolBar)
        
        addSubview(backImage)
        
        addSubview(titleLab)
        
        addSubview(longView)
        
        createTips()
        addNotification()
        addObserver()

        alpha = 0
    }

    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backImage.center =  CGPoint(x: 155 * 0.5, y: 155 * 0.5)
        center = CGPoint(x: DDVPScreenWidth * 0.5, y: DDVPScreenHeight * 0.5)
    }
    
    deinit {
        UIScreen.main.removeObserver(self, forKeyPath: "brightness")
        NotificationCenter.default.removeObserver(self)
        print(self)
    }
}

extension DDPlayerBrightnessView {
    func addObserver() {
        let options = NSKeyValueObservingOptions([.new])
        UIScreen.main.addObserver(self, forKeyPath: "brightness", options: options, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let sound = change?[.newKey] as? CGFloat {
            appearSoundView()
            updateLongView(sound: sound)
        }
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLayer(notify:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func updateLayer(notify: Notification) {
        orientationDidChange = true
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension DDPlayerBrightnessView {
    private func createTips() {
        let tipW: CGFloat = (longView.bounds.size.width - 17) / 16.0
        let tipH: CGFloat = 5.0
        let tipY: CGFloat = 1.0
        
        for i in 0..<16 {
            let tipX: CGFloat = CGFloat(i) * (tipW + 1.0) + 1.0
            let image = UIImageView()
            image.backgroundColor = UIColor.white
            image.frame = CGRect(x: tipX, y: tipY, width: tipW, height: tipH)
            longView.addSubview(image)
            tipArr.append(image)
            
        }
        updateLongView(sound: UIScreen.main.brightness)
    }
    
    private func updateLongView(sound: CGFloat) {
        let stage: CGFloat = 1.0 / 15.0
        let level = Int(sound / stage)
        
        let count = tipArr.count
        for i in 0..<count {
            let img = tipArr[i]
            if i<=level {
                img.isHidden = false
            } else {
                img.isHidden = true
            }
        }
    }
    
    private func appearSoundView() {
        if alpha == 0 {
            orientationDidChange = false
            alpha = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.disAppearSoundView()
            }
        }
    }
    
    private func disAppearSoundView() {
        if alpha == 1 {
            UIView.animate(withDuration: 0.8) {
                self.alpha = 0.0
            }
        }
    }
}
