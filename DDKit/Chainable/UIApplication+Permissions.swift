
//
//  UIApplication+Permissions.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/18.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

extension UIApplication {
    // MARK: - ---获取相册权限
    static func authorizePhoto(_ comletion:@escaping (Bool) -> Void) {
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case PHAuthorizationStatus.authorized:
            comletion(true)
        case PHAuthorizationStatus.denied, PHAuthorizationStatus.restricted:
            comletion(false)
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    comletion(status == .authorized ? true:false)
                }
            })
        }
    }
    
    // MARK: - --相机权限
    static func authorizeCamera(_ comletion: @escaping (Bool) -> Void ) {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch granted {
        case AVAuthorizationStatus.authorized:
            comletion(true)
        case AVAuthorizationStatus.denied:
            comletion(false)
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
    
    // MARK: - --麦克风授权
    static func authorizeMicrophone(_ comletion: @escaping (Bool) -> Void ) {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        switch granted {
        case AVAuthorizationStatus.authorized:
            comletion(true)
        case AVAuthorizationStatus.denied:
            comletion(false)
        case AVAuthorizationStatus.restricted:
            comletion(false)
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    if granted {
                        comletion(granted)
                    }
                }
            })
        }
    }
    
    /// 是否有相册访问权限
    ///
    /// - Returns: bool
   static func isHaveAuthorizePhoto() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            return true
        }
        return false
    }
    
    /// 是否有相册访问权限
    ///
    /// - Returns: bool
    static func isHaveAuthorizeMicrophone() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        if status == .authorized {
            return true
        }
        return false
    }
    
    /// 是否有相册访问权限
    ///
    /// - Returns: bool
    static func isHaveAuthorizeCamera() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if status == .authorized {
            return true
        }
        return false
    }
}
