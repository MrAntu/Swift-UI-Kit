//
//  Refresh.swift
//  Refresh
//
//  Created by senyuhao on 2018/7/2.
//  Copyright © 2018年 dd01. All rights reserved.
//

import Foundation
import MJRefresh
import MobileCoreServices

extension MJRefreshGifHeader {
    
    /// gif动态header
    ///
    /// - Parameters:
    ///   - name: gif的名字，eg : mj.gif, 则name表示为mj即可
    ///   - handler: 回调
    public class func inits(gifName: String, handler: @escaping() -> Void) -> MJRefreshGifHeader? {
        let header = MJRefreshGifHeader {
            handler()
        }
        GifTool.loadingGif(name: gifName) { images, duration in
            header?.setImages(images, duration: duration, for: .idle)
            header?.setImages(images, duration: duration, for: .pulling)
            header?.setImages(images, duration: duration, for: .refreshing)
            header?.setImages(images, duration: duration, for: .willRefresh)
        }
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.stateLabel.isHidden = true
        header?.ignoredScrollViewContentInsetTop = 0
        return header
    }
}

extension MJRefreshBackGifFooter {
    
    /// gif动态footer
    ///
    /// - Parameters:
    ///   - name: 表示gif的名称， eg : mj.gif, 则name表示为mj即可
    ///   - handler: 回调操作
    public class func inits(gifName: String, handler: @escaping() -> Void) -> MJRefreshBackGifFooter? {
        let footer = RefreshBackGifFooter {
            handler()
        }
        GifTool.loadingGif(name: gifName) { images, duration in
            footer?.setImages(images, duration: duration, for: .pulling)
            footer?.setImages(images, duration: duration, for: .refreshing)
            footer?.setImages(images, duration: duration, for: .willRefresh)
        }
        footer?.setTitle(NSLocalizedString("暫無更多數據", comment: ""), for: .noMoreData)
        footer?.ignoredScrollViewContentInsetBottom = 0
        return footer
    }
}

class RefreshBackGifFooter: MJRefreshBackGifFooter {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if state == .noMoreData {
            stateLabel.isHidden = false
        } else {
            stateLabel.isHidden = true
        }
    }
}

class GifTool: NSObject {
    public class func loadingGif(name: String, handler: @escaping(_ images: [UIImage]?, _ duration: Double) -> Void) {
        if let path = Bundle.main.path(forResource: name, ofType: "gif") {
            let data = NSData(contentsOfFile: path)
            let imagesources = imageSourceFromData(data: data)
            let images = imagesFromImageSource(sources: imagesources)
            if let images = images, let imageinfo = images.images {
                handler(imageinfo, images.duration)
            } else {
                handler(nil, 0.0)
            }
        }
    }
    
    private class func imageSourceFromData(data: NSData?) -> CGImageSource? {
        if let data = data {
            let options = [kCGImageSourceShouldCache: true, kCGImageSourceTypeIdentifierHint: kUTTypeGIF] as [CFString: Any]
            return CGImageSourceCreateWithData(data, options as CFDictionary)
        }
        return nil
    }
    
    private class func imagesFromImageSource(sources: CGImageSource?) -> (images: [UIImage]?, duration: Double)? {
        if let sources = sources {
            let count = CGImageSourceGetCount(sources)
            var images = [UIImage]()
            
            var gifDuration = 0.0
            let options = [kCGImageSourceShouldCache: true, kCGImageSourceTypeIdentifierHint: kUTTypeGIF] as [CFString: Any]
            for i in 0 ..< count {
                guard let imageRef = CGImageSourceCreateImageAtIndex(sources, i, options as CFDictionary) else {
                    return (images, gifDuration)
                }
                if count == 1 {
                    gifDuration = Double.infinity
                } else {
                    guard let properties = CGImageSourceCopyPropertiesAtIndex(sources, i, nil), let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
                        let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else {
                            return (images, gifDuration)
                    }
                    gifDuration += frameDuration.doubleValue

                    // 鉴于提供的MJ多为3x图片设计，故这里直接使用3.0，未使用UIScreen.main.scale
                    let image = UIImage(cgImage: imageRef, scale: 3.0, orientation: .up)
                    images.append(image)
                }
            }
            return (images, gifDuration)
        }
        return nil
    }
}
