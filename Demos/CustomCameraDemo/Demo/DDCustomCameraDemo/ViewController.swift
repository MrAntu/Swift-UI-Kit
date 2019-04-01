//
//  ViewController.swift
//  DDCustomCameraDemo
//
//  Created by USER on 2018/12/4.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import Photos
import DDKit
class ViewController: UIViewController {
    var  manager = DDCustomCameraManager()

    //demo只提供显示第一张的imageview
    @IBOutlet weak var photoView: UIImageView!
    
    //demo只提供显示第一张的imageview
    @IBOutlet weak var albumView: UIImageView!
    
    //相册回调结果接受
    var albumArr:[DDPhotoGridCellModel]?
    
    //拍照结果回调
    var takePhotoArr: [DDCustomCameraResult]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let file = FileManager.default
        let subPathArr = try? file.contentsOfDirectory(atPath: NSTemporaryDirectory())
        for subPath in (subPathArr ?? []) {
            print(subPath)
        }
        DDCustomCameraManager.cleanMoviesFile()
        photoView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        photoView.addGestureRecognizer(tap)
        
        albumView.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(albumImageTapAction))
        albumView.addGestureRecognizer(tap2)
        
            
        // DDPhotoStyleConfig初始化实际项目中，可丢到AppDelegate中初始化
        //UI方面的配置主要是针对e肚仔
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
        
        
        
//        DDPhotoStyleConfig.shared.photoAssetType = .imageOnly
        //若你的第一级入口为选择照片，那个在相册中的进入拍照时，是否允许摄像
//        DDPhotoStyleConfig.shared.isEnableRecordVideo = false
        DDPhotoStyleConfig.shared.maxSelectedNumber = 9
    }
    
    @objc func tapAction() {
        guard let arr = takePhotoArr else {
            return
        }
        //获取所有的asset数组
        var assetArr = [PHAsset]()
        for model in arr {
            if let asset = model.asset {
                assetArr.append(asset)
            }
        
        }
        if assetArr.count > 0 {
            DDPhotoPickerManager.showUploadBrowserController(uploadPhotoSource: assetArr, seletedIndex: 0)
        }
    }
    
    @objc func albumImageTapAction() {
        //获取所有的asset数组
        let assetArr = albumArr?.map({ (cellModel) -> PHAsset in
            return cellModel.asset
        })
        guard let arr = assetArr else {
            return
        }
        DDPhotoPickerManager.showUploadBrowserController(uploadPhotoSource: arr, seletedIndex: 0)
    }
    
    @IBAction func albumAction(_ sender: Any) {
        DDPhotoPickerManager.show {[weak self] (resultArr) in
            guard let arr = resultArr else {
                return
            }
            let model = resultArr?.first
            self?.albumView.image = model?.image
            self?.albumArr = arr
        }
    }
    
    @IBAction func takePicAction(_ sender: Any) {
        //请勿使用weak ，否则会被释放，获取不到回调,类方法block无需担心循环引用
        DDCustomCameraManager.show { (arr) in

            self.photoView.image = arr?.first?.image
            self.getPath(asset: arr?.first?.asset)
            self.takePhotoArr = arr
        }
    }
    
    /// 上传视屏压缩时，导出的filePath，图片不需要调用
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
    
}

