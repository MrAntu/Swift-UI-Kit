# DDCustomCamera

[demo地址](https://github.com/weiweilidd01/DDCustomCameraDemo)

####  DDCustomCamera和DDPhotoPicker合成一个组件DDCustomCamera


#### 1.前期初始化
1.请在info.plist中添加相册，照片，麦克风授权权限

2.DDPhotoStyleConfig配置对象，为单列
基本使用样例
```
//      DDPhotoStyleConfig UI配置针对于e肚仔项目，其他项目无特殊需求不必关心
//      DDPhotoStyleConfig初始化实际项目中，可丢到AppDelegate中初始化
//        if let path = Bundle(for: DDPhotoPickerViewController.classForCoder()).path(forResource: "DDPhotoPicker", ofType: "bundle"),
//            let bundle = Bundle(path: path),
//            let image = UIImage(named: "photo_nav_icon_back_black", in: bundle, compatibleWith: nil)
//        {
//          DDPhotoStyleConfig.shared.navigationBackImage = image
//        }
//        DDPhotoStyleConfig.shared.navigationBackgroudColor = UIColor.white
//        DDPhotoStyleConfig.shared.navigationTintColor = UIColor.black
//        DDPhotoStyleConfig.shared.navigationBarStyle = .default
//
//        DDPhotoStyleConfig.shared.seletedImageCircleColor = UIColor.red
//        DDPhotoStyleConfig.shared.bottomBarBackgroudColor = UIColor.white
//        DDPhotoStyleConfig.shared.bottomBarTintColor = UIColor.red
        
        DDPhotoStyleConfig.shared.photoAssetType = .imageOnly
        //若你的第一级入口为选择照片，那个在相册中的进入拍照时，是否允许摄像
        DDPhotoStyleConfig.shared.isEnableRecordVideo = false
        DDPhotoStyleConfig.shared.maxSelectedNumber = 9
```

#### 2.基本调用
1.相册调用
```
   DDPhotoPickerManager.show {[weak self] (resultArr) in
   }
```
2.拍照调用
```
  DDCustomCameraManager.show { (resultArr) in
  }
```

#### 2.相册返回数组模型 DDPhotoGridCellModel
```
    //资源对象
    public var asset: PHAsset
    //缩略图 -- 若为视屏，则返回视屏首张图片
    public var image: UIImage?
    //视屏时长
    public var duration: String = ""
    //当前资源类型
    public var type: DDAssetMediaType?
```
#### 3.拍照完成回调DDCustomCameraResult

```
    //资源对象
    public var asset: PHAsset?
    public var isVideo: Bool? //fale: 为图片， true为视屏
    //图片 -- 若为视屏，则返回视屏首张图片
    public var image: UIImage?
    //时长
    public var duration: String?
```

#### 4.若要上传视屏，获取对应的filePath

```
    /// 上传视屏时，导出的filePath，图片不需要调用
    ///
    /// - Parameter asset: asset 
    func getPath(asset: PHAsset?) {
        
        if asset?.mediaType != .video {
            return
        }
        
        //presetName 参数主要使用一下三个
        //AVAssetExportPresetLowQuality
        //AVAssetExportPresetMediumQuality
        //AVAssetExportPresetHighestQuality
        DDCustomCameraManager.exportVideoFilePath(for: asset, type: .mp4, presetName: AVAssetExportPresetMediumQuality) { (path, err) in
            //path默认存储在沙盒的tmp目录下
            print(path)
        }
        
        //清除存储在tmp目录下的文件。需要就调用
        DDCustomCameraManager.cleanMoviesFile()
    }
```

#### 5.DDCustomCameraManager和DDPhotoImageManager提供操作asset方法，两者方法大体类似，都能调用

```
    /// 获取图片
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - targetSize: 获取图片的size（用于展示实际所需大小）
    ///   - resultHandler: 回调
    /// - Returns: id
    static public func requestImageForAsset(for asset: PHAsset?, targetSize: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID 
    
        
    /// 获取原始图片的data（用于上传）
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - resultHandler: 回调
    /// - Returns: id
    static public func requestOriginalImageDataForAsset(for asset: PHAsset?, resultHandler: @escaping (Data?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID 
    
    
    /// 获取相册视屏播放的item
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - resultHandler: 回调
    /// - Returns: id
    static public func requestVideoForAsset(for asset: PHAsset?, resultHandler: @escaping (AVPlayerItem?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID 


 /// 获取视屏的avasset
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - resultHandler: 回调
    /// - Returns: id
    static public func requestAVAssetForAsset(for asset: PHAsset?, resultHandler: @escaping (AVAsset?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID
    
    
    /// 导出视屏上传临时存储的filePath
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - type: 导出格式
    ///   - presetName: 压缩格式 ，常见的为以下三种
            //AVAssetExp
            ortPresetLowQuality
            //AVAssetExportPresetMediumQuality
            //AVAssetExportPresetHighestQuality
    ///   - compelete: 完成回调
    static public func exportVideoFilePath(for asset: PHAsset?, type: DDExportVideoType, presetName: String, compelete:((String?, NSError?)->())?)
```

#### 5.具体使用，请参照[demo地址](https://github.com/weiweilidd01/DDCustomCameraDemo)
