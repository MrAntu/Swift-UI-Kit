
//
//  DDVideoPlayerConfig.swift
//  Example
//
//  Created by USER on 2018/10/29.
//  Copyright © 2018年 dd01. All rights reserved.
//

import Foundation
import UIKit
/// 导航条高度（不包含状态栏高度）默认44
public let DDPVPNavigationHeight: CGFloat = 44

public let DDVPScreenWidth: CGFloat = UIScreen.main.bounds.size.width
public let DDVPScreenHeight: CGFloat = UIScreen.main.bounds.size.height

//let DDVPIsiPhoneX: Bool = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) && UIScreen.main.currentMode!.size == CGSize(width: 1125, height: 2436)
//#define IsiPhoneXSMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
public let DDVPStatusBarHeight: CGFloat = DDVPIsiPhoneX.isIphonex() ? 44 : 20
public let DDVPNavigationTotalHeight: CGFloat = DDVPStatusBarHeight + DDPVPNavigationHeight
public let DDVPHomeBarHeight: CGFloat = DDVPIsiPhoneX.isIphonex() ? 34 : 0

public class DDVPIsiPhoneX {
    static public func isIphonex() -> Bool {
        
        var isIphonex = false
        if UIDevice.current.userInterfaceIdiom != .phone {
            return isIphonex
        }
        
        if #available(iOS 11.0, *) {
            /// 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X。
            let mainWindow = UIApplication.shared.keyWindow
            if mainWindow?.safeAreaInsets.bottom ?? CGFloat(0.0) > CGFloat(0.0) {
                isIphonex = true
            }
        }
        return isIphonex
    }
}
