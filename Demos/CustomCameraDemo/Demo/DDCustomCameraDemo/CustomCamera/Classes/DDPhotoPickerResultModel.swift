
//
//  DDPhotoPickerResultModel.swift
//  Photo
//
//  Created by USER on 2018/11/14.
//  Copyright © 2018 leo. All rights reserved.
//

import UIKit
import Photos

public struct DDPhotoPickerResultModel {
    var asset: PHAsset?
    var isGIF: Bool?
    var image: UIImage?
    init(aset: PHAsset?, isgif: Bool? = false, im: UIImage?) {
        self.asset = aset
        self.isGIF = isgif
        self.image = im
    }
}
