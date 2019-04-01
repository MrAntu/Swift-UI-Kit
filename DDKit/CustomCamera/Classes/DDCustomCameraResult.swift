
//
//  DDCustomCameraResult.swift
//  DDCustomCamera
//
//  Created by USER on 2018/11/16.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import Photos

public struct DDCustomCameraResult {
    //资源对象
    public var asset: PHAsset?
    //fale: 为图片， true为视屏
    public var isVideo: Bool?
    //图片 -- 若为视屏，则返回视屏首张图片
    public var image: UIImage?
    //时长
    public var duration: String?
    //从相册中选择照片, 如果此属性有值，上述属性都为空。
//    public var albumArrs: [DDPhotoGridCellModel]?
    //初始化方法
    public init(asset: PHAsset?, isVideo: Bool? = false, image: UIImage?, duration: String? = "", albumArrs: [DDPhotoGridCellModel]? = nil) {
        self.asset = asset
        self.isVideo = isVideo
        self.image = image
        self.duration = duration
//        self.albumArrs = albumArrs
    }
}

