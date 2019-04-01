//
//  DDPhotoGridCellModel.swift
//  Photo
//
//  Created by USER on 2018/10/25.
//  Copyright © 2018年 leo. All rights reserved.
//

import UIKit
import Photos

public enum DDAssetMediaType: Int {
    case unknown
    case image
    case gif
    case livePhoto
    case video
    case audio
}

public class DDPhotoGridCellModel: NSObject {
    //资源对象
    public var asset: PHAsset
    //缩略图 -- 若为视屏，则返回视屏首张图片
    public var image: UIImage?
    //视屏时长
    public var duration: String = ""
    //当前资源类型
    public var type: DDAssetMediaType?
    
    //MARK: -- 下述属性调用无需关心
    //当前cell的indexpath
    public var indexPath: IndexPath?
    //是否选择当前图片
    public var isSelected: Bool = false
    //是否是gif
    public var isGIF: Bool = false
  
    //asset唯一标识符
    public var localIdentifier: String = ""
  

    public var index: Int = 0
   

    init(asset: PHAsset, type: DDAssetMediaType, duration: String) {
        self.asset = asset
        self.type = type
        self.duration = duration
        self.localIdentifier = asset.localIdentifier
        
        if type == .gif {
            self.isGIF = true
        } else {
            self.isGIF = false
        }
    }
}
