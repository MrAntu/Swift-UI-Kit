//
//  DDCustomCameraManager.swift
//  DDCustomCamera
//
//  Created by USER on 2018/11/15.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


//选择拍摄尺寸
public enum DDCaptureSessionPreset: Int {
    case preset325x288
    case preset640x480
    case preset960x540
    case preset1280x720
    case preset1920x1080
    case preset3840x2160
    
}
/// 导出视屏类型
///
/// - mov: mov
/// - mp4: mp4
public enum DDExportVideoType: Int {
    case mov
    case mp4
}


/// 水印位置，目前还不支持
///
/// - topLeft: 上左
/// - topRight: 上右
/// - center: 中间
/// - bottomLeft: 下左
/// - bottomRight: 下右
public enum DDWatermarkLocation:Int {
    case topLeft
    case topRight
    case center
    case bottomLeft
    case bottomRight
}

public class DDCustomCameraManager: NSObject {
    ///完成回调
    var completionBack: (([DDCustomCameraResult]?)->())?
    
    //当前对象是否是从DDPhotoPicke present呈现,外界调用请勿修改此参数
    var isFromDDPhotoPickerPresent: Bool = false
}

// MARK: - 类方法入口
extension DDCustomCameraManager {
    public static func show(finishedHandler:@escaping ([DDCustomCameraResult]?)->()) {
        let manager = DDCustomCameraManager()
        manager.completionBack = finishedHandler
        manager.presentCameraController()
    }
}

extension DDCustomCameraManager {
    public func presentCameraController() {
        //先授权相册
        DDCustomCameraManager.authorizePhoto { (res) in
            if res == false {
                DDPhotoPickerManager.showAlert(DDPhotoStyleConfig.shared.photoPermission)
                return
            }
            //再授权相机
            DDCustomCameraManager.authorizeCamera {(res) in
                if res == false {
                    DDPhotoPickerManager.showAlert(DDPhotoStyleConfig.shared.cameraPermission)
                    return
                }
                //最后授权麦克风
                if DDPhotoStyleConfig.shared.isEnableRecordVideo == true {
                    DDCustomCameraManager.authorizeMicrophone { (res) in
                        if res == false {
                            DDPhotoPickerManager.showAlert(DDPhotoStyleConfig.shared.microphonePermission)
                            return
                        }
                        //类方法不会循环引用，不能设为weak，否则self为空
                        self.showCamera()
                    }
                } else {
                    //类方法不会循环引用，不能设为weak，否则self为空
                    self.showCamera()
                }
            }
        }
    }
    
    private func showCamera() {
        let vc = getTopViewController
        let controller = DDCustomCameraController()
        controller.isEnableRecordVideo = DDPhotoStyleConfig.shared.isEnableRecordVideo
        controller.isEnableTakePhoto = DDPhotoStyleConfig.shared.isEnableTakePhoto
        controller.circleProgressColor = DDPhotoStyleConfig.shared.circleProgressColor
        controller.sessionPreset = DDPhotoStyleConfig.shared.sessionPreset
        controller.maxRecordDuration = DDPhotoStyleConfig.shared.maxRecordDuration
        controller.isShowClipperView = DDPhotoStyleConfig.shared.isShowClipperView
        controller.isFromDDPhotoPickerPresent = isFromDDPhotoPickerPresent
        controller.photoAssetType = DDPhotoStyleConfig.shared.photoAssetType
        if DDPhotoStyleConfig.shared.isShowClipperView == true {
            controller.isEnableRecordVideo = false
        }
        controller.clipperSize = DDPhotoStyleConfig.shared.clipperSize
        //为何不使用[weak self]，防止当前对象运行完没释放，两者之间无循环引用，不互相持有
        controller.doneBlock = {(image, url) in
            self.save(image, url: url)
        }
        //[DDPhotoGridCellModel]?
        controller.selectedAlbumBlock = {[weak self] arr in
            let result = arr?.map({ (model) -> DDCustomCameraResult in
                let res = model.asset.mediaType == .video ? true : false
                return DDCustomCameraResult(asset: model.asset, isVideo: res, image: model.image, duration: model.duration, albumArrs: nil)
            })
            
            self?.completionBack?(result)
        }
        vc?.present(controller, animated: true, completion: nil)
    }
}

extension DDCustomCameraManager {
    static func getVideoExportFilePath(_ type: DDExportVideoType? = .mp4) -> String {
        let format = (type == .mp4) ? "mp4" : "mov"
        return NSTemporaryDirectory() + getUniqueStrByUUID() + "." + format
    }
    
    static func getUniqueStrByUUID() -> String {
        let uuidObj = CFUUIDCreate(nil)
        let uuidString = CFUUIDCreateString(nil, uuidObj)
        return (uuidString as String?) ?? "\(Date.init(timeIntervalSinceNow: 100))"
    }
    
    // MARK: - ---获取相册权限
    static func authorizePhoto(_ comletion:@escaping (Bool) -> Void) {
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case PHAuthorizationStatus.authorized:
            comletion(true)
        case PHAuthorizationStatus.denied, PHAuthorizationStatus.restricted:
            comletion(false)
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    comletion(status == .authorized ? true:false)
                }
            })
        }
    }
    
    // MARK: - --相机权限
    static func authorizeCamera(_ comletion: @escaping (Bool) -> Void ) {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch granted {
        case AVAuthorizationStatus.authorized:
            comletion(true)
        case AVAuthorizationStatus.denied:
            comletion(false)
        case AVAuthorizationStatus.restricted:
            comletion(false)
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    if granted {
                        comletion(granted)
                    }
                }
            })
        }
    }
    
    // MARK: - --麦克风授权
    static func authorizeMicrophone(_ comletion: @escaping (Bool) -> Void ) {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        switch granted {
        case AVAuthorizationStatus.authorized:
            comletion(true)
        case AVAuthorizationStatus.denied:
            comletion(false)
        case AVAuthorizationStatus.restricted:
            comletion(false)
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    if granted {
                        comletion(granted)
                    }
                }
            })
        }
    }
}

private extension DDCustomCameraManager {
    
    /// 存储图片和视屏
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - url: 视屏url
    func save(_ image: UIImage?, url: URL?) {
        if let image = image {
            saveImageToAlbum(image) {[weak self] (success, asset) in
                if success == true {
                    DispatchQueue.main.async(execute: {
                        if let back = self?.completionBack {
                            let model = DDCustomCameraResult.init(asset: asset, isVideo: false, image: image, duration: "",albumArrs: nil)
                            var arr: [DDCustomCameraResult] = [DDCustomCameraResult]()
                            arr.append(model)
                            back(arr)
                        }

                    })
                }
            }
            return
        }
        
        if let url = url {
            saveVideoToAlbum(url) {[weak self] (success, asset) in
                if success == true {
                    //视屏就获取首张图片
                   _ = DDCustomCameraManager.requestImageForAsset(for: asset, targetSize: DDPhotoStyleConfig.shared.thumbnailSize, resultHandler: { (image, dic) in
                        DispatchQueue.main.async(execute: {
                            if let back = self?.completionBack {
                                let model = DDCustomCameraResult.init(asset: asset, isVideo: true, image: image, duration: self?.getDuration(asset))
                                var arr: [DDCustomCameraResult] = [DDCustomCameraResult]()
                                arr.append(model)
                                back(arr)
                            }
                        })
                    })
                   
                }
            }
        }
    
    }
    
    /// 获取视屏时长
    ///
    /// - Parameter asset: asset
    /// - Returns: 时长
    func getDuration(_ asset: PHAsset?) -> String? {
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
    
    /// 保存视屏到相册
    ///
    /// - Parameters:
    ///   - url: url
    ///   - completion: 回调
    func saveVideoToAlbum(_ url: URL, completion:@escaping (Bool, PHAsset?)->()) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .denied {
            completion(false, nil)
            return
        }
        
        if status == .restricted {
            completion(false, nil)
            return
        }
        
        var placeholderAsset: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let newAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            placeholderAsset = newAssetRequest?.placeholderForCreatedAsset
        }) {[weak self] (success, err) in
            if success == false {
                completion(false, nil)
                return
            }
            
            guard let asset = self?.getAssetFromlocalIdentifier(placeholderAsset?.localIdentifier),
                let desCollection = self?.getDestinationCollection() else {
                    completion(false, nil)
                    return
            }
            
            PHPhotoLibrary.shared().performChanges({
                _ = PHAssetCollectionChangeRequest(for: desCollection, assets: PHAsset.fetchAssets(withLocalIdentifiers: [asset.localIdentifier], options: nil))
            }, completionHandler: { (success, err) in
                completion(success,asset)
            })
        }
        
    }

    /// 保存图片到相册
    ///
    /// - Parameters:
    ///   - image: image
    ///   - completion: 回调
    func saveImageToAlbum(_ image: UIImage, completion:@escaping (Bool, PHAsset?)->()) {

        let status = PHPhotoLibrary.authorizationStatus()
        if status == .denied {
            completion(false, nil)
            return
        }
        
        if status == .restricted {
            completion(false, nil)
            return
        }
        
        var placeholderAsset: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let newAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            placeholderAsset = newAssetRequest.placeholderForCreatedAsset
            
        }) {[weak self] (success, err) in
            if success == false {
                completion(false, nil)
                return
            }
            
            guard let asset = self?.getAssetFromlocalIdentifier(placeholderAsset?.localIdentifier),
                let desCollection = self?.getDestinationCollection() else {
                completion(false, nil)
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
               _ = PHAssetCollectionChangeRequest(for: desCollection, assets: PHAsset.fetchAssets(withLocalIdentifiers: [asset.localIdentifier], options: nil))
            }, completionHandler: { (success, err) in
                completion(success,asset)
            })
        }
    }
    
    /// 获取自定义相册
    ///
    /// - Returns: 自定义相册
    func getDestinationCollection() -> PHAssetCollection? {
        //是否存在自定义相册
        let collectionResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        for number in 0..<collectionResult.count {
            let collection: PHAssetCollection = collectionResult[number]
            if collection.localizedTitle == getAppName() {
                return collection
            }
        }
        
        //新建自定义相册
        var collectionId: String?
        try? PHPhotoLibrary.shared().performChangesAndWait {[weak self] in
            collectionId = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self?.getAppName() ?? "DD01").placeholderForCreatedAssetCollection.localIdentifier
        }
        
        if let id = collectionId {
            return PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [id], options: nil).lastObject
        }
        return nil
    }
    
    
    /// 获取当前app的名字
    ///
    /// - Returns: 名字
    func getAppName() -> String {
        var dic = (Bundle.main.localizedInfoDictionary != nil) ? Bundle.main.localizedInfoDictionary : Bundle.main.infoDictionary
     
        let name = (dic?["CFBundleDisplayName"] != nil) ? dic?["CFBundleDisplayName"] : dic?["CFBundleName"]
        
        return (name as? String) ?? "DD01"
    }
    
    /// 获取PHAsset
    ///
    /// - Parameter localIdentifier: localIdentifier descriptio
    /// - Returns: PHAsset
    func getAssetFromlocalIdentifier(_ localIdentifier: String?) -> PHAsset? {
        guard let localIdentifier = localIdentifier else {
            return nil
        }
        
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
        if result.count > 0 {
            return result.firstObject
        }
        
        return nil
    }
    
    /// 显示无授权信息
    ///
    /// - Parameter text: 标题
    func showAlertNoAuthority(_ text: String?) {
        //弹窗提示
        let alertVC = UIAlertController(title: "提示", message: text, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .default) { (action) in
        }
        let actionCommit = UIAlertAction(title: "去设置", style: .default) { (action) in
            //去设置
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(actionCommit)
        getTopViewController?.present(alertVC, animated: true, completion: nil)
    }
    
    /// 是否有相机授权权限
    ///
    /// - Returns: bool
    func isHaveCameraAuthority() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .restricted || status == .denied {
            return false
        }
        return true
    }
    
    /// 是否有相册访问权限
    ///
    /// - Returns: bool
    func isHavePhotoLibraryAuthority() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            return true
        }
        return false
    }
    
    func isHavaMicrophoneAuthority() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        if status == .restricted || status == .denied {
            return false
        }
        return true
    }
    
    /// 获取当前app最上层vc
    ///
    /// - Returns: controller
    var getTopViewController: UIViewController? {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        return getTopViewController(viewController: rootViewController)
    }
    
    func getTopViewController(viewController: UIViewController?) -> UIViewController? {
        
        if let presentedViewController = viewController?.presentedViewController {
            return getTopViewController(viewController: presentedViewController)
        }
        
        if let tabBarController = viewController as? UITabBarController,
            let selectViewController = tabBarController.selectedViewController {
            return getTopViewController(viewController: selectViewController)
        }
        
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return getTopViewController(viewController: visibleViewController)
        }
        
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return getTopViewController(viewController: pageViewController.viewControllers?.first)
        }
        
        for subView in viewController?.view.subviews ?? [] {
            if let childViewController = subView.next as? UIViewController {
                return getTopViewController(viewController: childViewController)
            }
        }
        return viewController
    }
}

extension DDCustomCameraManager {
    
    /// 获取图片
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - targetSize: 获取图片的size（用于展示实际所需大小）
    ///   - resultHandler: 回调
    /// - Returns: id
    static public func requestImageForAsset(for asset: PHAsset?, targetSize: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        guard let asset = asset else {
            return 0
        }
        let option = PHImageRequestOptions()
        // PHImageRequestOptions是否有效
        option.isSynchronous = true
        // 缩略图的压缩模式设置为无
        /**
         resizeMode：对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
         deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
         这个属性只有在 synchronous 为 true 时有效。
         */
        option.resizeMode = .none
        // 缩略图的质量为快速
        option.deliveryMode = .fastFormat
        //必要时从icould下载
        option.isNetworkAccessAllowed = true;
        
        return PHCachingImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option, resultHandler: { (image, dictionry) in
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
            if downloadFinined, let image = image {
                resultHandler(image,dictionry)
            }
        })
    }
    
    /// 获取原始图片的data（用于上传）
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - resultHandler: 回调
    /// - Returns: id
    static public func requestOriginalImageDataForAsset(for asset: PHAsset?, resultHandler: @escaping (Data?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
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
    
    /// 获取视屏的avasset
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
    
    /// 导出视屏上传临时存储的filepath
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - type: 导出格式
    ///   - presetName: 压缩格式 ，常见的为以下三种
            //AVAssetExportPresetLowQuality
            //AVAssetExportPresetMediumQuality
            //AVAssetExportPresetHighestQuality
    ///   - compelete: 完成回调
    static public func exportVideoFilePath(for asset: PHAsset?, type: DDExportVideoType, presetName: String, compelete:((String?, NSError?)->())?) {
        self.export(for: asset, type: type, presetName: presetName, complete: compelete)
    }
    
    /// 清除沙盒路径下视屏文件
    ///
    /// - Parameter path: 沙盒路径 , 默认是u存储在tmp目录下
    static public func cleanMoviesFile(_ path: String? = NSTemporaryDirectory()) {
        guard let path = path else {
            return
        }
        let manager = FileManager.default
        let subPathArr = try? manager.contentsOfDirectory(atPath: path)
        
        guard let pahtArr = subPathArr else {
            return
        }
        
        for subPath in pahtArr {
            let filePath = path + subPath
            print(filePath)
            //删除子文件夹
            try? manager.removeItem(atPath: filePath)
        }
    }
}

// MARK: - 私有方法
private extension DDCustomCameraManager {
    static func export(for asset: PHAsset?, type: DDExportVideoType, presetName: String, complete:((String?, NSError?)->())?) {
        guard let asset = asset else {
            return
        }
        
        if asset.mediaType != .video {
            if complete != nil {
                complete?(nil, NSError(domain: "导出失败", code: -1, userInfo: ["message": "导出对象不是视频对象"]))
            }
            return
        }
        
        let options = PHVideoRequestOptions()
        options.version = .original
        options.deliveryMode = .automatic
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avAsset, audioMix, info) in
            self.export(for: avAsset, range: CMTimeRange(start: kCMTimeZero, duration: kCMTimePositiveInfinity), type: type, presetName: presetName, complete: { (exportFilePath, error) in
                DispatchQueue.main.async(execute: {
                    if complete != nil {
                        complete?(exportFilePath, error)
                    }
                })
            })
           
        }
    }
    
    static func export(for asset: AVAsset?, range: CMTimeRange, type: DDExportVideoType, presetName: String, complete:((String?, NSError?)->())?) {
        guard let asset = asset  else {
            if complete != nil {
                complete?(nil, NSError(domain: "导出失败", code: -1, userInfo: ["message": "找不到导出对象"]))
            }
            return
        }
        let exportFilePath = self.getVideoExportFilePath(.mp4)
        let exportSession = AVAssetExportSession(asset: asset, presetName: presetName)
        
        let exportFileUrl = URL(fileURLWithPath: exportFilePath)
        exportSession?.outputURL = exportFileUrl
        exportSession?.outputFileType = (type == .mov) ? .mov : .mp4
        exportSession?.timeRange = range
        
        if let session = exportSession {
            session.exportAsynchronously(completionHandler: {
                if session.status == .completed {
                    if complete != nil {
                        complete?(exportFilePath, nil)
                    }
                } else {
                    if complete != nil {
                        complete?(nil, NSError(domain: "导出失败", code: -1, userInfo: nil))
                    }
                    session.cancelExport()
                }
            })
        }
    }
}
