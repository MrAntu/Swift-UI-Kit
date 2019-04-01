
//
//  DDPhotoBrowerController.swift
//  DDPhotoBrowserDemo
//
//  Created by USER on 2018/11/22.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import Photos
//import DDKit

let kPhotoViewPadding: CGFloat = 10

class DDPhotoBrowerController: UIViewController {

    public var previousStatusBarStyle: UIStatusBarStyle = .default
    /// 是否需要显示状态栏
    public var isStatusBarShow: Bool = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    ///滑动消失时是否隐藏原来的视图
    public var isHideSourceView: Bool = false
    ///横屏时是否充满屏幕宽度，默认YES，为NO时图片自动填充屏幕
    public var isFullWidthForLandSpace: Bool = true
    /// 长按是否自动保存图片到相册，若为true,则长按代理不在回调。若为false，返回长按代理
    public var isLongPressAutoSaveImageToAlbum: Bool = true
    /// 配置保存图片权限提示
    public var photoPermission: String = "请在iPhone的\"设置-隐私-照片\"选项中，允许访问您的照片"

    /// 当前索引
    public var currentIndex: Int = 0
    
    public weak var deleagte: DDPhotoBrowerDelegate?

    public lazy var contentView: UIView = UIView()
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    private var photos: [DDPhoto]?
    private var isPortraitToUp: Bool = true
    private var isStatusBarShowing: Bool = false
    private var isDismissing: Bool = false

    private var photoCollectionView: UICollectionView?
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    //旋转之前index
    private var isDrag: Bool = false
    private lazy var  singleTap:UITapGestureRecognizer  = {
        let single = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        return single
    }()
    
    private lazy var  doubleTap: UITapGestureRecognizer = {
       let tap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        return tap
    }()
    
    private lazy var longPress: UILongPressGestureRecognizer = {
        let long = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        return long
    }()
    /// 拖拽手势
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        return panGesture
    }()
    
    public init(Photos photos: [DDPhoto]?, currentIndex: Int?) {
        super.init(nibName: nil, bundle: nil)
        
        self.photos = photos
        self.currentIndex = currentIndex ?? 0
        let photo = photos?[self.currentIndex]
        photo?.isFirstPhoto = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        addGestureRecognizer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeNotification), name: NSNotification.Name("PhotoBrowserVideoViewCloseKey"), object: nil)
    }
    
    @objc func closeNotification() {
        handleSingleTap(singleTap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isDismissing {
            return
        }
        layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //代理回调
        deleagte?.photoBrowser(controller: self, didChanged: currentIndex)
    }
    
    deinit {
        photoCollectionView?.removeFromSuperview()
        photoCollectionView = nil
        photos?.removeAll()
        photos = nil
        NotificationCenter.default.removeObserver(self)
    }
}

extension DDPhotoBrowerController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //图片cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDPhotoBrowerCell", for: indexPath) as! DDPhotoBrowerCell
        let photo = photos?[indexPath.row]
        if photo?.isFirstPhoto == true {
            cell.browserZoomShow(photo)
        } else {
            cell.photoView.setupPhoto(photo)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photoView = (cell as! DDPhotoBrowerCell).photoView
        photoView.scrollView.setZoomScale(1, animated: false)
        
        //判断cell是否是视屏，若是则停止播放
        if let photo = photos?[indexPath.row],
            photo.isVideo == true,
            photoView.videoView.isPlay() == true {
            photoView.videoView.reset()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension DDPhotoBrowerController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDrag = true
        //拖拽的时候停止播放gif
        guard let photo = currentPhoto() else {
            return
        }
        
        if photo.isGif == true {
           currentPhotoView().imageView.stopAnimating()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(round(scrollView.contentOffset.x/scrollView.bounds.width))
        if let count = photos?.count {
            if currentIndex >= count {
                currentIndex = count - 1
            }
            if currentIndex < 0 {
                currentIndex = 0
            }
        }
        
        removeGestureRecognizer()
        pageControl.isHidden = true
        if currentPhoto()?.isVideo == false {
            addGestureRecognizer()
            pageControl.isHidden = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isDrag = false
        let offsetX = scrollView.contentOffset.x
        
        let scrollW = photoCollectionView?.frame.width ?? 0
        
        let index: Int = Int((offsetX + scrollW * 0.5) / scrollW)

        pageControl.currentPage = index
        //代理回调
        deleagte?.photoBrowser(controller: self, didChanged: index)

        if (currentPhotoView().scrollView.zoomScale) > CGFloat(1.0) {
            removePanGesture()
        } else {
            addPanGesture(false)
        }
        
        //当前停止的cell若为播放gif，则播放
        guard let photo = currentPhoto() else {
                return
        }
        
        if photo.isGif == true {
            currentPhotoView().imageView.startAnimating()
        }
    }
}


// MARK: - private method
private extension DDPhotoBrowerController {
    
    /// 获取当前的photo
    func currentPhoto() -> DDPhoto? {
        if currentIndex >= (photos?.count ?? 0) {
            return nil
        }
        return photos?[currentIndex]
    }
    
    /// 获取当前cell中的photoView
    ///
    /// - Returns: photoView
    func currentPhotoView() -> DDPhotoView {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        let cell =  photoCollectionView?.cellForItem(at: indexPath) as! DDPhotoBrowerCell
        return cell.photoView
    }
    
    /// 设置UI
    func setupUI() {
        view.backgroundColor = UIColor.black
        contentView.backgroundColor = UIColor.clear
        contentView.clipsToBounds = true
        view.addSubview(contentView)
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let DDPhotoScreenWidth: CGFloat = UIScreen.main.bounds.size.width
        let DDPhotoScreenHeight: CGFloat = UIScreen.main.bounds.size.height
        flowLayout.itemSize = CGSize(width: DDPhotoScreenWidth + 10, height: DDPhotoScreenHeight)
        photoCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: DDPhotoScreenWidth + 10, height: DDPhotoScreenHeight), collectionViewLayout: flowLayout)
        if let photoCollectionView = photoCollectionView {
            photoCollectionView.isPagingEnabled = true
            photoCollectionView.register(DDPhotoBrowerCell.self,
                                         forCellWithReuseIdentifier: "DDPhotoBrowerCell")
            photoCollectionView.delegate = self
            photoCollectionView.dataSource = self
            photoCollectionView.backgroundColor = UIColor.clear
            photoCollectionView.showsVerticalScrollIndicator = false
            photoCollectionView.showsHorizontalScrollIndicator = false

            contentView.addSubview(photoCollectionView)
            if #available(iOS 11.0, *) {
                photoCollectionView.contentInsetAdjustmentBehavior = .never
            } else {
                automaticallyAdjustsScrollViewInsets = false
            }
            photoCollectionView.reloadData()
        }
        
        contentView.addSubview(pageControl)
        pageControl.numberOfPages = photos?.count  ?? 0
        pageControl.currentPage = currentIndex
    }
    
    /// 添加手势
    func addGestureRecognizer() {
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        
        /// 添加双击手势
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
      
        /// 双击时，单击失效
        singleTap.require(toFail: doubleTap)
        
        view.addGestureRecognizer(longPress)

        /// 添加拖拽手势
        addPanGesture(true)
    }
    
    func removeGestureRecognizer() {
        if view.gestureRecognizers?.contains(singleTap) == true {
            view.removeGestureRecognizer(singleTap)
        }
        
        if view.gestureRecognizers?.contains(doubleTap) == true {
            view.removeGestureRecognizer(doubleTap)
        }
        
        if view.gestureRecognizers?.contains(longPress) == true {
            view.removeGestureRecognizer(longPress)
        }
    }
    
    func addPanGesture(_ isFirst: Bool) {
        if isFirst == true {
            view.addGestureRecognizer(panGesture)
            return
        }
        let orientation = UIDevice.current.orientation
        if orientation.isPortrait == true || isPortraitToUp == true {
            view.addGestureRecognizer(panGesture)
        }
    }
    
    func removePanGesture() {
        if view.gestureRecognizers?.contains(panGesture) == true {
            view.removeGestureRecognizer(panGesture)
        }
    }
    
    func recoverAnimation() {
        let orientation = UIDevice.current.orientation
        let screenBounds = UIScreen.main.bounds
        if orientation.isLandscape {
            UIView.animate(withDuration: 0.25, animations: {
                //旋转contentView
                self.contentView.transform = .identity
                
                let height: CGFloat = CGFloat.maximum(screenBounds.width, screenBounds.height)
                
                //设置frame
                self.contentView.bounds = CGRect(x: 0, y: 0, width: CGFloat.minimum(screenBounds.size.width, screenBounds.size.height), height: height)
                self.contentView.center = UIApplication.shared.keyWindow?.center ?? CGPoint(x: 0, y: 0)
                
                self.layoutSubviews()
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                
            }) { (finished) in
                self.showDismissAnimation()
            }
        } else {
            self.showDismissAnimation()
        }
    }
    
    func showDismissAnimation() {
        let photoView = currentPhotoView()
        let photo = photos?[currentIndex]
        //结束位置
        var sourceRect = photo?.sourceFrame
        
        if sourceRect?.equalTo(CGRect.zero) == true || sourceRect == nil {
            if photo?.sourceImageView == nil {
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.alpha = 0
                }) { (finished) in
                    self.dismissAnimated(false)
                }
                return
            }
            
            if isHideSourceView {
                photo?.sourceImageView?.alpha = 0
            }
            sourceRect = photo?.sourceImageView?.superview?.convert(photo?.sourceImageView?.frame ?? CGRect.zero, to: contentView)
        } else {
            if isHideSourceView && (photo?.sourceImageView != nil) {
                photo?.sourceImageView?.alpha = 0
            }
        }
        //起始位置
        let originRect = photoView.imageView.frame

        //动画image
        let animationImage = UIImageView(image: photoView.imageView.image)
        animationImage.frame = originRect
        view.addSubview(animationImage)
        
        //先隐藏
        contentView.isHidden = true
        photoCollectionView?.isHidden = true
//        contentView.removeFromSuperview()
//        photoCollectionView?.removeFromSuperview()
//
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            animationImage.frame = sourceRect ?? CGRect.zero
            self.view.backgroundColor = UIColor.clear
        }) { (finished) in
            animationImage.removeFromSuperview()
            self.dismissAnimated(false)
            self.panEndedWillDisappear(false)
        }
        
//        UIView.animate(withDuration: 0.2, animations: {
//            photoView.scrollView.zoomScale = 1
////            photoView.imageView.frame = sourceRect ?? CGRect.zero
//            self.contentView.frame = sourceRect ?? CGRect.zero
//            self.view.backgroundColor = UIColor.clear
//        }) { (finished) in
//            self.dismissAnimated(false)
//            self.panEndedWillDisappear(false)
//        }
    }
    
    func panEndedWillDisappear(_ disappear: Bool) {
        //代理
    }
    
    func dismissAnimated(_ animated:Bool) {
        let photo = currentPhoto()        
        if animated {
            UIView.animate(withDuration: 0.25) {
                photo?.sourceImageView?.alpha = 1
            }
        } else {
            photo?.sourceImageView?.alpha = 1
        }
       
        //代理回调
        deleagte?.photoBrowser(controller: self, willDismiss: currentIndex)
        
        dismiss(animated: false, completion: nil)
    }
    
    
    func layoutSubviews() {
        
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        let screenHeight: CGFloat = UIScreen.main.bounds.size.height
        
        contentView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize(width: screenWidth + 10, height: screenHeight)
        photoCollectionView?.frame = CGRect(x: 0, y: 0, width: screenWidth + 10, height: screenHeight)
      
        //滚动cell
        if isDrag == false {
            photoCollectionView?.setContentOffset(CGPoint(x: Int(screenWidth + 10) * currentIndex, y: 0), animated: false)
        }
        
        //pageControl
        pageControl.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height - 20)
    }
    
    func frameWithWidth(_ width: CGFloat, height: CGFloat, center: CGPoint) -> CGRect {
        let x = center.x - width * 0.5
        let y = center.y - height * 0.5
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func showCancelAnimation() {
        let photoView = currentPhotoView()
        let photo = photos?[currentIndex]
        photo?.sourceImageView?.alpha = 1
        
        UIView.animate(withDuration: 0.25, animations: {
            photoView.imageView.transform = .identity
            self.view.backgroundColor = UIColor.black
        }) { (finished) in
            if self.isStatusBarShowing == false {
                self.isStatusBarShow = false
            }
            
            self.panEndedWillDisappear(false)
        }
    }

    func handlePanBegin() {
        let photo = currentPhoto()
        
        if isHideSourceView == true {
            photo?.sourceImageView?.alpha = 0
        }
        isStatusBarShowing = isStatusBarShow
        //显示状态栏
        isStatusBarShow = true
    }
    
    func handlePanZoomScale(_ panGesture: UIPanGestureRecognizer) {
        let point = panGesture.translation(in: view)
//        let location = panGesture.location(in: view)
        let velocity = panGesture.velocity(in: view)
        
        let photoView = currentPhotoView()
        isDrag = true
        switch panGesture.state {
        case .began:
            handlePanBegin()
            break
        case .changed:
            photoView.imageView.transform = CGAffineTransform(translationX: 0, y: point.y)
            var percent: CGFloat = CGFloat(1.0 - abs(point.y) / view.frame.height)
            percent = CGFloat.maximum(percent, 0)
            let s: CGFloat = CGFloat.maximum(percent, 0.5)
            let translation = CGAffineTransform(translationX: point.x / s, y: point.y / s);
            let scale = CGAffineTransform(scaleX: s, y: s)
            photoView.imageView.transform = translation.concatenating(scale)
            view.backgroundColor = UIColor.black.withAlphaComponent(percent)
            break
        case .ended, .cancelled:
            if (abs(point.y) > 200) || (abs(velocity.y) > 500) {
                showDismissAnimation()
            } else {
                showCancelAnimation()
            }
            isDrag = false
            break
        default:
            break
        }
    }
    
    func libraryAuthorization() {
        let authorStatus = PHPhotoLibrary.authorizationStatus()
        switch authorStatus {
        case .notDetermined:  //未确定 申请
            PHPhotoLibrary.requestAuthorization { (status) in
                //没有授权直接退出
                if status != .authorized {
                    return;
                }
            }
            break
        case .restricted: break
        case .denied:
            showAlertNoAuthority(photoPermission)
            return
        case .authorized:
            showAlertSaveImage()
            break
        default:
            break
        }
    }

    func showAlertSaveImage() {
        //弹窗提示
        let alertVC = UIAlertController(title: "保存图片到手机", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .default) { (action) in
        }
        let actionCommit = UIAlertAction(title: "确定", style: .default) {[weak self] (action) in
            self?.saveImageToAlbum()
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(actionCommit)
        present(alertVC, animated: true, completion: nil)
    }
    
    func saveImageToAlbum() {
        let photo = photos?[currentIndex]
        guard let image = photo?.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saved(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func saved(image: UIImage, didFinishSavingWithError erro: NSError?, contextInfo: AnyObject) {
        if erro != nil {
            print("错误")
            return
        }
        print("ok")
    }
    /// 显示无授权信息
    ///
    /// - Parameter text: 标题
    func showAlertNoAuthority(_ text: String?) {
        //弹窗提示
        let alertVC = UIAlertController(title: "温馨提示", message: text, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .default) { (action) in
        }
        let actionCommit = UIAlertAction(title: "去设置", style: .default) { (action) in
            //去设置
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(actionCommit)
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - 手势事件响应
extension DDPhotoBrowerController {

    @objc func handleDoubleTap(_ tap: UITapGestureRecognizer) {
        let photoView = currentPhotoView()
        let photo = photos?[currentIndex]
        if  photo?.isFinished == false {
            return
        }
        
        if (photoView.scrollView.zoomScale) > CGFloat(1.0) {
            photoView.scrollView.setZoomScale(1.0, animated: true)
            photo?.isZooming = false
            addPanGesture(true)
        } else {
            let location = tap.location(in: contentView)
            let wh: CGFloat = 1.0
            let zoomRect = frameWithWidth(wh, height: wh, center: location)
            
            photoView.zoomToRect(zoomRect, animated: true)
            photo?.isZooming = true
            photo?.zoomRect = zoomRect
            // 放大情况下移除滑动手势
            removePanGesture()
        }
    }
    
    @objc func handlePanGesture(_ tap: UIPanGestureRecognizer) {
        // 放大时候禁止滑动返回
        let photoView = currentPhotoView()
        if (photoView.scrollView.zoomScale) > CGFloat(1.0) {
            return
        }
        
        handlePanZoomScale(tap)
    }
    
    @objc func handleLongPress(_ tap: UILongPressGestureRecognizer) {
        switch tap.state {
        case .began:
            if isLongPressAutoSaveImageToAlbum == true {
                libraryAuthorization()
            } else {
                //代理回调
                deleagte?.photoBrowser(controller: self, longPress: currentIndex)
            }
            break
        case .ended:
            break
            
        default:
            break
        }
    }
    
    @objc func handleSingleTap(_ tap: UITapGestureRecognizer) {
        isDismissing = true
        //显示状态栏
        isStatusBarShow = true
        self.showDismissAnimation()
    }
}

// MARK: -  禁止屏幕旋转
extension DDPhotoBrowerController {
    override public var shouldAutorotate: Bool {
        return false
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    /// 隐藏状态栏
    override public var prefersStatusBarHidden: Bool {
        return !isStatusBarShow
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return previousStatusBarStyle
    }
}
