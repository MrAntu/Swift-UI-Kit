

//
//  DDPhotoPickerBorwserCell.swift
//  Photo
//
//  Created by USER on 2018/11/12.
//  Copyright © 2018 leo. All rights reserved.
//

import UIKit
import Photos

public enum DDPhotoPickerBorwserCellType {
    case picker
    case uploadBrowser
}

class DDPhotoPickerBorwserCell: UICollectionViewCell {
    private var currentScale: CGFloat = 1
    private let maxScale: CGFloat = 2
    private let minScale: CGFloat = 1
    private var requestId: PHImageRequestID?
    private var model: DDPhotoGridCellModel?
    public var type: DDPhotoPickerBorwserCellType = .picker
    //单击回调
    var oneTapClosure: ((UITapGestureRecognizer?) -> Void)?
    
    var photoImage: UIImage? {
        didSet {
            photoImageView.image = photoImage
            guard let size = photoImage?.size else {
                return
            }
            let screenWidth: CGFloat = UIScreen.main.bounds.size.width
            let screenHeight: CGFloat = UIScreen.main.bounds.size.height
            let scaleImage = size.height / size.width
            let imageHeight = screenWidth * scaleImage
            var frame = CGRect(x: 0, y: 0, width: screenWidth, height: imageHeight)
            //转换后的图片高度还超过屏幕高度，就再次转换
            if imageHeight > screenHeight {
                let imageW = screenHeight / scaleImage
                frame = CGRect(x: 0, y: 0, width: imageW, height: screenHeight)
            }
            //比列超过3的，超长图片重新计算宽高
            if scaleImage > 3 {
                let imageHeight = screenWidth * scaleImage
                frame = CGRect(x: 0, y: 0, width: screenWidth, height: imageHeight)
            }
            photoImageView.frame = frame
            //高度大于设备高度，不居中显示
            if frame.height > screenHeight {
            } else {
                photoImageView.center = photoImageScrollView.center
            }
            photoImageScrollView.contentSize = photoImageView.frame.size
        }
    }
    
    var animationDuration: TimeInterval? {
        didSet {
            photoImageView.animationDuration = animationDuration ?? 0
            photoImageView.startAnimating()
        }
    }
    
    var photoImages: [UIImage]? {
        didSet {
            photoImageView.animationImages = photoImages
        }
    }

    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var photoImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        var frame = self.contentView.bounds
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.maximumZoomScale = self.maxScale
        scrollView.minimumZoomScale = self.minScale
        let oneTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(oneTap(oneTapGestureRecognizer:)))
        oneTapGestureRecognizer.numberOfTapsRequired = 1
        oneTapGestureRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(oneTapGestureRecognizer)
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTap(doubleTapGestureRecognizer:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapGestureRecognizer)
        oneTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        scrollView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleHeight]
        return scrollView
    }()
    
    //MARK -- 视屏播放相关    
    public let videoView: DDPhotoVideoView = {
        let videoView = DDPhotoVideoView()
        videoView.backgroundColor = UIColor.black
        return videoView
    }()

    // 初始缩放大小
    var defaultScale: CGFloat = 1 {
        didSet {
            photoImageScrollView.setZoomScale(defaultScale, animated: false)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = contentView.bounds
        frame.size.width -= 10
        
        //初始化默认zoom
        currentScale = 1.0
        photoImageScrollView.setZoomScale(currentScale, animated: true)
        
        photoImageScrollView.frame = frame
        photoImageView.frame = frame
        
        /// 横竖屏切换，重新布局
        if photoImageView.image != nil {
            photoImage = photoImageView.image
        }
        videoView.frame = frame
    }
    
    deinit {
        print(self)
    }
}

extension DDPhotoPickerBorwserCell {
   public func disPlayCell(_ model: DDPhotoGridCellModel?) {
        self.model = model
        if model?.type != .video {
            photoImageView.isHidden = false
            videoView.isHidden = true
            photoImageView.removeFromSuperview()
            photoImageScrollView.addSubview(photoImageView)
            return
        }
    
        //当前cell是视屏播放
        videoView.isHidden = false
        photoImageView.removeFromSuperview()
        videoView.addSubview(photoImageView)
        photoImageView.isHidden = false

        videoView.model = model
    
        videoView.hiddenPreviewCallBack = {[weak self] (isPlay) in
            //除了第一次加载显示一下封面，后续一直隐藏
            self?.photoImageView.isHidden = true
            
            if self?.type == .uploadBrowser {
                //隐藏导航栏和底部栏
                let vc = self?.ddPhotoViewController() as? DDPhotoUploadBrowserController
                if isPlay == false {
                    vc?.navigationView.isHidden = false
                } else {
                    vc?.navigationView.isHidden = true
                }
                return
            }
            
            //隐藏导航栏和底部栏
            let vc = self?.ddPhotoViewController() as! DDPhotoPickerBorwserController
            if isPlay == false {
                vc.navigationView.isHidden = false
                vc.bottomView.isHidden = false
            } else {
                vc.navigationView.isHidden = true
                vc.bottomView.isHidden = true
            }
        }
    }
    
    public func setPreviewImage(_ model: DDPhotoGridCellModel?) {
        //取消之前的requeset
        if let id = requestId {
            if id > 0 {
                DDPhotoImageManager.default().cancelImageRequest(id)
            }
        }
        requestId = DDPhotoPickerSource.requestPreviewImage(for: model
            , callBack: {[weak self] (image) in
                self?.photoImage = image
        })
    }
}

//MARK: -UIScrollView delegate
extension DDPhotoPickerBorwserCell: UIScrollViewDelegate {
    // 单击手势
    @objc func oneTap(oneTapGestureRecognizer: UITapGestureRecognizer) {
        if let callBack = oneTapClosure {
            callBack(oneTapGestureRecognizer)
        }
    }
    
    // 双击手势
    @objc func doubleTap(doubleTapGestureRecognizer: UITapGestureRecognizer) {
        //当前倍数等于最大放大倍数
        //双击默认为缩小到原图
        let aveScale = minScale + (maxScale - minScale) / 2.0 //中间倍数
        if currentScale >= aveScale {
            currentScale = minScale
            self.photoImageScrollView.setZoomScale(currentScale, animated: true)
        } else if currentScale < aveScale {
            currentScale = maxScale
            let touchPoint = doubleTapGestureRecognizer.location(in: doubleTapGestureRecognizer.view)
            self.photoImageScrollView.zoom(to: CGRect(x: touchPoint.x, y: touchPoint.y, width: 10, height: 10), animated: true)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var xcenter = scrollView.center.x , ycenter = scrollView.center.y
        //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
        xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
        ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
        self.photoImageView.center = CGPoint(x: xcenter, y: ycenter)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        currentScale = scale
    }
}

private extension DDPhotoPickerBorwserCell {
    func setupUI() {
        contentView.backgroundColor = UIColor.black
        photoImageScrollView.addSubview(photoImageView)
        contentView.addSubview(photoImageScrollView)
        contentView.addSubview(videoView)
        if #available(iOS 11.0, *) {
            photoImageScrollView.contentInsetAdjustmentBehavior = .never
        }
    }
}

extension UIView {
    func ddPhotoViewController () -> UIViewController? {
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
