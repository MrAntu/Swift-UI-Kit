//
//  DDScanPermissions.swift
//  DDScanDemo
//
//  Created by USER on 2018/11/27.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary
import AVFoundation

public class DDScanPermissions: NSObject {
    // MARK: - ---获取相册权限
    static func authorizePhoto(_ comletion:@escaping (Bool) -> Void) {
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case PHAuthorizationStatus.authorized:
            comletion(true)
        case PHAuthorizationStatus.denied, PHAuthorizationStatus.restricted:
            comletion(false)
            self.showAlertNoAuthority(NSLocalizedString("请在iPhone的\"设置-隐私-照片\"选项中，允许访问您的照片", comment: ""))
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    comletion(status == .authorized ? true:false)
                }
            })
        }
    }
    // MARK: - --相机权限
   public static func authorizeCamera(_ comletion: @escaping (Bool) -> Void ) {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch granted {
        case AVAuthorizationStatus.authorized:
            comletion(true)
        case AVAuthorizationStatus.denied:
            comletion(false)
            self.showAlertNoAuthority(NSLocalizedString("请在iPhone的\"设置-隐私-相机\"选项中，允许访问您的相机", comment: ""))
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
    
    /// 显示无授权信息
    ///
    /// - Parameter text: 标题
   static func showAlertNoAuthority(_ text: String?) {
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
        
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            rootVC.present(alertVC, animated: true, completion: nil)
        }
    }
}
