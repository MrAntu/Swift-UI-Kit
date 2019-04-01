//
//  DDScanView.swift
//  DDScanDemo
//
//  Created by USER on 2018/11/27.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

public class DDScanView: UIView {
    //扫码区域各种参数
    var viewStyle = DDScanStyleConfig()
    
    //扫码区域
    var scanRetangleRect: CGRect = CGRect.zero

    //线条扫码动画封装
    var scanLineAnimation: DDScanLineAnimation?
    
    //启动相机时 菊花等待
    var activityView: UIActivityIndicatorView?
    
    //启动相机中的提示文字
    var labelReadying: UILabel?
    
    //记录动画状态
    var isAnimationing: Bool = false
    
    public init(frame: CGRect, styleConfig: DDScanStyleConfig?) {
        viewStyle = styleConfig ?? DDScanStyleConfig()
        
        if styleConfig?.anmiationStyle == .lineMove {
            scanLineAnimation = DDScanLineAnimation.instance()
        }
        
        var frameTmp = frame
        frameTmp.origin = CGPoint.zero
        
        super.init(frame: frameTmp)
        backgroundColor = UIColor.clear
    }
    
    public override init(frame: CGRect) {
        var frameTmp = frame
        frameTmp.origin = CGPoint.zero
        super.init(frame: frameTmp)
        backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        drawScanRect()
    }
    
    deinit {
        if scanLineAnimation != nil {
            scanLineAnimation?.stopStepAnimating()
        }
    }
    
}

extension DDScanView {
    
    /// 停止动画
    public func stopScanAnimation() {
        isAnimationing = false
        
        if viewStyle.anmiationStyle == .lineMove {
            scanLineAnimation?.stopStepAnimating()
        }
    
    }
    
    public func startScanAnimation() {
        if isAnimationing == true {
            return
        }
        
        isAnimationing = true
        
        let cropRect: CGRect = getScanRectForAnimation()
        if viewStyle.anmiationStyle == .lineMove {
            scanLineAnimation?.startAnimatingWithRect(animationRect: cropRect, parentView: self, image: viewStyle.animationImage)
        }
    }
    
    func getScanRectForAnimation() -> CGRect{
        let XRetangleLeft = viewStyle.xScanRetangleOffset
        var sizeRetangle = CGSize(width: self.frame.size.width - XRetangleLeft * 2, height: self.frame.size.width - XRetangleLeft * 2)
        
        if viewStyle.whRatio != 1 {
            let w = sizeRetangle.width
            var h = w / viewStyle.whRatio
            
            let hInt: Int = Int(h)
            h = CGFloat(hInt)
            
            sizeRetangle = CGSize(width: w, height: h)
        }
        
        //扫码区域Y轴最小坐标
        let YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height / 2.0 - viewStyle.centerUpOffset
        //扫码区域坐标
        let cropRect =  CGRect(x: XRetangleLeft, y: YMinRetangle, width: sizeRetangle.width, height: sizeRetangle.height)
        
        return cropRect
    }
    
    //根据矩形区域，获取识别区域
    static func getScanRectWithPreView(preView: UIView, style: DDScanStyleConfig?) -> CGRect {
        let XRetangleLeft = style?.xScanRetangleOffset ?? 60.0
        var sizeRetangle = CGSize(width: preView.frame.size.width - XRetangleLeft*2, height: preView.frame.size.width - XRetangleLeft*2)
        
        if style?.whRatio != 1 {
            let w = sizeRetangle.width
            var h = w / (style?.whRatio ?? 1.0)
            
            let hInt: Int = Int(h)
            h = CGFloat(hInt)
            
            sizeRetangle = CGSize(width: w, height: h)
        }
        
        //扫码区域Y轴最小坐标
        let YMinRetangle = preView.frame.size.height / 2.0 - sizeRetangle.height / 2.0 - (style?.centerUpOffset ?? 44.0)
        //扫码区域坐标
        let cropRect =  CGRect(x: XRetangleLeft, y: YMinRetangle, width: sizeRetangle.width, height: sizeRetangle.height)
        
        //计算兴趣区域
        var rectOfInterest: CGRect
        
        let size = preView.bounds.size
        let p1 = size.height/size.width
        
        let p2: CGFloat = 1920.0 / 1080.0 //使用了1080p的图像输出
        if p1 < p2 {
            let fixHeight = size.width * 1920.0 / 1080.0
            let fixPadding = (fixHeight - size.height) / 2
            rectOfInterest = CGRect(x: (cropRect.origin.y + fixPadding)/fixHeight,
                                    y: cropRect.origin.x/size.width,
                                    width: cropRect.size.height/fixHeight,
                                    height: cropRect.size.width/size.width)
            
        } else {
            let fixWidth = size.height * 1080.0 / 1920.0
            let fixPadding = (fixWidth - size.width) / 2
            rectOfInterest = CGRect(x: cropRect.origin.y/size.height,
                                    y: (cropRect.origin.x + fixPadding)/fixWidth,
                                    width: cropRect.size.height/size.height,
                                    height: cropRect.size.width/fixWidth)
        }
        return rectOfInterest
    }
    
    func getRetangeSize() -> CGSize {
        let XRetangleLeft = viewStyle.xScanRetangleOffset
        
        var sizeRetangle = CGSize(width: frame.size.width - XRetangleLeft * 2, height: frame.size.width - XRetangleLeft * 2)
        
        let w = sizeRetangle.width
        var h = w / viewStyle.whRatio
        
        let hInt: Int = Int(h)
        h = CGFloat(hInt)
        
        sizeRetangle = CGSize(width: w, height: h)
        
        return sizeRetangle
    }
    
    func deviceStartReadying(readyStr: String?) {
//        let XRetangleLeft = viewStyle.xScanRetangleOffset
        
        let sizeRetangle = getRetangeSize()
        
        //扫码区域Y轴最小坐标
        let YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height/2.0 - viewStyle.centerUpOffset
        
        //设备启动状态提示
        if (activityView == nil) {
            activityView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            
            activityView?.center = CGPoint(x: UIScreen.main.bounds.width / 2.0, y: YMinRetangle + sizeRetangle.height / 2.0)
            activityView?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            
            addSubview(activityView!)
            
            let labelReadyRect = CGRect(x: activityView?.frame.origin.x ?? 0.0 + (activityView?.frame.width ?? 0.0) + 10, y: activityView?.frame.origin.y ?? 0.0, width: 100, height: 30)
            labelReadying = UILabel(frame: labelReadyRect)
            labelReadying?.text = readyStr
            labelReadying?.backgroundColor = UIColor.clear
            labelReadying?.textColor = UIColor.white
            labelReadying?.font = UIFont.systemFont(ofSize: 18.0)
            addSubview(labelReadying!)
        }
        
        addSubview(labelReadying!)
        activityView?.startAnimating()
    }
    
    func deviceStopReadying() {
        if activityView != nil {
            activityView?.stopAnimating()
            activityView?.removeFromSuperview()
            labelReadying?.removeFromSuperview()
    
            activityView = nil
            labelReadying = nil
        }
    }

    
    // MARK: - ---- 绘制扫码效果-----
    func drawScanRect() {
        let XRetangleLeft = viewStyle.xScanRetangleOffset
        var sizeRetangle = CGSize(width: self.frame.size.width - XRetangleLeft*2.0, height: self.frame.size.width - XRetangleLeft*2.0)
        if viewStyle.whRatio != 1.0 {
            let w = sizeRetangle.width
            var h: CGFloat = w / viewStyle.whRatio
            
            let hInt: Int = Int(h)
            h = CGFloat(hInt)
            
            sizeRetangle = CGSize(width: w, height: h)
        }
        
        //扫码区域Y轴最小坐标
        let YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/2.0 - viewStyle.centerUpOffset
        let YMaxRetangle = YMinRetangle + sizeRetangle.height
        let XRetangleRight = self.frame.size.width - XRetangleLeft

        let context = UIGraphicsGetCurrentContext()!

        //非扫码区域半透明
        //设置非识别区域颜色
        context.setFillColor(viewStyle.colorNotRecoginitonArea.cgColor)
        //填充矩形
        //扫码区域上面填充
        var rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: YMinRetangle)
        context.fill(rect)
        
        //扫码区域左边填充
        rect = CGRect(x: 0, y: YMinRetangle, width: XRetangleLeft, height: sizeRetangle.height)
        context.fill(rect)
        
        //扫码区域右边填充
        rect = CGRect(x: XRetangleRight, y: YMinRetangle, width: XRetangleLeft, height: sizeRetangle.height)
        context.fill(rect)
        
        //扫码区域下面填充
        rect = CGRect(x: 0, y: YMaxRetangle, width: self.frame.size.width, height: self.frame.size.height - YMaxRetangle)
        context.fill(rect)
        //执行绘画
        context.strokePath()
        
        if viewStyle.isNeedShowRetangle {
            //中间画矩形(正方形)
            context.setStrokeColor(viewStyle.colorRetangleLine.cgColor)
            context.setLineWidth(1)
            
            context.addRect(CGRect(x: XRetangleLeft, y: YMinRetangle, width: sizeRetangle.width, height: sizeRetangle.height))
            
            context.strokePath()
            
        }
        scanRetangleRect = CGRect(x: XRetangleLeft, y: YMinRetangle, width: sizeRetangle.width, height: sizeRetangle.height)
        
        //画矩形框4格外围相框角
        
        //相框角的宽度和高度
        let wAngle = viewStyle.photoframeAngleW
        let hAngle = viewStyle.photoframeAngleH
        
        //4个角的 线的宽度
        let linewidthAngle = viewStyle.photoframeLineW;// 经验参数：6和4
        
        //画扫码矩形以及周边半透明黑色坐标参数
        var diffAngle = linewidthAngle/3
        diffAngle = linewidthAngle / 2; //框外面4个角，与框有缝隙
        diffAngle = linewidthAngle/2;  //框4个角 在线上加4个角效果
        diffAngle = 0;//与矩形框重合
        
        switch viewStyle.photoframeAngleStyle {
        case .outer:
            diffAngle = linewidthAngle/3//框外面4个角，与框紧密联系在一起
            
        case .on:
            diffAngle = 0
            
        case .inner:
            diffAngle = -viewStyle.photoframeLineW/2
        }
        
        context.setStrokeColor(viewStyle.colorAngle.cgColor)
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        context.setLineWidth(linewidthAngle)
        
        let leftX = XRetangleLeft - diffAngle
        let topY = YMinRetangle - diffAngle
        let rightX = XRetangleRight + diffAngle
        let bottomY = YMaxRetangle + diffAngle
        
        //左上角水平线
        context.move(to: CGPoint(x: leftX-linewidthAngle/2, y: topY))
        context.addLine(to: CGPoint(x: leftX + wAngle, y: topY))
        
        //左上角垂直线
        context.move(to: CGPoint(x: leftX, y: topY-linewidthAngle/2))
        context.addLine(to: CGPoint(x: leftX, y: topY+hAngle))
        
        //左下角水平线
        context.move(to: CGPoint(x: leftX-linewidthAngle/2, y: bottomY))
        context.addLine(to: CGPoint(x: leftX + wAngle, y: bottomY))
        
        //左下角垂直线
        context.move(to: CGPoint(x: leftX, y: bottomY+linewidthAngle/2))
        context.addLine(to: CGPoint(x: leftX, y: bottomY - hAngle))
        
        //右上角水平线
        context.move(to: CGPoint(x: rightX+linewidthAngle/2, y: topY))
        context.addLine(to: CGPoint(x: rightX - wAngle, y: topY))
        
        //右上角垂直线
        context.move(to: CGPoint(x: rightX, y: topY-linewidthAngle/2))
        context.addLine(to: CGPoint(x: rightX, y: topY + hAngle))
        
        //右下角水平线
        context.move(to: CGPoint(x: rightX+linewidthAngle/2, y: bottomY))
        context.addLine(to: CGPoint(x: rightX - wAngle, y: bottomY))
        
        //右下角垂直线
        context.move(to: CGPoint(x: rightX, y: bottomY+linewidthAngle/2))
        context.addLine(to: CGPoint(x: rightX, y: bottomY - hAngle))
        
        context.strokePath()
    }
    
    
    
}
