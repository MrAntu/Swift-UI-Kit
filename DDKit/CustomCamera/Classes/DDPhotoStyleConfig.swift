//
//  DDPhotoStyleConfig.swift
//  DDCustomCameraDemo
//
//  Created by weiwei.li on 2019/1/4.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

public class DDPhotoStyleConfig: NSObject {
    public static let shared = DDPhotoStyleConfig()
    
    ///MARK: - UI相关，主要针对e肚仔
    
    public var navigationBackImage: UIImage?
    public var navigationBackgroudColor: UIColor?
    public var navigationTintColor: UIColor?
    public var navigationBarStyle:UIBarStyle = .black
    public var seletedImageCircleColor: UIColor?
    
    public var bottomBarBackgroudColor: UIColor?
    public var bottomBarTintColor: UIColor?
    
    ///MARK: - 基本参数设置
    
    //是否使用DDKit/Hud提示框。主要为了e肚仔项目
    public var isEnableDDKitHud = false
    //最大可选择的图片数量
    public var maxSelectedNumber: Int = 1
    //此属性只能设置从相册选择返回的图片大小。拍照无效
    //选择返回图片size大小，为需要展示的缩略图大小。
    //若默认返回原图，大图片会导致内存问题
    //展示时按需获取图片大小
    //若为上传图片，请调用DDPhotoImageManager.requestOriginalImage方法获取。或者DDCustomCameraManager都有同样的方法调用
    //请至少设置 140 * 140
    public var imageSize:CGSize = CGSize.init(width: 140, height: 140)
    //选择类型
    public var photoAssetType: DDPhotoPickerAssetType = .all {
        didSet {
            if photoAssetType == .imageOnly {
                isEnableRecordVideo = false
            }
        }
    }
    //是否支持录制视屏
    public var isEnableRecordVideo: Bool = true
    //是否支持拍照
    public var isEnableTakePhoto: Bool = true {
        didSet {
            if isEnableRecordVideo == false {
                photoAssetType = .imageOnly
            }
        }
    }
    //最大录制时长
    public var maxRecordDuration: Int = 15
    //拍照选择尺寸
    public var sessionPreset: DDCaptureSessionPreset = .preset1280x720
    //thumbnailSize，录制视屏完成回调需要显示的缩略图，录制视屏时有效。
    //拍照默认返回原图，因为拍摄的照片还需存入相册，无需多操作此步骤
    public var thumbnailSize: CGSize = CGSize(width: 150, height: 150)
    //是否显示截图框
    public var isShowClipperView: Bool = false
    //截图框的大小
    public var clipperSize: CGSize = CGSize(width: 250, height: 400)
    //长按拍摄动画进度条颜色
    public var circleProgressColor: UIColor = UIColor(red: 99.0/255.0, green: 181.0/255.0, blue: 244.0/255.0, alpha: 1)
    
    //MARK: -- 授权提示
    //相册授权
    public var photoPermission = "您没有使用照片的权限\n请在设置->隐私->照片中打开权限"
    //相机授权
    public var cameraPermission = "您没有使用相机的权限\n请在设置->隐私->相机中打开权限"
    //麦克风授权
    public var microphonePermission = "您没有使用麦克风的权限\n请在设置->隐私->麦克风中打开权限"

}
