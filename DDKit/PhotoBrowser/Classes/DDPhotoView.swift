
//
//  DDPhotoView.swift
//  DDPhotoBrowserDemo
//
//  Created by USER on 2018/11/22.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import Kingfisher

let kMaxZoomScale: CGFloat = 2.0

class DDPhotoView: UIView {
    public lazy var scrollView: DDScrollView = {
        let scrollView = DDScrollView()
        let sWidth = UIScreen.main.bounds.width
        let sHeight = UIScreen.main.bounds.height
        scrollView.frame = CGRect(x: 0, y: 0, width: sWidth, height: sHeight)
        scrollView.backgroundColor = UIColor.clear
        scrollView.delegate = self
        scrollView.clipsToBounds = true
        scrollView.isMultipleTouchEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    public lazy var imageView: AnimatedImageView = {
        let imageView = AnimatedImageView()
        let sWidth = UIScreen.main.bounds.width
        let sHeight = UIScreen.main.bounds.height
        imageView.frame = CGRect(x: 0, y: 0, width: sWidth, height: sHeight)
        imageView.clipsToBounds = true
        imageView.autoPlayAnimatedImage = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activityView.center = CGPoint(x: UIScreen.main.bounds.width / 2.0, y:  UIScreen.main.bounds.height / 2.0)
        activityView.style = .whiteLarge
        return activityView
    }()
    
    //MARK -- 视屏播放相关
    let videoView: PhotoBrowserVideoView = {
        let videoView = PhotoBrowserVideoView()
        videoView.backgroundColor = UIColor.black
        return videoView
    }()

    public var photo: DDPhoto?

    public var zoomEnded: ((CGFloat)->())?
    /// 横屏时是否充满屏幕宽度，默认YES，为NO时图片自动填充屏幕
    public var isFullWidthForLandSpace: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(scrollView)
        addSubview(activityView)
        scrollView.addSubview(imageView)
        activityView.isHidden = false
        
        imageView.addSubview(videoView)
        videoView.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if photo?.isVideo == true {
            let screenWidth: CGFloat = UIScreen.main.bounds.size.width
            let screenHeight: CGFloat = UIScreen.main.bounds.size.height
            imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            videoView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            videoView.setNeedsLayout()
            videoView.layoutIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cleanImage()
        imageView.stopAnimating()
    }
}

extension DDPhotoView {
    public func setupPhoto(_ photo: DDPhoto?) {
        self.photo = photo
        if photo?.isVideo == true {
            activityView.isHidden = true
            videoView.isHidden = false
            videoView.photo = photo
            imageView.image = nil
            return
        }
        videoView.isHidden = true
        loadImage(photo)
    }
    
    public func zoomToRect(_ rect : CGRect, animated: Bool) {
        scrollView.zoom(to: rect, animated: true)
    }
    
    public func resetFrame() {
        scrollView.frame = bounds
        activityView.center = UIApplication.shared.keyWindow?.center ?? CGPoint.zero
        if photo != nil {
            adjustFrame(photo: photo)
        }
    }
        
    func adjustFrame(photo: DDPhoto? = nil) {
        if photo?.isVideo == true {
            return
        }
        scrollView.setZoomScale(1, animated: false)
        var frame = scrollView.frame
        
        if imageView.image != nil {
            let imageSize = imageView.image?.size ?? CGSize.zero
            var imageF = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            
            // 图片的宽度 = 屏幕的宽度
            let ratio = frame.width / imageF.size.width
            imageF.size.width = frame.width
            imageF.size.height = ratio * imageF.size.height
            
            // 默认情况下，显示出的图片的宽度 = 屏幕的宽度
            // 如果IsFullWidthForLandSpace = NO，需要把图片全部显示在屏幕上
            // 此时由于图片的宽度已经等于屏幕的宽度，所以只需判断图片显示的高度>屏幕高度时，将图片的高度缩小到屏幕的高度即可
            if isFullWidthForLandSpace == false {
                // 图片的高度 > 屏幕的高度
                if imageF.size.height > frame.size.height {
                    let scale = imageF.size.width / imageF.size.height
                    imageF.size.height = frame.size.height
                    imageF.size.width = imageF.size.height * scale
                }
            }
            
            // 设置图片的frame
            imageView.frame = imageF
            scrollView.contentSize = imageView.frame.size
            
            if imageF.size.height <= scrollView.bounds.height {
                imageView.center =  CGPoint(x: scrollView.bounds.width * 0.5, y: scrollView.bounds.height * 0.5)
            } else {
                imageView.center = CGPoint(x: scrollView.bounds.width * 0.5, y: imageF.size.height * 0.5)
            }
            
            // 根据图片大小找到最大缩放等级，保证最大缩放时候，不会有黑边
            var maxScale = frame.size.height / imageF.height
            
            maxScale = (frame.width / imageF.size.width) > maxScale ? (frame.size.width / imageF.size.width) : maxScale
            // 超过了设置的最大的才算数
            maxScale = maxScale > kMaxZoomScale ? maxScale : kMaxZoomScale
            // 初始化
            scrollView.minimumZoomScale = 1
            scrollView.maximumZoomScale = maxScale
            scrollView.zoomScale = 1
            
        } else {
            frame.origin = CGPoint.zero
            let width = frame.width
            let height = width
            imageView.bounds = CGRect(x: 0, y: 0, width: width, height: height)
            imageView.center = CGPoint(x: frame.width * 0.5, y: frame.size.height * 0.5)
            // 重置内容大小
            scrollView.contentSize = imageView.frame.size
        }
        
        scrollView.contentOffset = CGPoint.zero
//        if let photo = photo {
//            imageView.contentMode = photo.sourceImageView?.contentMode ?? .scaleToFill
//        } else {
//            imageView.contentMode = .scaleToFill
//        }
        imageView.contentMode = .scaleToFill

        // frame调整完毕，重新设置缩放
        if photo?.isZooming == true {
            zoomToRect((photo?.zoomRect ?? CGRect.zero), animated: false)
        }
    }
    
    func centerOfScrollViewContent(_ scrollView: UIScrollView) -> CGPoint {
        let offsetX = (scrollView.bounds.width > scrollView.contentSize.width) ? (scrollView.bounds.width - scrollView.contentSize.width) * 0.5 : 0
        let offsetY = (scrollView.bounds.height > scrollView.contentSize.height) ? (scrollView.bounds.height - scrollView.contentSize.height) * 0.5 : 0
        
        let actualCenter = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
        return actualCenter
    }
}

extension DDPhotoView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = centerOfScrollViewContent(scrollView)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if let callBack = zoomEnded {
            callBack(scrollView.zoomScale)
        }
    }
}

private extension DDPhotoView {
    func loadImage(_ photo: DDPhoto?) {
        bringSubviewToFront(activityView)
        if let photo = photo {
            scrollView.setZoomScale(1, animated: false)
            if let image = photo.image {
                activityView.stopAnimating()
                activityView.isHidden = true
                scrollView.isScrollEnabled = true
                photo.isFinished = true
                imageView.image = image
                adjustFrame(photo: photo)
                return
            }
            
            // 显示原来的图片
            if imageView.image == nil {
                imageView.image = photo.placeholderImage != nil ? (photo.placeholderImage) : (photo.sourceImageView?.image)
                adjustFrame(photo: photo)
            }
            scrollView.isScrollEnabled = false

            activityView.isHidden = false
            activityView.startAnimating()
            //gif只加载第一帧，防止内存过大
            var options: KingfisherOptionsInfo? = nil
            if photo.isGif == true {
                options = KingfisherOptionsInfo()
                options?.append(.onlyLoadFirstFrame)
            }
            imageView.kf.setImage(with: photo.url, placeholder: photo.placeholderImage, options: nil, progressBlock: { (receivedSize, totalSize) in
            
            }) {[weak self] (image, err, type, url) in
                if err != nil {
                    photo.isFailed = true
                    return
                }
                photo.image = image
                self?.imageView.image = image
                if photo.isFirstPhoto == true && photo.isGif == true {
                    self?.imageView.startAnimating()
                    photo.isFirstPhoto = false
                }
                photo.isFinished = true
                self?.scrollView.isScrollEnabled = true
                self?.activityView.isHidden = true
                self?.activityView.stopAnimating()
            
                self?.adjustFrame(photo: photo)
            }
            
        } else {
            cleanImage()
        }
    }
    
    func cleanImage() {
        imageView.image = nil
        adjustFrame(photo: photo)
    }
}
