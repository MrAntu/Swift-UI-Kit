//
//  Toast.swift
//  EatojoyBiz
//
//  Created by senyuhao on 21/03/2018.
//  Copyright © 2018 dd01. All rights reserved.
//

import Foundation
import PKHUD

extension PKHUD {
    public class func loading(onView view: UIView? = nil) {
        EBGifTool.loadingGif(gifName: "loading") { images, duration in
            if let images = images {
                let scale = UIScreen.main.scale
                let rect = CGRect(x: 0, y: 0, width: 52 * scale, height: 42.5 * scale)
                let imageview = UIImageView(frame: rect)
                imageview.contentMode = .scaleAspectFill
                imageview.animationImages = images
                imageview.animationDuration = duration
                imageview.animationRepeatCount = 0
                imageview.startAnimating()
                imageview.clipsToBounds = true
                
                PKHUD.sharedHUD.contentView = imageview
                loadingConfig(onView: view)
            }
        }
    }
    
    public class func loadingHidden() {
        PKHUD.sharedHUD.hide(false)
    }
    
    public class func show(image: UIImage, title: String?, completion: ((Bool) -> Void)? = nil) {
        let contentView = HUDSquareBaseView(image: image, title: nil, subtitle: title)
        PKHUD.sharedHUD.contentView = contentView
        baseConfig { result in
            if let completion = completion {
                completion(result)
            }
        }
    }
    
    public class func show(rotateImage: UIImage) {
        let contentView = PKHUDRotatingImageView(image: rotateImage, title: nil, subtitle: nil)
        contentView.frame = CGRect(x: 0, y: 0, width: 36.0 * UIScreen.main.scale, height: 36.0 * UIScreen.main.scale)
        PKHUD.sharedHUD.contentView = contentView
        baseConfigUnhide()
    }
    
    public class func show(rotateImage: UIImage, title: String) {
        let contentView = HUDRotatingImageView(image: rotateImage, title: nil, subtitle: title)
        PKHUD.sharedHUD.contentView = contentView
        baseConfig { _ in
            
        }
    }
    
    public class func show(title: String, completion: ((Bool) -> Void)? = nil) {
        let contentView = HUDTextView(text: title)
        let maxinumLabelSize = CGSize(width: 220, height: 999)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)] as [NSAttributedStringKey: Any]
        let expectLabelSize = title.boundingRect(with: maxinumLabelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        contentView.frame = CGRect(x: 0, y: 0, width: expectLabelSize.width + 20, height: expectLabelSize.height + 20)
        
        PKHUD.sharedHUD.contentView = contentView
        baseConfig { result in
            if let completion = completion {
                completion(result)
            }
        }
    }
    
    private class func baseConfig(completion: ((Bool) -> Void)? = nil) {
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        PKHUD.sharedHUD.contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)
        PKHUD.sharedHUD.contentView.superview?.layer.cornerRadius = 4
        PKHUD.sharedHUD.contentView.superview?.superview?.layer.cornerRadius = 4
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1.5) { result in
            if let completion = completion {
                completion(result)
            }
        }
    }
    
    private class func baseConfigUnhide() {
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        PKHUD.sharedHUD.contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)
        PKHUD.sharedHUD.contentView.superview?.layer.cornerRadius = 4
        PKHUD.sharedHUD.contentView.superview?.superview?.layer.cornerRadius = 4
        PKHUD.sharedHUD.show()
    }
    
    private class func loadingConfig(onView view: UIView? = nil) {
        PKHUD.sharedHUD.effect = nil
        PKHUD.sharedHUD.dimsBackground = false
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        PKHUD.sharedHUD.contentView.backgroundColor = .clear
        PKHUD.sharedHUD.contentView.superview?.backgroundColor = .clear
        PKHUD.sharedHUD.contentView.superview?.superview?.backgroundColor = .clear
        PKHUD.sharedHUD.show(onView: view)
    }
}

class HUDSquareBaseView: PKHUDSquareBaseView {
    
    override init(image: UIImage?, title: String?, subtitle: String?) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 90, height: 90)))
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.imageView.image = image
        subtitleLabel.text = subtitle
        
        addSubview(imageView)
        addSubview(subtitleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        let viewWidth = bounds.size.width
        let viewHeight = bounds.size.height
        
        var hasSub = false
        if let text = subtitleLabel.text, !text.isEmpty {
            hasSub = true
        }
        
        let halfHeight = CGFloat(ceilf(CFloat(viewHeight / 2.0)))
        let quarterHeight = hasSub ? CGFloat(ceilf(CFloat(viewHeight / 7.0))) : CGFloat(ceilf(CFloat(viewHeight / 4.0)))
        let threeQuarterHeight = hasSub ? CGFloat(ceilf(CFloat(viewHeight / 24.0 * 17.0))) : CGFloat(ceilf(CFloat(viewHeight / 4.0 * 3.0)))
        
        imageView.frame = CGRect(origin: CGPoint(x: 0.0, y: quarterHeight), size: CGSize(width: viewWidth, height: halfHeight))
        subtitleLabel.frame = CGRect(origin: CGPoint(x: 0.0, y: threeQuarterHeight), size: CGSize(width: viewWidth, height: quarterHeight))
    }
}

class HUDTextView: PKHUDTextView {
    override init(text: String?) {
        super.init(text: text)
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class HUDRotatingImageView: PKHUDRotatingImageView {
    
    override init(image: UIImage?, title: String?, subtitle: String?) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 90, height: 90)))
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.imageView.image = image
        subtitleLabel.text = subtitle
        
        addSubview(imageView)
        addSubview(subtitleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        let viewWidth = bounds.size.width
        let viewHeight = bounds.size.height
        
        var hasSub = false
        if let text = subtitleLabel.text, !text.isEmpty {
            hasSub = true
        }
        
        let halfHeight = CGFloat(ceilf(CFloat(viewHeight / 2.0)))
        let quarterHeight = hasSub ? CGFloat(ceilf(CFloat(viewHeight / 7.0))) : CGFloat(ceilf(CFloat(viewHeight / 4.0)))
        let threeQuarterHeight = hasSub ? CGFloat(ceilf(CFloat(viewHeight / 24.0 * 17.0))) : CGFloat(ceilf(CFloat(viewHeight / 4.0 * 3.0)))
        
        imageView.frame = CGRect(origin: CGPoint(x: 0.0, y: quarterHeight), size: CGSize(width: viewWidth, height: halfHeight))
        subtitleLabel.frame = CGRect(origin: CGPoint(x: 0.0, y: threeQuarterHeight), size: CGSize(width: viewWidth, height: quarterHeight))
    }
}
