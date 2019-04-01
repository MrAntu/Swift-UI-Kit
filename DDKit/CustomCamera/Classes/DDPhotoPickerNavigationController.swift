


//
//  DDPhotoPickerNavigationController.swift
//  Photo
//
//  Created by USER on 2018/11/13.
//  Copyright © 2018 leo. All rights reserved.
//

import UIKit

class DDPhotoPickerNavigationController: UINavigationController {
    
    public var previousStatusBarStyle: UIStatusBarStyle = .default
    public var barTintColor: UIColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1) {
        didSet {
            navigationBar.tintColor = barTintColor
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: barTintColor]
        }
    }
    public var barColor: UIColor = UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1) {
        didSet {
            navigationBar.setBackgroundImage(imageWithColor(barColor), for: .default)
        }
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.barStyle = DDPhotoStyleConfig.shared.navigationBarStyle
        navigationBar.isTranslucent = true
        
        if let color = DDPhotoStyleConfig.shared.navigationBackgroudColor {
            navigationBar.setBackgroundImage(imageWithColor(color), for: .default)
        } else {
            navigationBar.setBackgroundImage(imageWithColor(barColor), for: .default)
        }
        
        if let color = DDPhotoStyleConfig.shared.navigationTintColor {
            navigationBar.tintColor = color
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        } else {
            navigationBar.tintColor = barTintColor
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: barTintColor]
        }
        
        if let image = DDPhotoStyleConfig.shared.navigationBackImage {
            navigationBar.backIndicatorImage = image
            navigationBar.backIndicatorTransitionMaskImage = image
        } else {
            if let path = Bundle(for: DDPhotoPickerNavigationController.classForCoder()).path(forResource: "DDPhotoPicker", ofType: "bundle"),
                let bundle = Bundle(path: path),
                let image = UIImage(named: "photo_nav_icon_back_black", in: bundle, compatibleWith: nil)
            {
                navigationBar.backIndicatorImage = image
                navigationBar.backIndicatorTransitionMaskImage = image
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = previousStatusBarStyle
    }
    
    private func imageWithColor(_ color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }
    

    /// 禁止所有的屏幕旋转
//    override var shouldAutorotate: Bool {
//        return false
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
//
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        return .portrait
//    }


}
