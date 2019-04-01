//
//  DDScanViewController.swift
//  DDScanDemo
//
//  Created by USER on 2018/11/27.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import Photos
import SnapKit

public protocol DDScanViewControllerDelegate: class {
    func scanFinished(scanResult: DDScanResult?)
}

open class DDScanViewController: UIViewController {
    
    open var scanStyle: DDScanStyleConfig? = DDScanStyleConfig()
    
    open var qRScanView: DDScanView?
    
    open weak var delegate: DDScanViewControllerDelegate?

    //启动区域识别功能 默认在中心点
    open var isOpenInterestRect = false
    //识别码的类型
    open var arrayCodeType: [AVMetadataObject.ObjectType]?
    //扫描操作对象
    open var scanWrapper: DDScanWrapper?

    open lazy var navigationBar: UIView = {
        let navigationBar = UIView()
        navigationBar.backgroundColor = scanStyle?.navigationBarColor
        return navigationBar
    }()
    
   open lazy var introduceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.text = scanStyle?.introduceLabelTitle
        return label
    }()
    
    open lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = scanStyle?.descLabelTitle
        return label
    }()
    
    open lazy var photoBtn: UIButton = {
        let photoBtn = UIButton(type: .custom)
        photoBtn.setTitle(scanStyle?.photoBtnTitle, for: .normal)
        photoBtn.setImage(scanStyle?.photoBtnImage, for: .normal)
        photoBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        photoBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        photoBtn.addTarget(self, action: #selector(photoBtnAction), for: .touchUpInside)
        return photoBtn
    }()
    
    open lazy var flashBtn: UIButton = {
        let flashBtn = UIButton(type: .custom)
        flashBtn.setTitle(scanStyle?.flashBtnTitle, for: .normal)
        flashBtn.setImage(scanStyle?.flashBtnImage, for: .normal)
        flashBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        flashBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        flashBtn.addTarget(self, action: #selector(flashBtnAction), for: .touchUpInside)
        return flashBtn
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        stop()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addScanView()
        perform(#selector(startScan), with: nil, afterDelay: 0.3)
        bringSubview()
    }
    
    /// 结果处理
    ///
    /// - Parameter results: 返回结果数组
    open func handleCodeResult(results: [DDScanResult]?) {
        guard let results = results  else {
            delegate?.scanFinished(scanResult: nil)
            return
        }
        delegate?.scanFinished(scanResult: results.first)
    }
    
    deinit {
    }
}

// MARK: - public API
extension DDScanViewController {
    /// 暂停扫描
   @objc open func stop() {
        qRScanView?.stopScanAnimation()
        scanWrapper?.stop()
    }

    /// 开启扫描
   @objc open func start() {
        qRScanView?.startScanAnimation()
        scanWrapper?.start()
    }
    
    /// 显示菊花
    @objc open func showActivity() {
        qRScanView?.deviceStartReadying(readyStr: scanStyle?.readyString)
    }
    
    @objc open func hiddenActivity() {
        qRScanView?.deviceStopReadying()
    }
    
    /// 操作相册
   @objc open func openPhotoAlbum() {
        DDScanPermissions.authorizePhoto {[weak self] (granted) in
            if granted == false {
                return
            }
            self?.presetImagePiker()
        }
    }
    
    /// 弹出系统相册
    @objc open func presetImagePiker() {
        let piker = UIImagePickerController()
        piker.sourceType = .photoLibrary
        piker.allowsEditing = true
        piker.delegate = self
        self.present(piker, animated: true, completion: nil)
    }

    /// 操作闪光灯 打开&&关闭
    @objc open func openFlashLight() {
        scanWrapper?.openFlashlight()
    }
    
}

// MARK: - Action && UIImagePickerControllerDelegate
extension DDScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc open func closeScanVC() {
        stop()
        if scanStyle?.showStyle == .push {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc open func photoBtnAction() {
        openPhotoAlbum()
    }
    
    @objc open func flashBtnAction() {
        openFlashLight()
    }
    
    // MARK: - ----相册选择图片识别二维码 （条形码没有找到系统方法）
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        var image: UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
        if (image == nil ) {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        guard let newImage = image else {
            return
        }
        
        let arrResult = DDScanWrapper.recognizeQRImage(newImage)
        if arrResult != nil && (arrResult?.count ?? 0) > 0 {
            handleCodeResult(results: arrResult)
        }
    }
}

// MARK: - UI & layout
extension DDScanViewController {
    
    @objc open func startScan() {
        if scanWrapper == nil {
            var cropRect = CGRect.zero
            
            if isOpenInterestRect {
                cropRect = DDScanView.getScanRectWithPreView(preView: view, style: scanStyle)
            }
            
            //指定几种二维码
            if arrayCodeType == nil {
                //如果项目只需要扫描二维码，只需要设置.qr .code128,ean13
                //类型越多，扫描效率越低
                arrayCodeType = scanStyle?.arrayCodeType
            }
            
            scanWrapper = DDScanWrapper(videoPreView: view, types: arrayCodeType ?? [.qr, .ean13, .code128], isCaptureImage: scanStyle?.isNeedCodeImage ?? false, cropRect: cropRect, complete: {[weak self] (arrayResult) in
                self?.stop()
                self?.handleCodeResult(results: arrayResult)
            })
        }
        
        //结束相机等待提示
        hiddenActivity()
        //开启扫描
        start()
    }
    
    @objc open func addScanView() {
        if qRScanView == nil {
            qRScanView = DDScanView(frame: view.frame, styleConfig: scanStyle)
            view.addSubview(qRScanView ?? UIView())
        }
        showActivity()
    }
    
    @objc open func setupUI() {
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        view.backgroundColor = UIColor.black
        addNavigationBar()
        addIntroduceLabel()
        addDescLabel()
        addPhotoBtn()
        addFlashBtn()
    }
    
    @objc open func addFlashBtn() {
        view.addSubview(flashBtn)
        flashBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view)
            make.width.height.equalTo(UIScreen.main.bounds.width / 2.0)
            make.bottom.equalTo(view)
        }
        flashBtn.imagePositionTop()
    }
    
    @objc open func addPhotoBtn() {
        photoBtn.imagePositionTop()
        view.addSubview(photoBtn)
        photoBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.width.height.equalTo(UIScreen.main.bounds.width / 2.0)
            make.bottom.equalTo(view)
        }
        photoBtn.imagePositionTop()
    }
    
    @objc open func addDescLabel() {
        view.addSubview(descLabel)
        let offset = (UIScreen.main.bounds.width - (scanStyle?.xScanRetangleOffset ?? 70) * 2.0) / 2.0
        descLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(offset)
        }
    }
    
    @objc open func addIntroduceLabel() {
        view.addSubview(introduceLabel)
    
        let offset = (UIScreen.main.bounds.width - (scanStyle?.xScanRetangleOffset ?? 70) * 2.0) / 2.0
        
        introduceLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-offset - 60)
        }
    }
    
    @objc open func addNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height + 44)
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.frame = CGRect(x: 14, y: UIApplication.shared.statusBarFrame.height + 10, width: 24, height: 24)
        closeBtn.setImage(scanStyle?.navigationBarBackImage, for: .normal)
        closeBtn.addTarget(self, action: #selector(closeScanVC), for: .touchDown)
        
        let titleLabel = UILabel()
        titleLabel.font = scanStyle?.navigationBarTitleFont
        titleLabel.textColor = scanStyle?.navigationBarTintColor
        titleLabel.text = scanStyle?.navigationBarTitle
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: navigationBar.center.x, y: (navigationBar.frame.height + UIApplication.shared.statusBarFrame.height) / 2)
        navigationBar.addSubview(closeBtn)
        navigationBar.addSubview(titleLabel)
    }
    
   @objc open func bringSubview() {
        view.bringSubview(toFront: navigationBar)
        view.bringSubview(toFront: introduceLabel)
        view.bringSubview(toFront: descLabel)
        view.bringSubview(toFront: photoBtn)
        view.bringSubview(toFront: flashBtn)
    }
}

// MARK: - 配置当前controller & UIGestureRecognizerDelegate
extension DDScanViewController: UIGestureRecognizerDelegate {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UIButton {
    func imagePositionTop () {
        if self.imageView != nil, let titleLabel = self.titleLabel {
            let imageSize = self.imageRect(forContentRect: self.frame)
            var titleSize = CGRect.zero
            if let txtFont = titleLabel.font, let str = titleLabel.text {
                titleSize = (str as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: txtFont], context: nil)
            }
            let spacing: CGFloat = 6
            titleEdgeInsets = UIEdgeInsets(top: imageSize.height + titleSize.height + spacing, left: -imageSize.width, bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        }
    }
}
