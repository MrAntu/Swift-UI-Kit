
//
//  DDPhoto.swift
//  DDPhotoBrowserDemo
//
//  Created by USER on 2018/11/22.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

public class DDPhoto: NSObject {
    /** 图片地址 */
    public var url: URL? {
        didSet {
            if url?.absoluteString.hasSuffix(".gif") == true || url?.absoluteString.hasSuffix(".GIF") == true {
                isGif = true
            }
            
            if url?.absoluteString.hasSuffix(".mp4") == true || url?.absoluteString.hasSuffix(".mov") == true {
                isVideo = true
            }
        }
    }
    /** video */
    public var isVideo: Bool = false
    /** 来源imageView */
    public var sourceImageView: UIImageView?
    /** 来源frame */
    public var sourceFrame: CGRect?
    /** 图片(静态) */
    public var image: UIImage?
    /** 占位图 */
    public var placeholderImage: UIImage?
    
    public override init() {
        
    }
    
    //MARK -- 下述参数无需配置
    /** gif */
    var isGif: Bool = false
    
    /** 图片是否加载完成 */
    var isFinished: Bool = false
    /** 图片是否加载失败 */
    var isFailed: Bool = false
    /** 记录photoView是否缩放 */
    var isZooming: Bool = false
    var zoomRect: CGRect = CGRect.zero
    var isFirstPhoto: Bool = false
}
