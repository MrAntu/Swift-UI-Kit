//
//  EBGifTool.swift
//  EatojoyBiz
//
//  Created by senyuhao on 23/03/2018.
//  Copyright © 2018 dd01. All rights reserved.
//

import MobileCoreServices
import UIKit

class EBGifTool: NSObject {
    
    public class func loadingGif(gifName: String, handler: @escaping (_ images: [UIImage]?, _ duration: Double) -> Void) {
        if let path = Bundle.main.path(forResource: gifName, ofType: "gif") {
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
                    
                    let image = UIImage(cgImage: imageRef, scale: UIScreen.main.scale, orientation: .up)
                    images.append(image)
                }
            }
            return (images, gifDuration)
        }
        return nil
    }

}
