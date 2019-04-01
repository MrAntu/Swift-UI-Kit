
//
//  DDCustomCameraToolView.swift
//  DDCustomCamera
//
//  Created by USER on 2018/11/15.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

let kBottomViewScale: CGFloat =  0.7
let kTopViewScale: CGFloat =  0.5
let kAnimateDuration: CGFloat =  0.1

protocol DDCustomCameraToolViewDelegate: class {
    //拍照
    func onTakePicture()
    //录制
    func onStartRecord()
    //结束录制
    func onFinishRecord()
    //重新拍照或录制
    func onRetake()
    //点击确定
    func onOkClick()
    //点击相册
    func onPhotoAlbum()
}

class DDCustomCameraToolView: UIView {

    private lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.layer.masksToBounds = true
        bottomView.backgroundColor = UIColor.clear
        return bottomView
    }()
    
    private lazy var tipLab: UILabel = {
        let tipLab = UILabel()
        tipLab.text = Bundle.localizedString("cameraTip")
        tipLab.font = UIFont(name: "PingFangSC-Regular", size: 16)
        tipLab.textAlignment = .center
        tipLab.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return tipLab
    }()
    
    private lazy var shootBtn: UIButton = {
        let btn = UIButton(type: .custom)
        if let path = Bundle(for: DDCustomCameraController.classForCoder()).path(forResource: "DDCustomCamera", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "btnShoot", in: bundle, compatibleWith: nil)
        {
            btn.setImage(image, for: .normal)
        }
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    private lazy var photoAlbumBtn: UIButton = {
        let photoAlbumBtn = UIButton(type: .custom)
        if let path = Bundle(for: DDCustomCameraController.classForCoder()).path(forResource: "DDCustomCamera", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "photographyGallery", in: bundle, compatibleWith: nil)
        {
            photoAlbumBtn.setImage(image, for: .normal)
        }
        photoAlbumBtn.addTarget(self, action: #selector(photoAlbumBtnAction), for: .touchUpInside)
        photoAlbumBtn.setTitle(Bundle.localizedString("相册"), for: .normal)
        photoAlbumBtn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 12)
        return photoAlbumBtn
    }()
    
    private lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        if let path = Bundle(for: DDCustomCameraController.classForCoder()).path(forResource: "DDCustomCamera", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "photographyBtnReturn", in: bundle, compatibleWith: nil)
        {
            cancelBtn.setImage(image, for: .normal)
        }
        cancelBtn.addTarget(self, action: #selector(retake), for: .touchUpInside)
        cancelBtn.layer.masksToBounds = true
        cancelBtn.isHidden = true
        return cancelBtn
    }()
    
    private lazy var doneBtn: UIButton = {
        let doneBtn = UIButton(type: .custom)
        if let path = Bundle(for: DDCustomCameraController.classForCoder()).path(forResource: "DDCustomCamera", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "photographyBtnSelect", in: bundle, compatibleWith: nil)
        {
            doneBtn.setImage(image, for: .normal)
        }
        doneBtn.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
        doneBtn.layer.masksToBounds = true
        doneBtn.isHidden = true
        return doneBtn
    }()
    
    private lazy var animateLayer: CAShapeLayer = {
        let animateLayer = CAShapeLayer(layer: self)
        let width = self.bottomView.frame.height * kBottomViewScale
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: width), cornerRadius: width/2)
        animateLayer.strokeColor = self.circleProgressColor.cgColor
        animateLayer.fillColor = UIColor.clear.cgColor
        animateLayer.path = path.cgPath
        animateLayer.lineWidth = 8
        return animateLayer
    }()
    
    private var layoutOK: Bool = false
    private var stopRecord: Bool = false

    //layer圆圈的颜色
    public var circleProgressColor: UIColor = UIColor(red: 99.0/255.0, green: 181.0/255.0, blue: 244.0/255.0, alpha: 1)
    
    //是否获取限制区域中的图片
    public var isShowClipperView: Bool? {
        didSet {
            if isShowClipperView == true {
                tipLab.removeFromSuperview()
                photoAlbumBtn.removeFromSuperview()
            }
        }
    }
    
    //是否允许拍照
    public var isEnableTakePhoto: Bool? {
        didSet {
            if isEnableTakePhoto == true {
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
                bottomView.addGestureRecognizer(tap)
            }
        }
    }
    
    //是否允许摄像
    public var isEnableRecordVideo: Bool? {
        didSet {
            if isEnableRecordVideo == true {
                let tap = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
                tap.minimumPressDuration = 0.3
                tap.delegate = self
                bottomView.addGestureRecognizer(tap)
            } else {
                tipLab.removeFromSuperview()
            }
        }
    }
    
    //最大录制时长
    public var maxRecordDuration: Int = 15
    
    //设置代理
    public weak var delegate : DDCustomCameraToolViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if layoutOK == true {
            return
        }
        
        layoutOK = true
        let height = self.frame.size.height
        
        tipLab.frame = CGRect(x: 20, y: -30, width: frame.size.width - 40, height: 25)
        bottomView.frame = CGRect(x: 0, y: 0, width: height * kBottomViewScale, height: height * kBottomViewScale)
        bottomView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        bottomView.layer.cornerRadius = height * kBottomViewScale / 2
        
        shootBtn.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        shootBtn.center = bottomView.center
        
        photoAlbumBtn.frame = CGRect(x: 60, y: bounds.size.height/2-70/2, width: 40, height: 70)
        photoAlbumBtn.cameraImagePositionTop()
        cancelBtn.frame = bottomView.frame
        
        doneBtn.frame = bottomView.frame
    }
    
    deinit {
    }
}

extension DDCustomCameraToolView {
    public func startAnimate() {
        photoAlbumBtn.isHidden = true
        tipLab.isHidden = true
        bottomView.backgroundColor = UIColor.white
        UIView.animate(withDuration: TimeInterval(kAnimateDuration), animations: {
            self.bottomView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.0/kBottomViewScale, 1/kBottomViewScale, 1)
            self.shootBtn.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.7, 0.7, 1)
        }) { (finished) in
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = CFTimeInterval(self.maxRecordDuration)
            animation.delegate = self
            self.animateLayer.add(animation, forKey: nil)
            self.bottomView.layer.addSublayer(self.animateLayer)
        }
    }
    
}

// MARK: - CAAnimationDelegate
extension DDCustomCameraToolView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if stopRecord == true {
            return
        }
        
        stopRecord = true
        stopAnimate()
        delegate?.onFinishRecord()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension DDCustomCameraToolView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let res1 = gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self)
        let res2 = otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
        
        if res1 == true && res2 == true {
            return true
        }
        return false
    }
}

private extension DDCustomCameraToolView {
    func setupUI() {
        addSubview(bottomView)
        addSubview(shootBtn)
        addSubview(photoAlbumBtn)
        addSubview(tipLab)
        photoAlbumBtn.frame = CGRect(x: 60, y: bounds.size.height/2-25/2, width: 25, height: 25)
        
        addSubview(cancelBtn)
        addSubview(doneBtn)
        doneBtn.frame = bottomView.frame
    }
    
    func resetUI() {
        if animateLayer.superlayer != nil {
            animateLayer.removeAllAnimations()
            animateLayer.removeFromSuperlayer()
        }
        
        photoAlbumBtn.isHidden = false
        tipLab.isHidden = false
        bottomView.isHidden = false
        shootBtn.isHidden = false
        cancelBtn.isHidden = true
        doneBtn.isHidden = true
        
        cancelBtn.frame = bottomView.frame
        doneBtn.frame = bottomView.frame
    }
    
    func stopAnimate() {
        animateLayer.removeFromSuperlayer()
        animateLayer.removeAllAnimations()
        
        bottomView.isHidden = true
        shootBtn.isHidden = true
        photoAlbumBtn.isHidden = true
        tipLab.isHidden = true
        
        bottomView.layer.transform = CATransform3DIdentity
        shootBtn.layer.transform = CATransform3DIdentity
        bottomView.backgroundColor = UIColor.white
        showCancelDoneBtn()
    }
    
    func showCancelDoneBtn() {
        cancelBtn.isHidden = false
        doneBtn.isHidden = false
        
        var cancelRect = cancelBtn.frame
        cancelRect.origin.x = 40
        
        var doneRect = doneBtn.frame
        doneRect.origin.x = frame.size.width - doneRect.size.width - 40
        
        UIView.animate(withDuration: TimeInterval(kAnimateDuration)) {
            self.cancelBtn.frame = cancelRect
            self.doneBtn.frame = doneRect
        }
    }
    
    @objc func photoAlbumBtnAction() {
        delegate?.onPhotoAlbum()
    }
    
    @objc func retake() {
        resetUI()
        delegate?.onRetake()
    }
    
    @objc func doneClick() {
        delegate?.onOkClick()
    }
    
    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        stopAnimate()
        delegate?.onTakePicture()
    }
    
    @objc func longPressAction(_ long: UILongPressGestureRecognizer) {
        switch long.state {
        case .began:
            //此处不启动动画，由控制器开始录制后启动
            stopRecord = false
            delegate?.onStartRecord()
        case .cancelled:break
        case .ended:
            if stopRecord == true {
                return
            }
            stopRecord = true
            stopAnimate()
            delegate?.onFinishRecord()
        default:
            break
        }
    }
    
}

extension UIView {
    func ddCameraViewController () -> UIViewController? {
        var next: UIResponder?
        next = self.next
        repeat {
            if (next as? UIViewController) != nil {
                return next as? UIViewController
            } else {
                next = next?.next
            }
        } while next != nil
        return UIViewController()
    }
}

extension UIButton {
    func cameraImagePositionTop () {
        if self.imageView != nil, let titleLabel = self.titleLabel {
            let imageSize = self.imageRect(forContentRect: self.frame)
            var titleSize = CGRect.zero
            if let txtFont = titleLabel.font, let str = titleLabel.text {
                titleSize = (str as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: txtFont], context: nil)
            }
            let spacing: CGFloat = 6
            titleEdgeInsets = UIEdgeInsets(top: imageSize.height + titleSize.height + spacing, left: -imageSize.width, bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        }
    }
}

