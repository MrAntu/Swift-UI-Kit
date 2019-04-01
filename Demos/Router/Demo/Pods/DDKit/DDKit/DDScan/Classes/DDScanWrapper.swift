//
//  DDScanWrapper.swift
//  DDScanDemo
//
//  Created by USER on 2018/11/28.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import AVFoundation

public struct DDScanResult {
    //码内容
    public var strScanned: String? = ""
    //扫描图像
    public var imgScanned: UIImage?
    //码的类型
    public var strBarCodeType: String? = ""

    //码在图像中的位置
    public var arrayCorner: [AnyObject]?
    
    public init(str: String?, barCodeType: String?, corner: [AnyObject]?) {
        self.strScanned = str
        self.strBarCodeType = barCodeType
        self.arrayCorner = corner
    }
}

public class DDScanWrapper: NSObject {
    
    var device: AVCaptureDevice?
    
    var input: AVCaptureDeviceInput?
    
    var output: AVCaptureMetadataOutput?
    
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var stillImageOutput: AVCaptureStillImageOutput?
    
    //存储返回结果
    var arrayResult: [DDScanResult] = []
    
    //扫码结果返回block
    var successBlock: ([DDScanResult]?) -> Void

    //是否需要拍照
    var isNeedCaptureImage: Bool = false
    
    //当前扫码结果是否处理
    var isNeedScanResult: Bool = true
    
    
    ///      初始化设备
    ///
    /// - Parameters:
    ///   - videoPreView: 视频显示view
    ///   - type: 识别码的类型，
    ///   - isCaptureImage: 识别后是否采集当前照片
    ///   - cropRect: 识别区域
    ///   - complete: 返回的识别信息
    public init(videoPreView: UIView, types: [AVMetadataObject.ObjectType] = [.qr], isCaptureImage: Bool, cropRect: CGRect = CGRect.zero, complete: @escaping (([DDScanResult]?) -> Void)) {

        self.device = AVCaptureDevice.default(for: .video)
        successBlock = complete
        
        super.init()

        guard let device = self.device  else {
            return
        }
        
        input = try? AVCaptureDeviceInput(device: device)
        
        output = AVCaptureMetadataOutput()
        isNeedCaptureImage = isCaptureImage
        stillImageOutput = AVCaptureStillImageOutput()
        
        
        guard let input = self.input,
            let output = self.output,
            let stillImageOutput = self.stillImageOutput else {
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        if session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
        }
        
        
        let outputSettings: Dictionary = [AVVideoCodecJPEG : AVVideoCodecKey]
        stillImageOutput.outputSettings = outputSettings
        
        session.sessionPreset = .high
        
        //参数设置
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = types
        
        
        if cropRect.equalTo(CGRect.zero) == false {
            //启动相机后，直接修改该参数无效
            output.rectOfInterest = cropRect
        }
    
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = .resizeAspectFill
        
        var frame = videoPreView.frame
        frame.origin = CGPoint.zero
        previewLayer?.frame = frame
        
        if let previewLayer = self.previewLayer  {
            videoPreView.layer.insertSublayer(previewLayer, at: 0)
        }
        
        if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.continuousAutoFocus) {
            try? input.device.lockForConfiguration()
            
            input.device.focusMode = .continuousAutoFocus
            
            input.device.unlockForConfiguration()
        }
    }
    
    public func captureOutput(_ captureOutput: AVCaptureOutput, didOutputMetadataObjects metadataObjects: [Any], from connection: AVCaptureConnection) {
        
        if isNeedScanResult == false {
            return
        }
        
        isNeedScanResult = false
        
        arrayResult.removeAll()
        
        //识别码类型
        for current in metadataObjects {
            if (current as AnyObject).isKind(of: AVMetadataMachineReadableCodeObject.self) {
                let code = current as! AVMetadataMachineReadableCodeObject
                //码类型
                let codeType = code.type
                //码内容
                let codeContent = code.stringValue
                
                let result = DDScanResult(str: codeContent, barCodeType: codeType.rawValue, corner: code.corners as [AnyObject])
                
                arrayResult.append(result)
            }
        }
        
        if arrayResult.count > 0 {
            if isNeedCaptureImage == true {
                captureImage()
            } else {
                stop()
                successBlock(arrayResult)
            }
        } else {
            isNeedScanResult = true
        }
    }
    
    public func captureImage() {
        guard let connections = stillImageOutput?.connections else {
            return
        }
       
        guard let stillImageConnection = connectionWithMediaType(mediaType: .video, connections: connections) else {
            return
        }
        
        stillImageOutput?.captureStillImageAsynchronously(from: stillImageConnection, completionHandler: {[weak self] ( buffer, error) in
            self?.stop()
            
            guard let buffer = buffer,
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer),
                var arr = self?.arrayResult else {
                self?.successBlock(self?.arrayResult)
                return
            }
            
            let scanImage =  UIImage(data: imageData)
            
            for idx in 0...arr.count-1 {
                arr[idx].imgScanned = scanImage
            }
            self?.successBlock(self?.arrayResult)
           
        })
        
    }
    
    public func connectionWithMediaType(mediaType: AVMediaType, connections: [AnyObject]) -> AVCaptureConnection? {
        for connection in connections {
            let tmp = connection as! AVCaptureConnection
            
            for port in tmp.inputPorts {
                if (port as AnyObject).isKind(of: AVCaptureInput.Port.self) {
                    let portTmp = port
                    if portTmp.mediaType == mediaType {
                        return tmp
                    }
                }
            }
        }
        
        return nil
    }
    
    
    /// 开始摄像头会话
    public func start() {
        if session.isRunning == false {
            isNeedScanResult = true
            session.startRunning()
        }
    }
    
    /// 停止摄像头
    public func stop() {
        if session.isRunning == true {
            isNeedScanResult = false
            session.stopRunning()
        }
    }
    
    /// 操作闪光灯，打开&关闭
    public func openFlashlight() {
        if isFlashValid() == false {
            return
        }
        
        do {
            try input?.device.lockForConfiguration()
            var torch = false
            
            if input?.device.torchMode == .on {
                torch = false
            } else if input?.device.torchMode == .off {
                torch = true
            }
            
            input?.device.torchMode = torch ? .on : .off
            input?.device.unlockForConfiguration()
        } catch {
            print("lockForConfiguration -- error")
        }
    }
    
    /// 闪光灯是否有效
    ///
    /// - Returns: bool
    public func isFlashValid() -> Bool {
        if (device?.hasFlash == true) && (device?.hasTorch == true) {
            return true
        }
        return false
    }

    /// 识别二维码图像
    ///
    /// - Parameter image: image
    static public func recognizeQRImage(_ image: UIImage) -> [DDScanResult]? {
        var returnResult: [DDScanResult] = []

        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        guard let cgImage = image.cgImage else {
            return returnResult
        }
        
        let img = CIImage(cgImage: cgImage)
        
        guard let features = detector?.features(in: img, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else {
            return returnResult
        }
        
        if features.count <= 0 {
            return returnResult
        }
        
        let feature = features.first
        if feature?.isKind(of: CIQRCodeFeature.self) == true {
            let featureTmp = feature as! CIQRCodeFeature
            let result = DDScanResult(str: featureTmp.messageString, barCodeType: AVMetadataObject.ObjectType.qr.rawValue, corner: nil)
            returnResult.append(result)
        }
        
        return returnResult
    }
    
    /// 生成二维码
    ///
    /// - Parameters:
    ///   - codeType: 类型
    ///   - codeString: 内容
    ///   - size:
    ///   - qrColor: 二维码填充颜色
    ///   - backgroudColor: 背景颜色
    /// - Returns: image
    static public func createQrCode(codeString: String, size: CGSize, qrColor: UIColor, backgroudColor: UIColor ) -> UIImage? {
        let stringData = codeString.data(using: .utf8)
        //系统自带能生成的码
        //        CIAztecCodeGenerator
        //        CICode128BarcodeGenerator
        //        CIPDF417BarcodeGenerator
        //        CIQRCodeGenerator
        
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        qrFilter.setValue(stringData, forKey: "inputMessage")
        qrFilter.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let outputImage = qrFilter.outputImage else {
            return nil
        }
    
        //上色
        let colorFilter = CIFilter(name: "CIFalseColor", withInputParameters: ["inputImage": outputImage, "inputColor0": CIColor(cgColor: qrColor.cgColor), "inputColor1": CIColor(cgColor: backgroudColor.cgColor)])
        
        guard let qrImage = colorFilter?.outputImage,
            let cgImage = CIContext().createCGImage(qrImage, from: qrImage.extent)  else {
            return nil
        }
        
        //绘制
        var codeImage: UIImage?
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            context.interpolationQuality = .none
            context.scaleBy(x: 1.0, y: -1.0)
            context.draw(cgImage, in: context.boundingBoxOfClipPath)
            codeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return codeImage
    }
    
    /// 生成条形码
    ///
    /// - Parameters:
    ///   - codeString: 条形码内容
    ///   - size: size
    ///   - qrColor: 填充颜色
    ///   - bkColor: 背景颜色
    /// - Returns: image
    static public func createCode128(codeString: String, size: CGSize, qrColor: UIColor, backgroudColor: UIColor ) -> UIImage? {
        let stringData = codeString.data(using: .utf8)
        //系统自带能生成的码
        //        CIAztecCodeGenerator
        //        CICode128BarcodeGenerator
        //        CIPDF417BarcodeGenerator
        //        CIQRCodeGenerator
        guard let qrFilter = CIFilter(name: "CICode128BarcodeGenerator") else {
            return nil
        }
        qrFilter.setDefaults()
        qrFilter.setValue(stringData, forKey: "inputMessage")
        
        guard let outputImage = qrFilter.outputImage else {
            return nil
        }
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        let image = UIImage(cgImage: cgImage, scale: 1.0, orientation: .up)
        let scaleRate: CGFloat = 20.0
        let resized = resizeImage(image: image, quality: CGInterpolationQuality.none, rate: scaleRate)
        return resized
    }
    
    //图像缩放
    static func resizeImage(image: UIImage, quality: CGInterpolationQuality, rate: CGFloat) -> UIImage? {
        var resized: UIImage?
        let width    = image.size.width * rate
        let height   = image.size.height * rate
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        let context = UIGraphicsGetCurrentContext()
        context!.interpolationQuality = quality
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        
        resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resized
    }
}

extension DDScanWrapper: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureOutput(output, didOutputMetadataObjects: metadataObjects, from: connection)
    }
}
