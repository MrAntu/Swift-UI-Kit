//
//  DDPhotoPickerManager.swift
//  Photo
//
//  Created by USER on 2018/10/25.
//  Copyright © 2018年 leo. All rights reserved.
//

import UIKit
import Photos
import DDKit
public class DDPhotoPickerManager: NSObject {
    //当前对象是否是从DDCustomCamera present呈现,外界禁止调用禁止设置此值
    var isFromDDCustomCameraPresent: Bool = false
}

// MARK: - 类方法调用
extension DDPhotoPickerManager {
    //入口
    public static func show(finishedHandler:@escaping ([DDPhotoGridCellModel]?)->()) {
        let manager = DDPhotoPickerManager()
        manager.presentImagePickerController(finishedHandler: finishedHandler)
    }
    
    /// 预览选择上传的资源
    ///
    /// - Parameter uploadPhotoSource:  要预览的资源文件
    public static func showUploadBrowserController(uploadPhotoSource: [PHAsset], seletedIndex: Int) {
        let manager = DDPhotoPickerManager()
        manager.showUploadBrowser(uploadPhotoSource: uploadPhotoSource, seletedIndex: seletedIndex)
    }
}

// MARK: - 私有方法
extension DDPhotoPickerManager {
    /// 预览选择上传的资源
    ///
    /// - Parameter uploadPhotoSource:  要预览的资源文件
   public func showUploadBrowser(uploadPhotoSource: [PHAsset], seletedIndex: Int) {
        //遍历创建数据
        let arr = uploadPhotoSource.map({ (asset) -> DDPhotoGridCellModel in
            let type = DDPhotoImageManager.transformAssetType(asset)
            let duratiom = DDPhotoImageManager.getVideoDuration(asset)
            let model = DDPhotoGridCellModel(asset: asset, type: type, duration: duratiom)
            return model
        })
        
        let vc = DDPhotoUploadBrowserController()
        vc.photoArr = arr
        vc.currentIndex = seletedIndex
        if getTopViewController?.navigationController == nil {
            getTopViewController?.present(vc, animated: true, completion: nil)
            return
        }
        getTopViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
   /// 显示图片选择控制器
   ///
   /// - Parameter finishedHandler: 完成回调
   public func presentImagePickerController(finishedHandler:@escaping ([DDPhotoGridCellModel]?)->()) {

        DDCustomCameraManager.authorizePhoto { (res) in
            if res == false {
                DDPhotoPickerManager.showAlert(DDPhotoStyleConfig.shared.photoPermission)
                return
            }
            //类方法不会循环引用，不能设为weak，否则self为空
            self.presentVC(finishedHandler: finishedHandler)
        }
    
    
    }
    
    private func presentVC(finishedHandler:@escaping ([DDPhotoGridCellModel]?)->()) {
        if isHavePhotoLibraryAuthority() == false {
            return
        }
        
        //已经授权通过,获取当前controller
        guard let vc = getTopViewController else {
            print("未获取presentController")
            return
        }
        
        //present picker controller
        let pickerVC = DDPhotoPickerViewController(assetType: DDPhotoStyleConfig.shared.photoAssetType, maxSelectedNumber:  DDPhotoStyleConfig.shared.maxSelectedNumber) {(selectedArr) in
            guard let arr = selectedArr else {
                finishedHandler(nil)
                return
            }
            for cellModel in arr {
                _ = DDPhotoImageManager.default().requestTargetImage(for: cellModel.asset, targetSize: CGSize(width: 150, height: 150), resultHandler: { (image, dic) in
                    cellModel.image = image
                })
            }
            //回调
            finishedHandler(arr)
        }
        //清空gif缓存
        DDPhotoImageManager.default().removeAllCache()
        let nav = DDPhotoPickerNavigationController(rootViewController: pickerVC)
        nav.previousStatusBarStyle = UIApplication.shared.statusBarStyle
        pickerVC.isFromDDCustomCameraPresent = isFromDDCustomCameraPresent
        pickerVC.isEnableRecordVideo = DDPhotoStyleConfig.shared.isEnableRecordVideo
        pickerVC.isEnableTakePhoto = DDPhotoStyleConfig.shared.isEnableTakePhoto
        pickerVC.maxSelectedNumber = DDPhotoStyleConfig.shared.maxSelectedNumber
        pickerVC.maxRecordDuration = DDPhotoStyleConfig.shared.maxRecordDuration
        pickerVC.isShowClipperView = DDPhotoStyleConfig.shared.isShowClipperView
        vc.present(nav, animated: true, completion: nil)
    }
    
    static func showAlert(_ content: String) {
        if DDPhotoStyleConfig.shared.isEnableDDKitHud == false {
            //弹窗提示
            let alertVC = UIAlertController(title: "温馨提示", message: content, preferredStyle: .alert)
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
            TopViewController().getTopViewController?.present(alertVC, animated: true, completion: nil)

        } else {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            let info = AlertInfo(title: Bundle.localizedString("温馨提示"),
                                 subTitle: nil,
                                 needInput: nil,
                                 cancel: Bundle.localizedString("取消"),
                                 sure: Bundle.localizedString("去设置"),
                                 content: content,
                                 targetView: window)
            Alert.shared.show(info: info) { (tag) in
                if tag == 0 {
                    return
                }
                //去设置
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}

private extension DDPhotoPickerManager {
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
}
