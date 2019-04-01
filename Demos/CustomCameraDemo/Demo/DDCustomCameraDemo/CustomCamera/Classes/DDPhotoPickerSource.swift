//
//  DDPhotoPickerSource.swift
//  Photo
//
//  Created by USER on 2018/10/25.
//  Copyright © 2018年 leo. All rights reserved.
//

import UIKit
import Photos

class DDPhotoPickerSource: NSObject {
    //所有cellMode
    lazy var modelsArr = [DDPhotoGridCellModel]()
    //所有选中的model
    lazy var selectedPhotosArr = [DDPhotoGridCellModel]()
    //preview的model
    lazy var previewPhotosArr = [DDPhotoGridCellModel]()
}

extension DDPhotoPickerSource {
    /// 获取缩略图
    ///
    /// - Parameters:
    ///   - model: model
    ///   - callBack: 回调
    static func imageFromPHImageManager(_ model: DDPhotoGridCellModel?, callBack: @escaping (UIImage?)->()) -> PHImageRequestID {
        guard let model = model else {
            return 0
        }
        //之前设置的100 * 100的大小有时候会转换图片失败 解决办法最后一条  http://stackoverflow.com/questions/31037859/phimagemanager-requestimageforasset-returns-nil-sometimes-for-icloud-photos
        return DDPhotoImageManager.default().requestTargetImage(for: model.asset, targetSize: CGSize.init(width: 140, height: 140)) { (image, _) in
            callBack(image)
        }
    }
    
   /// 获取预览图
   ///
   /// - Parameters:
   ///   - model: model
   ///   - isGIF: 是否是gif
   ///   - callBack: 回调
   /// - Returns: id
   static func requestPreviewImage(for model: DDPhotoGridCellModel?, isGIF: Bool? = false, callBack: @escaping (UIImage?)->()) -> PHImageRequestID {
        //正常图片获取
        return DDPhotoImageManager.default().requestPreviewImage(for: model?.asset,isGIF: model?.isGIF, progressHandler: { (progress: Double, error: Error?, pointer: UnsafeMutablePointer<ObjCBool>, dictionry: Dictionary?) in
            //下载进度
        }, resultHandler: {(image: UIImage?, dictionry: Dictionary?) in
            var downloadFinined = true
            if let cancelled = dictionry![PHImageCancelledKey] as? Bool {
                downloadFinined = !cancelled
            }
            if downloadFinined, let error = dictionry![PHImageErrorKey] as? Bool {
                downloadFinined = !error
            }
            if downloadFinined, let resultIsDegraded = dictionry![PHImageResultIsDegradedKey] as? Bool {
                downloadFinined = !resultIsDegraded
            }
            if downloadFinined, let photoImage = image {
                callBack(photoImage)
            }
        })
    }
    
    static func requesetAVPlayerItem(for model: DDPhotoGridCellModel?, callBack: @escaping (AVPlayerItem?)->()) -> PHImageRequestID {
        guard let model = model else {
            return 0
        }
        return DDPhotoImageManager.default().requestPlayerItem(forVideo: model.asset, options: nil, resultHandler: { (item, dictionry) in
            var downloadFinined = true
            if let cancelled = dictionry![PHImageCancelledKey] as? Bool {
                downloadFinined = !cancelled
            }
            if downloadFinined, let error = dictionry![PHImageErrorKey] as? Bool {
                downloadFinined = !error
            }
            if downloadFinined, let resultIsDegraded = dictionry![PHImageResultIsDegradedKey] as? Bool {
                downloadFinined = !resultIsDegraded
            }
            if downloadFinined, let item = item {
                callBack(item)
            }
        })
    }
}

extension DDPhotoPickerSource {
    /// 初始化previewPhotosArr数组
    func getPreviewPhotosArr() {
        previewPhotosArr.removeAll()
        _ = selectedPhotosArr.map {[weak self] (model) -> Void in
            self?.previewPhotosArr.append(model)
        }
    }
    
    /// 预览时，操作selectedPhotosArr数组
    ///
    /// - Parameter index: 下标
    func previewChangSelectedModel(index: Int) {
        let model = previewPhotosArr[index]
        model.isSelected = !model.isSelected
        //selectedPhotosArr删除或添加选中的model
        addOrDeleteSelectedModel(model: model)
    }
    
    //修改model选中状态
    func selectedBtnChangedCellModel(index: Int) {
        let model = modelsArr[index]
        model.isSelected = !model.isSelected
        addOrDeleteSelectedModel(model: model)
    }
    
    //添加或删除选中选中的model
    func addOrDeleteSelectedModel(model: DDPhotoGridCellModel) {
        if selectedModelIsExist(model: model) == true {
            //清除下标
            model.index = 0
            selectedPhotosArr.remove(at: searchSelectedModelIndex(model: model))
        } else {
            selectedPhotosArr.append(model)
        }
        //重新将数据中的model排序
        sortSelectedPhotosArr()
    }
    
    /// 判断当前model是不是在selectedPhotosArr数组中
    ///
    /// - Parameter model: model
    /// - Returns: bool
    func selectedModelIsExist(model: DDPhotoGridCellModel) -> Bool {
        for item in selectedPhotosArr {
            if item.localIdentifier == model.localIdentifier {
                return true
            }
        }
        return false
    }
    
    /// 寻找model在selectedPhotosArr数组中的下标
    ///
    /// - Parameter model: model
    /// - Returns: int
    func searchSelectedModelIndex(model: DDPhotoGridCellModel) -> Int {
        var index = -1
        for item in selectedPhotosArr {
            index = index + 1
            if item.localIdentifier == model.localIdentifier {
                return index
            }
        }
        return index
    }
    
    /// 将selectedPhotosArr的model重新排序
    func sortSelectedPhotosArr() {
        for (index, model) in selectedPhotosArr.enumerated() {
            model.index = index + 1
        }
    }
}
