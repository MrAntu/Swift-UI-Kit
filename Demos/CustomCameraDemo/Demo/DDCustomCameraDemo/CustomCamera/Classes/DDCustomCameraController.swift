
//
//  DDCustomCameraController.swift
//  DDCustomCamera
//
//  Created by USER on 2018/11/15.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import CoreMotion

let kViewWidth: CGFloat = UIScreen.main.bounds.size.width
let kViewHeight: CGFloat = UIScreen.main.bounds.size.height
let DDSafeAreaBottom: CGFloat = DDCustomCameraIsiPhoneX.isIphonex() ? 34 : 0

class DDCustomCameraIsiPhoneX {
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


class DDCustomCameraController: UIViewController {

    //是否允许录制视频
    public var isEnableRecordVideo: Bool? = true
    
    //是否允许拍照
    public var isEnableTakePhoto: Bool? = true
    
    //最大录制时长
    public var maxRecordDuration: Int = 15
    
    //长按拍摄动画进度条颜色
    public var circleProgressColor: UIColor = UIColor(red: 99.0/255.0, green: 181.0/255.0, blue: 244.0/255.0, alpha: 1)
    
    //选择尺寸
    public var sessionPreset:DDCaptureSessionPreset = .preset1280x720
    //拍照回调
    public var doneBlock: ((UIImage?, URL?)->())?
    //从相册选择图片回调
    public var selectedAlbumBlock: (([DDPhotoGridCellModel]?)->())?
    //是否获取限制区域中的图片
    public var isShowClipperView: Bool?
    //限制区域的大小
    public var clipperSize: CGSize?
    //当前对象是否是从DDPhotoPicke present呈现,外界调用请勿修改此参数
    public var isFromDDPhotoPickerPresent: Bool = false
    //选择相册类型
    public var photoAssetType: DDPhotoPickerAssetType = .all
    //会话
    private lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        return session
    }()
    
    private lazy var motionManager: CMMotionManager? = {
        let motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 0.5
        return motionManager
    }()

    /// 切换前后摄像头
    private lazy var toggleCameraBtn: UIButton = {
        let toggleCameraBtn = UIButton(type: .custom)
        if let path = Bundle(for: DDCustomCameraController.classForCoder()).path(forResource: "DDCustomCamera", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let toggleImage = UIImage(named: "photographyOverturn", in: bundle, compatibleWith: nil)
        {
            toggleCameraBtn.setImage(toggleImage, for: .normal)
        }
        
        toggleCameraBtn.addTarget(self, action: #selector(btnToggleCameraAction), for: .touchUpInside)
        return toggleCameraBtn
    }()
    
    /// 切换前后摄像头
    private lazy var flashlightBtn: UIButton = {
        let flashlightBtn = UIButton(type: .custom)
        if let path = Bundle(for: DDCustomCameraController.classForCoder()).path(forResource: "DDCustomCamera", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "photographyFlash", in: bundle, compatibleWith: nil)
        {
            flashlightBtn.setImage(image, for: .normal)
        }
        
        flashlightBtn.addTarget(self, action: #selector(flashlightBtnAction), for: .touchUpInside)
        return flashlightBtn
    }()
    
    //关闭按钮
    private lazy var closeBtn: UIButton = {
        let closeBtn = UIButton(type: .custom)
        if let path = Bundle(for: DDCustomCameraController.classForCoder()).path(forResource: "DDCustomCamera", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let toggleImage = UIImage(named: "arrow", in: bundle, compatibleWith: nil)
        {
            closeBtn.setImage(toggleImage, for: .normal)
        }
        closeBtn.addTarget(self, action: #selector(colseBtnAction), for: .touchUpInside)
        return closeBtn
    }()
    
    private lazy var toolView: DDCustomCameraToolView = DDCustomCameraToolView()
    private var layoutOK: Bool = false
    //预览图层，显示相机拍摄到的画面
    private var previewLayer: AVCaptureVideoPreviewLayer?
    //AVCaptureDeviceInput对象是输入流
    private var videoInput: AVCaptureDeviceInput?
    //照片输出流对象
    private var imageOutPut: AVCaptureStillImageOutput?
    //视频输出流
    private var movieFileOutPut: AVCaptureMovieFileOutput?
    //视屏方向
    private var orientation: AVCaptureVideoOrientation?
    //拍照照片显示
    private lazy var takedImageView: UIImageView = {
        let takedImageView = UIImageView()
        takedImageView.backgroundColor = UIColor.black
        takedImageView.isHidden = true
        takedImageView.contentMode = .scaleAspectFit
        return takedImageView
    }()
    //拍照的照片
    private var takedImage: UIImage?
    //录制视频保存的url
    private var videoUrl: URL?
    //视屏播放界面
    private var playerView: DDCustomCameraPlayer?
    //是否开启闪光灯
    private var isFlashOn: Bool = false
    //保存device
    private var captureDevice: AVCaptureDevice?
    //相册管理
    private var pickermanager: DDPhotoPickerManager?
    //拍照限制区域框
    private lazy var clipperView: DDClipperView = {
        let clipperView = DDClipperView(frame: view.bounds)
        clipperView.clipperSize = clipperSize
        return clipperView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCamera()
        observeDeviceMotion()
        addNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        motionManager?.stopDeviceMotionUpdates()
        motionManager = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        session.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        session.stopRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if layoutOK == true {
            return
        }
        layoutOK = true
        
        toolView.frame = CGRect(x: 0, y: kViewHeight-130-DDSafeAreaBottom, width: kViewWidth, height: 100)
        previewLayer?.frame = view.layer.bounds
        
        toggleCameraBtn.frame = CGRect(x: kViewWidth-18-30, y: 52, width: 30, height: 30)
        flashlightBtn.frame = CGRect(x: kViewWidth-18-30-30-20, y: 52, width: 30, height: 30)
        closeBtn.frame = CGRect(x: 18, y: 52, width: 30, height: 30)
        takedImageView.frame = view.bounds
    }
    
    //只允许竖屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    deinit {
        if session.isRunning == true {
            session.stopRunning()
        }
       try? AVAudioSession.sharedInstance().setActive(false, with: .notifyOthersOnDeactivation)
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Action
extension DDCustomCameraController {
    @objc func flashlightBtnAction() {
        guard let device = captureDevice else {
            return
        }
        
        try? device.lockForConfiguration()
        if isFlashOn == true {
            if device.isFlashModeSupported(.off) == true {
                device.flashMode = .off
                isFlashOn = false
            }
        } else {
            if device.isFlashModeSupported(.on) == true {
                device.flashMode = .on
                isFlashOn = true
            }
        }
        device.unlockForConfiguration()
    }
    
    @objc func btnToggleCameraAction() {
        if takedImageView.isHidden == false {
            return
        }
        let cameraCount = AVCaptureDevice.devices(for: .video).count
        if cameraCount <= 1 {
           return
        }
        
        var newVideoInput: AVCaptureDeviceInput?
        let position = videoInput?.device.position
        if position == .back {
            if let device = frontCamera() {
                newVideoInput = try? AVCaptureDeviceInput(device: device)
            }
        } else if position == .front {
            if let device = backCamera() {
                newVideoInput = try? AVCaptureDeviceInput(device: device)
            }
        } else {
            return
        }
        
        if let newVideoInput = newVideoInput {
            guard let videoInput = videoInput else {
                return
            }
            session.beginConfiguration()
            session.removeInput(videoInput)

            if session.canAddInput(newVideoInput) == true {
                session.addInput(newVideoInput)
                self.videoInput = newVideoInput
            } else {
                session.addInput(videoInput)
            }
            
            session.commitConfiguration()
        }
    }
    
    @objc func colseBtnAction() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - DDCustomCameraToolViewDelegate
extension DDCustomCameraController: DDCustomCameraToolViewDelegate {
    //点击相册
    func onPhotoAlbum() {
        if isFromDDPhotoPickerPresent == true {
            doneBlock?(takedImage, videoUrl)
            dismiss(animated: true, completion: nil)
            return
        }
        pickermanager = DDPhotoPickerManager()
        pickermanager?.isFromDDCustomCameraPresent = true
        pickermanager?.presentImagePickerController {[weak self] (arr) in
            self?.selectedAlbumBlock?(arr)
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func onTakePicture() {
        let videoConnection = imageOutPut?.connection(with: .video)
        videoConnection?.videoOrientation = orientation ?? .portrait
        
        guard let connection = videoConnection else {
            return
        }
        
        imageOutPut?.captureStillImageAsynchronously(from: connection, completionHandler: {[weak self] (imageDataSampleBuffer, err) in
            guard let buffer = imageDataSampleBuffer,
                let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer) else {
                return
            }
          
            let image = UIImage(data: data)
            if self?.isShowClipperView == true {
                self?.takedImage = self?.clipImg(image: image)
            } else {
                self?.takedImage = image
            }
            self?.takedImageView.isHidden = false
            self?.takedImageView.image = self?.takedImage
            self?.session.stopRunning()
        })
    }
    
    func onStartRecord() {
        let movieConnection = movieFileOutPut?.connection(with: .video)
        movieConnection?.videoOrientation = orientation ?? .portrait
        movieConnection?.videoScaleAndCropFactor = 1.0
        
        /// ios10后，设置输出视屏h格式
        if let connection = movieConnection {
            if #available(iOS 10.0, *) {
                var dic = [String: String]()
                dic[AVVideoCodecKey] = AVVideoCodecH264
                movieFileOutPut?.setOutputSettings(dic, for: connection)
            }
        }
       
        if movieFileOutPut?.isRecording == false {
            let path = DDCustomCameraManager.getVideoExportFilePath(.mp4)
            let url = URL(fileURLWithPath: path)
            movieFileOutPut?.startRecording(to: url, recordingDelegate: self)
        }
    }

    func onFinishRecord() {
        movieFileOutPut?.stopRecording()
        session.stopRunning()
        setVideoZoomFactor(1.0)
    }
    
    func onRetake() {
        session.startRunning()
        takedImageView.isHidden = true
        deleteVideo()
    }
    
    func onOkClick() {
        playerView?.reset()
        if let block = doneBlock {
            block(takedImage, videoUrl)
        }
        
        if isFromDDPhotoPickerPresent == true {
            var vc: UIViewController? = self
            while(vc?.presentingViewController != nil) {
                vc = vc?.presentingViewController
            }
            vc?.dismiss(animated: true, completion: nil)
            return
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - AVCaptureFileOutputRecordingDelegate
extension DDCustomCameraController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        toolView.startAnimate()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if CMTimeGetSeconds(output.recordedDuration) < 1 {
            if isEnableTakePhoto == true {
                //视频长度小于1s 允许拍照则拍照，不允许拍照，则保存小于1s的视频x
                lastFrame(videoUrl: outputFileURL, size: CGSize(width: 720, height: 1280), duration: output.recordedDuration) {[weak self] (image) in
                    self?.takedImage = image
                    self?.takedImageView.isHidden = false
                    self?.takedImageView.image = image
                }
                return
            }
        }
        
        videoUrl = outputFileURL
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.playVideo()
        }
    }
}

private extension DDCustomCameraController {
    
    //截图限制区域的图片
    func clipImg(image: UIImage?) -> UIImage? {
        guard let image = image else {
            return nil
        }
        let scale: CGFloat = 3.0
        let scaleImage = scaleToSize(image: image, size: view.frame.size, scale: scale)
        let rect = view.convert(clipperView.clipperImgView?.frame ?? CGRect.zero, to: view)
        let rect2 = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        let resultImage = imageFromImage(imageFromImage: scaleImage, inRext: rect2)
        
        return resultImage
    }
    
    func scaleToSize(image: UIImage?, size: CGSize, scale: CGFloat) -> UIImage? {
        guard let image = image  else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale); //此处将画布放大两倍，这样在retina屏截取时不会影响像素
//
//        // 得到图片上下文，指定绘制范围
//        UIGraphicsBeginImageContext(size);
        // 将图片按照指定大小绘制
        image.draw(in: CGRect(x:0,y:0,width:size.width,height:size.height))
        // 从当前图片上下文中导出图片
        let img = UIGraphicsGetImageFromCurrentImageContext()
        // 当前图片上下文出栈
        UIGraphicsEndImageContext();
        // 返回新的改变大小后的图片
        return img
    }
    
    //2.实现这个方法,,就拿到了截取后的照片.
    func imageFromImage(imageFromImage:UIImage?, inRext:CGRect) -> UIImage? {
        guard let imageFromImage = imageFromImage  else {
            return nil
        }
        
        //将UIImage转换成CGImageRef
        //按照给定的矩形区域进行剪裁
        guard let sourceImageRef:CGImage = imageFromImage.cgImage,
            let newImageRef:CGImage = sourceImageRef.cropping(to: inRext) else {
            return nil
        }
        
        //将CGImageRef转换成UIImage
        let img:UIImage = UIImage.init(cgImage: newImageRef)
        //返回剪裁后的图片
        return img
    }

    /// 获取视屏的最后一帧
    ///
    /// - Parameters:
    ///   - url: url
    ///   - size: 图片的size
    ///   - duration: 视屏时长
    ///   - completion: 完成回调
    func lastFrame(videoUrl url: URL?, size: CGSize, duration: CMTime, completion:@escaping (UIImage?)->()) {
        guard let url = url  else {
            completion(nil)
            return
        }
        
        DispatchQueue.global().async {
            let opts = [AVURLAssetPreferPreciseDurationAndTimingKey: false]
            let urlAsset = AVURLAsset(url: url, options: opts)
            let genarator = AVAssetImageGenerator(asset: urlAsset)
            genarator.appliesPreferredTrackTransform = true
            genarator.requestedTimeToleranceAfter = kCMTimeZero
            genarator.requestedTimeToleranceBefore = kCMTimeZero
            let secondes = duration.seconds
            //1 代码最后一帧
            let time = CMTimeMakeWithSeconds(secondes, 1)
            genarator.maximumSize = CGSize(width: size.width, height: size.height)
            let img = try? genarator.copyCGImage(at: time, actualTime: nil)
            DispatchQueue.main.async(execute: {
                if let image = img {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
    
    func playVideo() {
        if playerView == nil {
            let playV = DDCustomCameraPlayer(frame: view.bounds)
            view.insertSubview(playV, belowSubview: toolView)
            playerView = playV
        }
        
        playerView?.videoUrl = videoUrl
        playerView?.play()
    }
    
    func setVideoZoomFactor(_ zoomFactor: CGFloat) {
       let captureDevice = videoInput?.device
       try? captureDevice?.lockForConfiguration()
        captureDevice?.videoZoomFactor = zoomFactor
        captureDevice?.unlockForConfiguration()
    }
    
    func deleteVideo() {
        if videoUrl != nil {
            playerView?.reset()
            playerView?.alpha = 0
            if let url = videoUrl {
                try? FileManager.default.removeItem(at: url)
            }
            //清空videoUrl
            videoUrl = nil
        }
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.black
        if isShowClipperView == true {
            view.addSubview(clipperView)
        }
        
        toolView.isEnableTakePhoto = isEnableTakePhoto
        toolView.isEnableRecordVideo = isEnableRecordVideo
        toolView.circleProgressColor = circleProgressColor
        toolView.maxRecordDuration = maxRecordDuration
        toolView.delegate = self
        toolView.isShowClipperView = isShowClipperView
        view.addSubview(toolView)
      
        view.addSubview(toggleCameraBtn)
        view.addSubview(closeBtn)
        view.addSubview(flashlightBtn)
        
        if isEnableRecordVideo == true {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(adjustCameraFocus(_:)))
            view.addGestureRecognizer(pan)
        }
        
        //添加拍照成功后图片背景，默认为隐藏
        takedImageView.frame = view.bounds
        view.insertSubview(takedImageView, belowSubview: toolView)
    }
    
    func setupCamera() {
        guard let device = backCamera() else {
            return
        }
        captureDevice = device
        //相机画面输入流
        videoInput = try? AVCaptureDeviceInput(device: device)
        
        //照片输出流
        imageOutPut = AVCaptureStillImageOutput()
        //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
        let dicOutputSetting = [AVVideoCodecKey: AVVideoCodecJPEG]
        imageOutPut?.outputSettings = dicOutputSetting
        
        //音频输入流
        let audioCaptureDevice = AVCaptureDevice.devices(for: .audio).first
        var audioInput: AVCaptureDeviceInput? = nil
        if isEnableRecordVideo == true {
            guard let audioDevice = audioCaptureDevice else {
                return
            }
            audioInput = try? AVCaptureDeviceInput(device: audioDevice)
        }
        
        //视频输出流
        //设置视频格式
        let preset = transformSessionPreset()
        if session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: preset)) {
            session.sessionPreset = AVCaptureSession.Preset(rawValue: preset)
        } else {
            session.sessionPreset = AVCaptureSession.Preset.hd1280x720
        }
        
        movieFileOutPut = AVCaptureMovieFileOutput()
        //必须设置，否则默认超过10s就没声音
        movieFileOutPut?.movieFragmentInterval = kCMTimeInvalid
        //将视频及音频输入流添加到session
        if let videoInput = videoInput  {
            if session.canAddInput(videoInput) == true {
                session.addInput(videoInput)
            }
        }
       
        //添加音频输入
        if let audioInput = audioInput {
            if session.canAddInput(audioInput) == true {
                session.addInput(audioInput)
            }
        }
        
        //添加输出流
        if let imageOutPut = imageOutPut {
            if session.canAddOutput(imageOutPut) == true {
                session.addOutput(imageOutPut)
            }
        }
        
        if let movieFileOutPut = movieFileOutPut {
            if session.canAddOutput(movieFileOutPut) == true {
                session.addOutput(movieFileOutPut)
            }
        }
        
        //预览层
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        view.layer.masksToBounds = true
        
        //添加预览层到当前view.layer上
        previewLayer?.videoGravity = .resizeAspectFill
        if let previewLayer = previewLayer {
            view.layer.insertSublayer(previewLayer, at: 0)
        }
        
        //设置闪光灯属性
        //先加锁
        try? device.lockForConfiguration()
//        //闪光灯自动
//        if device.isFlashModeSupported(.auto) == true {
//            device.flashMode = .auto
//        }
        //自动白平衡
        if device.isWhiteBalanceModeSupported(.autoWhiteBalance) == true {
            device.whiteBalanceMode = .autoWhiteBalance
        }
        
        //启动默认是关闭闪光灯
        if device.isFlashModeSupported(.off) == true {
            device.flashMode = .off
        }
        //解锁
        device.unlockForConfiguration()
    }
    
    func observeDeviceMotion() {
        // 确定是否使用任何可用的态度参考帧来决定设备的运动是否可用
        if motionManager?.isDeviceMotionAvailable == true {
            // 启动设备的运动更新，通过给定的队列向给定的处理程序提供数据。
            motionManager?.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {[weak self] (motion, err) in
                DispatchQueue.main.async(execute: {
                    self?.handleDeviceMotion(motion)
                })
            })
        } else {
            motionManager = nil
        }
    }
    
    @objc func handleDeviceMotion(_ deviceMotion: CMDeviceMotion?) {
        if isShowClipperView == true {
            orientation = .portrait
            return
        }
        let x = deviceMotion?.gravity.x ?? 0.0
        let y = deviceMotion?.gravity.y ?? 0.0

        if fabs(y) >= fabs(x) {
            if y >= 0 {
                orientation = .portraitUpsideDown
            } else {
                orientation = .portrait
            }
        } else {
            if x >= 0 {
                orientation = .landscapeLeft
            } else {
                orientation = .landscapeRight
            }
        }
    }
    
    func transformSessionPreset() -> String {
        switch sessionPreset {
        case .preset325x288:
            return AVCaptureSession.Preset.cif352x288.rawValue
        case .preset640x480:
            return AVCaptureSession.Preset.vga640x480.rawValue
        case .preset960x540:
            return AVCaptureSession.Preset.iFrame960x540.rawValue
        case .preset1280x720:
            return AVCaptureSession.Preset.iFrame1280x720.rawValue
        case .preset1920x1080:
            return AVCaptureSession.Preset.hd1920x1080.rawValue
        case .preset3840x2160:
            return AVCaptureSession.Preset.hd4K3840x2160.rawValue
        }
    }
    
    func backCamera() -> AVCaptureDevice? {
        return cameraWithPosition(.back)
    }
    
    func frontCamera() -> AVCaptureDevice? {
        return cameraWithPosition(.front)
    }
    
    func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: .video)
        for device in devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    func addNotification() {
          NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    func onDismiss() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func willResignActive() {
        if session.isRunning == true {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func adjustCameraFocus(_ pan: UIPanGestureRecognizer) {
        
    }
}
