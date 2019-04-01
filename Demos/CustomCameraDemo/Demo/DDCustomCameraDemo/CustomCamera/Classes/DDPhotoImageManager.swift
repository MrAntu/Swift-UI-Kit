
//
//  DDPhotoImageManager.swift
//  Photo
//
//  Created by USER on 2018/11/12.
//  Copyright © 2018 leo. All rights reserved.
//

import UIKit
import Photos
public class DDPhotoImageManager: PHCachingImageManager {
    private static let shared = DDPhotoImageManager()
    public override class func `default`() -> DDPhotoImageManager {
        return shared
    }
    
    private var gifImagesCache = [String: [UIImage]]()
    private var gifImagesDurationCache = [String: TimeInterval]()

    private let semaphoreSignal = DispatchSemaphore(value: 1)

}

extension DDPhotoImageManager {
    static func transformAssetType(_ asset: PHAsset?) -> DDAssetMediaType {
        guard let asset = asset else {
            return .unknown
        }
        
        switch asset.mediaType {
        case .audio:
            return .audio
        case .video:
            return .video
        case .image:
            let str: String = asset.value(forKey: "filename") as? String ?? ""
            if str.hasSuffix("GIF") {
                return .gif
            }
            
            if #available(iOS 9.1, *) {
                if asset.mediaSubtypes == .photoLive || Int(asset.mediaSubtypes.rawValue) == 10 {
                    return .livePhoto
                }
            }
            return .image
        default:
            return .unknown
        }
    }
    
    static func getVideoDuration(_ asset: PHAsset?) -> String {
        if asset?.mediaType != .video {
            return ""
        }
        var duration: Int = 0
        if asset?.mediaType == .video {
            duration = Int(asset?.duration ?? 0)
        }
        
        if duration < 60 {
            return String(format: "00:%02ld", arguments: [duration])
        } else if duration < 3600 {
            let m = duration / 60
            let s = duration % 60
            return String(format: "%02ld:%02ld", arguments: [m, s])
        } else {
            let h = duration / 3600
            let m = (duration % 3600) / 60
            let s = duration % 60
            return String(format: "%02ld:%02ld:%02ld", arguments: [h, m, s])
        }
    }
}

extension DDPhotoImageManager {
    
    private func getRequestOptions() -> PHImageRequestOptions {
        let option = PHImageRequestOptions()
        // PHImageRequestOptions是否有效
        option.isSynchronous = true
        // 缩略图的压缩模式设置为无
        option.resizeMode = .fast
        // 缩略图的质量为快速
        option.deliveryMode = .fastFormat
        //必要时从icould下载
        option.isNetworkAccessAllowed = true;
        return option
    }
    
    /// 返回指定大小的图片
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - targetSize: size
    ///   - resultHandler: 回调
    /// - Returns: id
    public func requestTargetImage(for asset: PHAsset?, targetSize: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        guard let asset = asset else {
            return 0
        }
        let option = self.getRequestOptions()
        return self.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: option, resultHandler: { (image, dic) in
            var downloadFinined = true
            if let cancelled = dic?[PHImageCancelledKey] as? Bool {
                downloadFinined = !cancelled
            }
            if downloadFinined, let error = dic?[PHImageErrorKey] as? Bool {
                downloadFinined = !error
            }
            if downloadFinined, let resultIsDegraded = dic?[PHImageResultIsDegradedKey] as? Bool {
                downloadFinined = !resultIsDegraded
            }
            if downloadFinined, let image = image {
                resultHandler(image,dic)
            }
        })
    }

    /// 返回原始图
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - resultHandler: 回调
    /// - Returns: id
    public func requestOriginalImage(for asset: PHAsset?, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        guard let asset = asset else {
            return 0
        }
        let option = self.getRequestOptions()
         let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        return self.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option, resultHandler: { (image, dic) in
            resultHandler(image,dic)
        })
    }
    
    /// 获取原始图片的data（用于上传）
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - resultHandler: 回调
    /// - Returns: id
     public func requestOriginalImageDataForAsset(for asset: PHAsset?, resultHandler: @escaping (Data?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        guard let asset = asset else {
            return 0
        }
        let option = PHImageRequestOptions()
        option.resizeMode = .exact
        option.isNetworkAccessAllowed = true
        option.isSynchronous = true
        return PHCachingImageManager.default().requestImageData(for: asset, options: option, resultHandler: { (data, uti, orientation, dictionry) in
            var downloadFinined = true
            if let cancelled = dictionry?[PHImageCancelledKey] as? Bool {
                downloadFinined = !cancelled
            }
            if downloadFinined, let error = dictionry?[PHImageErrorKey] as? Bool {
                downloadFinined = !error
            }
            if downloadFinined, let resultIsDegraded = dictionry?[PHImageResultIsDegradedKey] as? Bool {
                downloadFinined = !resultIsDegraded
            }
            if downloadFinined, let photoData = data {
                resultHandler(photoData,dictionry)
            }
        })
    }
    
    /// 获取相册视屏播放的item
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - resultHandler: 回调
    /// - Returns: id
    static public func requestVideoForAsset(for asset: PHAsset?, resultHandler: @escaping (AVPlayerItem?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        guard let asset = asset else {
            return 0
        }
        return PHCachingImageManager.default().requestPlayerItem(forVideo: asset, options: nil, resultHandler: { (item, dictionry) in
            var downloadFinined = true
            if let cancelled = dictionry?[PHImageCancelledKey] as? Bool {
                downloadFinined = !cancelled
            }
            if downloadFinined, let error = dictionry?[PHImageErrorKey] as? Bool {
                downloadFinined = !error
            }
            if downloadFinined, let resultIsDegraded = dictionry?[PHImageResultIsDegradedKey] as? Bool {
                downloadFinined = !resultIsDegraded
            }
            if downloadFinined, let item = item {
                resultHandler(item,dictionry)
            }
        })
    }
    
    /// 获取视屏的avasset   用于视屏上传时使用
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - resultHandler: 回调
    /// - Returns: id
    static public func requestAVAssetForAsset(for asset: PHAsset?, resultHandler: @escaping (AVAsset?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        guard let asset = asset else {
            return 0
        }
        return PHCachingImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: { (avAsset, mix, dictionry) in
            var downloadFinined = true
            if let cancelled = dictionry?[PHImageCancelledKey] as? Bool {
                downloadFinined = !cancelled
            }
            if downloadFinined, let error = dictionry?[PHImageErrorKey] as? Bool {
                downloadFinined = !error
            }
            if downloadFinined, let resultIsDegraded = dictionry?[PHImageResultIsDegradedKey] as? Bool {
                downloadFinined = !resultIsDegraded
            }
            if downloadFinined, let avAsset = avAsset {
                resultHandler(avAsset,dictionry)
            }
        })
    }

    
    /// 获取缩略图
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - resultHandler: 回调
    /// - Returns: 请求id
    public func requestThumbnailImage(for asset: PHAsset?, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        guard let asset = asset else {
            return 0
        }
        let option = self.getRequestOptions()
        let targetSize = getThumbnailSize(originSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight))
        return self.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option, resultHandler: { (image, dic) in
            resultHandler(image,dic)
        })
    }
    
    /// 获取预览图
    ///
    /// - Parameters:
    ///   - asset: 照片源
    ///   - progressHandler: 请求进度回调
    ///   - resultHandler: 请求完成回调
    /// - Returns: 请求ID
    public func requestPreviewImage(for asset: PHAsset?, isGIF: Bool? = false, progressHandler: Photos.PHAssetImageProgressHandler?, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        guard let asset = asset else {
            return 0
        }
        let option = PHImageRequestOptions()
        option.resizeMode = .exact
        option.isNetworkAccessAllowed = true
//        option.isSynchronous = true
        option.progressHandler = progressHandler
        
        let targetSize = getPriviewSize(originSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight))
        if isGIF == true {
           _ = requestPreviewImageData(for: asset, progressHandler: nil) { (data, dic) in
            }
        }
        return self.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option) { (image: UIImage?, dictionry: Dictionary?) in
            resultHandler(image, dictionry)
        }
    }
    
    /// 获取原始图data，主要用户获取gif图片
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - progressHandler: 进度回调
    ///   - resultHandler: 回调
    /// - Returns: id
    public func requestPreviewImageData(for asset: PHAsset?,isUpload: Bool? = false, progressHandler: Photos.PHAssetImageProgressHandler?, resultHandler: @escaping (Data?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        guard let asset = asset else {
            resultHandler(nil,nil)
            return 0
        }
        //判断缓存中是否数据,有就直接返回
        let tempIamges = getImagesCache(asset.localIdentifier)
        if tempIamges != nil {
            resultHandler(nil,nil)
            return 0
        }
        
        let option = PHImageRequestOptions()
        option.resizeMode = .exact
        option.isNetworkAccessAllowed = true
//        option.isSynchronous = true
        option.progressHandler = progressHandler
        return self.requestImageData(for: asset, options: option, resultHandler: {[weak self] (data, uti, orientation, dictionry) in
            var downloadFinined = true
            if let cancelled = dictionry?[PHImageCancelledKey] as? Bool {
                downloadFinined = !cancelled
            }
            if downloadFinined, let error = dictionry?[PHImageErrorKey] as? Bool {
                downloadFinined = !error
            }
            if downloadFinined, let resultIsDegraded = dictionry?[PHImageResultIsDegradedKey] as? Bool {
                downloadFinined = !resultIsDegraded
            }
            if downloadFinined, let photoData = data {
                if isUpload == false {
                    self?.getImages(photoData, localIdentifier: asset.localIdentifier)
                }
                resultHandler(data,dictionry)
            }
        })
    }
    
    func getImages(_ photoData: Data, localIdentifier: String) {
        //判断缓存中是否数据,有就直接返回
        let tempIamges = getImagesCache(localIdentifier)
        if tempIamges != nil {
            return
        }
        
        DispatchQueue.global().async {
            //2.从data中读取数据，转换为CGImageSource
            guard let imageSource = CGImageSourceCreateWithData(photoData as CFData, nil) else {return}
            let imageCount = CGImageSourceGetCount(imageSource)
            //3.遍历所有图片
            var images = [UIImage]()
            var totalDuration : TimeInterval = 0
            for i in 0..<imageCount {
                //3.1取出图片
                guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else {continue}
                let image = UIImage(cgImage: cgImage)
                images.append(image)
                
                //3.2取出持续时间
                guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary  else {continue}
                guard let gifDict = properties[kCGImagePropertyGIFDictionary]  as? NSDictionary else  {continue}
                guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else {continue}
                totalDuration += frameDuration.doubleValue
            }
            //缓存数据
            self.setImagesCache(localIdentifier, obj: images)
            self.setImagesDurationCache(localIdentifier, obj: totalDuration)
        }
    }
    
    public func setImagesCache(_ key: String, obj: [UIImage]) {
        semaphoreSignal.wait()
        gifImagesCache[key] = obj
        semaphoreSignal.signal()
    }
    
    public func setImagesDurationCache(_ key: String, obj: TimeInterval) {
        semaphoreSignal.wait()
        gifImagesDurationCache[key] = obj
        semaphoreSignal.signal()
    }
    
    public func getImagesCache(_ key: String) -> [UIImage]? {
        return gifImagesCache[key]
    }
    
    public func getImagesDurationCache(_ key: String) -> TimeInterval? {
        return gifImagesDurationCache[key]
    }
    
    public func removeImagesCacheObj(_ key: String) {
        gifImagesCache.removeValue(forKey: key)
    }
    
    public func removeImagesDurationCacheObj(_ key: String) {
        gifImagesDurationCache.removeValue(forKey: key)
    }
    
    public func removeAllCache() {
        gifImagesDurationCache.removeAll()
        gifImagesCache.removeAll()
    }
}

private extension DDPhotoImageManager {
    func getThumbnailSize(originSize: CGSize) -> CGSize {
        let thumbnailWidth: CGFloat = (DDPhotoScreenWidth - 5 * 5) / 4 * UIScreen.main.scale
        let pixelScale = CGFloat(originSize.width)/CGFloat(originSize.height)
        let thumbnailSize = CGSize(width: thumbnailWidth, height: thumbnailWidth/pixelScale)
        return thumbnailSize
    }
    
    private func getPriviewSize(originSize: CGSize) -> CGSize {
        let width = originSize.width
        let height = originSize.height
        let pixelScale = CGFloat(width)/CGFloat(height)
        var targetSize = CGSize()
        if width <= 1280 && height <= 1280 {
            //a，图片宽或者高均小于或等于1280时图片尺寸保持不变，不改变图片大小
            targetSize.width = CGFloat(width)
            targetSize.height = CGFloat(height)
        } else if width > 1280 && height > 1280 {
            //宽以及高均大于1280，但是图片宽高比例大于(小于)2时，则宽或者高取小(大)的等比压缩至1280
            if pixelScale > 2 {
                targetSize.width = 1280*pixelScale
                targetSize.height = 1280
            } else if pixelScale < 0.5 {
                targetSize.width = 1280
                targetSize.height = 1280/pixelScale
            } else if pixelScale > 1 {
                targetSize.width = 1280
                targetSize.height = 1280/pixelScale
            } else {
                targetSize.width = 1280*pixelScale
                targetSize.height = 1280
            }
        } else {
            //b,宽或者高大于1280，但是图片宽度高度比例小于或等于2，则将图片宽或者高取大的等比压缩至1280
            if pixelScale <= 2 && pixelScale > 1 {
                targetSize.width = 1280
                targetSize.height = 1280/pixelScale
            } else if pixelScale > 0.5 && pixelScale <= 1 {
                targetSize.width = 1280*pixelScale
                targetSize.height = 1280
            } else {
                targetSize.width = CGFloat(width)
                targetSize.height = CGFloat(height)
            }
        }
        return targetSize
    }
}
