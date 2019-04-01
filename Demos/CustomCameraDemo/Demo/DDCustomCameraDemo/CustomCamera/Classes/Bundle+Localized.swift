//
//  Bundle+Localized.swift
//  DDCustomCameraDemo
//
//  Created by weiwei.li on 2019/1/4.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

extension Bundle {
    
    public static func localizedString(_ key: String, value: String? = nil) -> String {
        let language = getLanguageFromSystem()
        let bundlePath = getBundle().path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: bundlePath ?? "")
        let newValue = bundle?.localizedString(forKey: key, value: value, table: nil)
        let result = Bundle.main.localizedString(forKey: key, value: newValue, table: nil)
        return result
    }
    
    fileprivate static func getBundle() -> Bundle {
        if let path = Bundle(for: DDPhotoPickerManager.classForCoder()).path(forResource: "DDPhotoPicker", ofType: "bundle"),
            let bundle = Bundle(path: path)
        {
            return bundle
        }
        return  Bundle.main
    }
    
    fileprivate static func getLanguageFromSystem() -> String {
        var language = Locale.preferredLanguages.first as NSString?
        if language?.hasPrefix("en") == true {
            language = "en"
        } else if language?.hasPrefix("zh") == true {
            if language?.range(of: "Hans").location != NSNotFound {
                language = "zh-Hans"; // 简体中文
            } else {
                language = "zh-Hant"; // 繁體中文
            }
        } else {
            language = "zh-Hans"
        }
        return (language as String?) ?? "zh-Hans"
    }
}
