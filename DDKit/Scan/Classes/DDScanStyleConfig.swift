
//
//  DDScanStyleConfig.swift
//  DDScanDemo
//
//  Created by USER on 2018/11/27.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import AVFoundation

/// 扫码区域动画效果
public enum DDScanViewAnimationStyle: Int {
    case lineMove   //线条上下移动
//    case netGrid    //网格
}

/// 扫码区域4个角位置类型
public enum DDScanViewPhotoframeAngleStyle: Int {
    case inner//内嵌，一般不显示矩形框情况下
    case outer//外嵌,包围在矩形框的4个角
    case on   //在矩形框的4个角上，覆盖
}

public enum DDScanShowStyle: Int {
    case push
    case present
}

public struct DDScanStyleConfig {
    /// MARK --- navigationBar配置相关
    public var navigationBarColor: UIColor? = #colorLiteral(red: 0.2039215686, green: 0.2039215686, blue: 0.2156862745, alpha: 1)
    
    public var navigationBarTintColor: UIColor? = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    public var navigationBarTitle: String? = "扫一扫"
    
    public var navigationBarTitleFont: UIFont? = UIFont.systemFont(ofSize: 18)
    
    public var navigationBarBackImage: UIImage? = DDScanImage.image(for: "scan_close")

    /// MARK --- 界面UI相关
    public var introduceLabelTitle: String = NSLocalizedString("请将条形码/二维码放入框内", comment: "")
    
    public var descLabelTitle: String = NSLocalizedString("若您使用扫码积分功能\n扫码成功后系统将自动赠送积分到您的账户", comment: "")
    
    public var photoBtnTitle: String = NSLocalizedString("相册", comment: "")
    
    public var photoBtnImage: UIImage? = DDScanImage.image(for: "scan_photo")

    public var flashBtnTitle: String = NSLocalizedString("闪光灯", comment: "")
    
    public var flashBtnImage: UIImage? = DDScanImage.image(for: "scan_flash")
    
    /// MARK ---- modal样式
    public var showStyle: DDScanShowStyle = .push
    
    /// MARK ---- 扫码类型支持
    //以下为条形码，如果项目只需要扫描二维码，只需要设置[.qr, .ean13, .code128]
    //类型越多，扫描效率越低
    // [.qr, .ean13, .ean8, .upce, .code39, .code39Mod43, .code93, .code128, .pdf417]
    public var arrayCodeType: [AVMetadataObject.ObjectType] = [.qr, .ean13, .ean8, .upce, .code39, .code39Mod43, .code93, .code128, .pdf417]

    // MARK: - -中心位置矩形框
    
    /// 相机启动时提示的文字信息
    public var readyString: String = ""
    
    /// 是否需要绘制扫码矩形框，默认false
    public var isNeedShowRetangle: Bool = false
    
    ///  默认扫码区域为正方形，如果扫码区域不是正方形，设置宽高比
    public var whRatio: CGFloat = 1.0
    
    ///  矩形框(视频显示透明区)域向上移动偏移量，0表示扫码透明区域在当前视图中心位置，如果负值表示扫码区域下移
    public var centerUpOffset: CGFloat = 44
    
    /// 矩形框(视频显示透明区)域离界面左边及右边距离，默认70
    public var xScanRetangleOffset: CGFloat = 70
    
    /// 矩形框线条颜色，默认白色
    public var colorRetangleLine = UIColor.white
    
    // MARK: -矩形框(扫码区域)周围4个角
    
    ///  扫码区域的4个角类型
    public var photoframeAngleStyle: DDScanViewPhotoframeAngleStyle = .inner
    
    /// 4个角的颜色
    public var colorAngle: UIColor = #colorLiteral(red: 0, green: 0.6666666667, blue: 1, alpha: 1)
    
    /// 扫码区域4个角的宽度和高度
    public var photoframeAngleW: CGFloat = 18
    public var photoframeAngleH: CGFloat = 18
    /// 扫码区域4个角的线条宽度,
    public var photoframeLineW: CGFloat = 2
    
    // MARK: - ---动画效果
    
    /// 扫码动画效果:线条
    public var anmiationStyle: DDScanViewAnimationStyle = .lineMove
    
    /// 动画效果的图像，如线条或网格的图像
    public var animationImage: UIImage? = DDScanImage.image(for: "scan_part_net")
    
    // MARK: - 非识别区域颜色,默认 RGBA (0,0,0,0.5)，范围（0--1）
    public var colorNotRecoginitonArea: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    
    //是否需要返回识别后的当前图像
    public var isNeedCodeImage = false

    
    public init () {
        
    }

}

/// 获取bundle中image
public class DDScanImage: NSObject {
    
   public static func image(for name: String?) -> UIImage? {
        guard let name = name else {
            return nil
        }
    
        if let path = Bundle(for: DDScanImage.classForCoder()).path(forResource: "DDScan", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: name, in: bundle, compatibleWith: nil)
        {
            return image
        }
        
        return nil
    }
}
