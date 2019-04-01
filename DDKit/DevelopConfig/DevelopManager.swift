//
//  DevelopManager.swift
//  Hotel
//
//  Created by senyuhao on 2018/12/3.
//  Copyright © 2018 HK01. All rights reserved.
//

import UIKit
import AFNetworking

// MARK: - TypeDefine

public typealias handleCloser = () -> ()
public typealias netListenerCloser = (_ status: DDNetworkReachabilityStatus) -> ()

public enum DDNetworkReachabilityStatus: Int {
    case unknown            = 0
    case notReachable
    case reachableViaWWAN
    case reachableViaWiFi
}


// MARK: - API

extension DevelopManager {
    
    /// 注册 Host 到 DevelopManager 中
    ///
    /// - Parameters:
    ///   - environments: hosts，键值对形式，key：host 说明，value：host 值
    ///   - notificationName: 通知名字，默认为 DevelopmentsNotification
    public class func registerHost(environments: [String: String], notificationName: String = "DevelopConfigSettingNotification") {
        DevelopManager.shared.registerHost(environments: environments, notificationName: notificationName)
    }
    
    /// 显示Host设置界面
    ///
    /// - Parameters:
    ///   - currentHost: 当前Host
    ///   - settinghandle: 设置回调，设置完成后会使用 UserDefaults 保存，key为：DD-Environment-Host
    public class func showSettingsVC(currentHost: String, settinghandle: handleCloser?) {
        DevelopManager.shared.currentHost = currentHost
        DevelopManager.shared.changeHostHandle = settinghandle
        DevelopManager.shared.showDeveloperSettingsVC()
    }
    
    /// 开启网络监听
    ///
    /// - Parameter listener: 网络状态回调
    public class func startNetworkMonitoring(listener: netListenerCloser?) {
        DevelopManager.shared.networkMonitor(listener)
    }
    
    
    /// 关闭网络监听
    public class func stopNetworkMonitoring() {
        DevelopManager.shared.stopNetworkMonitoring()
    }
}

// MARK: - Class

public class DevelopManager: NSObject {

    static let shared = DevelopManager()
    var hostInfos = [String: String]()
    var notificationN = ""
    var currentHost = ""
    var changeHostHandle: handleCloser?

    func registerHost(environments: [String: String], notificationName: String) {
        hostInfos = environments
        notificationN = notificationName
    }

    func showDeveloperSettingsVC() {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            let nav = UINavigationController(rootViewController: DevelopSettingVC(style: .grouped))
            rootVC.present(nav, animated: true, completion: nil)
        }
    }
}

// MARK: - NetworkMonitor

extension DevelopManager {
    
    private func networkMonitor(_ listener: netListenerCloser?) {
        /*
         typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
             AFNetworkReachabilityStatusUnknown          = -1,
             AFNetworkReachabilityStatusNotReachable     = 0,
             AFNetworkReachabilityStatusReachableViaWWAN = 1,
             AFNetworkReachabilityStatusReachableViaWiFi = 2,
         };
         */
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { [weak self] (netStatus) in
            print("DevelopManager networkMonitor：\(self?.netStatusString(netStatus) ?? "")")
            var currentStatus: DDNetworkReachabilityStatus = .unknown
            switch netStatus {
                case .unknown:
                    currentStatus = .unknown
                break
                case .notReachable:
                    currentStatus = .notReachable
                break
                case .reachableViaWWAN:
                    currentStatus = .reachableViaWWAN
                break
                case .reachableViaWiFi:
                    currentStatus = .unknown
                break
            }
            
            listener?(currentStatus)
        }
        
        AFNetworkReachabilityManager.shared().startMonitoring()
    }
    
    private func stopNetworkMonitoring() {
        AFNetworkReachabilityManager.shared().stopMonitoring()
    }
    
    private func netStatusString(_ status: AFNetworkReachabilityStatus) -> String {
        switch status {
            case .unknown:
                return "unknown"
            case .notReachable:
                return "notReachable"
            case .reachableViaWWAN:
                return "reachableViaWWAN"
            case .reachableViaWiFi:
                return "reachableViaWiFi"
        }
    }
}
