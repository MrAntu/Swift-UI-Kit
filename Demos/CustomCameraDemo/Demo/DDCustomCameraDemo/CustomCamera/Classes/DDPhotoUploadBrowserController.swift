//
//  DDPhotoUploadBrowserController.swift
//  DDCustomCameraDemo
//
//  Created by USER on 2018/12/7.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import Photos

class DDPhotoUploadBrowserController: UIViewController {

    /// 默认滚动下标
    public var currentIndex = 0
    //最大选择数量
    public var maxSelectedNumber: Int = Int.max
    //数据源
    public var photoArr: [DDPhotoGridCellModel]? {
        didSet {
            photoCollectionView?.reloadData()
        }
    }
    
    //导航view
    public lazy var navigationView = DDPhotoPickerNavigationView(frame: CGRect(x: 0, y: 0, width: DDPhotoScreenWidth, height: DDPhotoNavigationTotalHeight), leftBtnCallBack: { [weak self] in
        let orientation =  UIDevice.current.orientation
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        } else {
            if self?.navigationController == nil {
                self?.dismiss(animated: true, completion: nil)
                return
            }
            self?.navigationController?.popViewController(animated: true)
        }
        }, rightBtnCallBack: nil)
    
    
    private var photoCollectionView: UICollectionView?
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var scrollDistance: CGFloat = 0
    private var requestImageIDs = [PHImageRequestID]()
    //旋转之前index
    private var indexBeforeRotation: Int = 0
    private var isDrag: Bool = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        //初始化旋转之前的index
        indexBeforeRotation = currentIndex
        //设置ui
        setupUI()
        //添加屏幕旋转通知
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationChanged(_:)), name: NSNotification.Name.UIApplicationWillChangeStatusBarOrientation, object: nil)
    }
    
    @objc func deviceOrientationChanged(_ notify: Notification) {
        indexBeforeRotation = currentIndex
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //一定要放在viewWillAppear中，否则会偶尔导致手势失效
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: animated)
        //初始化导航栏标题
        changeNavigationTitle(currentIndex + 1)
        DDLandscapeManager.shared.isForceLandscape = true
        photoCollectionView?.isScrollEnabled = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //设置gif播放，主要是防止第一次点击进来的图片是gif不播放的问题
        setCellGif()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        DDLandscapeManager.shared.isForceLandscape = false
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        let screenHeight: CGFloat = UIScreen.main.bounds.size.height
        var inset = UIEdgeInsetsMake(20, 0, 0, 0);
        if #available(iOS 11.0, *) {
            inset = view.safeAreaInsets
        }
        navigationView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: inset.top + DDPhotoNavigationHeight)
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.itemSize = CGSize(width: screenWidth + 10, height: screenHeight)
        photoCollectionView?.frame = CGRect(x: 0, y: 0, width: screenWidth + 10, height: screenHeight)
        
        //滚动cell
        if isDrag == false {
            photoCollectionView?.setContentOffset(CGPoint(x: Int(screenWidth + 10) * indexBeforeRotation, y: 0), animated: false)
        }
    }
    
    override public func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        //如果dismiss就取消所有在下载的图片
        if parent == nil {
            for id in requestImageIDs {
                DDPhotoImageManager.default().cancelImageRequest(id)
            }
        }
    }
    
    deinit {
        DDPhotoImageManager.default().removeAllCache()
        NotificationCenter.default.removeObserver(self)
        print(self)
    }
}

extension DDPhotoUploadBrowserController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return photoArr?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //图片cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDPhotoPickerBorwserCell", for: indexPath) as? DDPhotoPickerBorwserCell {
            let model:DDPhotoGridCellModel? = photoArr?[indexPath.row]
            cell.type = .uploadBrowser
            cell.disPlayCell(model)
            cell.oneTapClosure = {[weak self] tap in
                self?.updateLayout()
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let model:DDPhotoGridCellModel? = photoArr?[indexPath.row]
       
        //设置原图
        setPreviewImage(cell: cell as? DDPhotoPickerBorwserCell, model: model)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //重新改变cell的默认缩放
        (cell as? DDPhotoPickerBorwserCell)?.defaultScale = 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension DDPhotoUploadBrowserController: UIScrollViewDelegate {
     func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollDistance = scrollView.contentOffset.x
        isDrag = true
        //gif操作.停止播放gif
        let model: DDPhotoGridCellModel? = photoArr?[currentIndex]
        
        if model?.isGIF == true {
            let currentCell = photoCollectionView?.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? DDPhotoPickerBorwserCell
            currentCell?.photoImages?.removeAll()
            currentCell?.photoImageView.stopAnimating()
            //每次都清除所有的cache，否则内存过大，后续再优化是否需要本地持久缓存
            DDPhotoImageManager.default().removeAllCache()
            return
        }
        
        //如果视屏，停止播放视屏
        if model?.type == .video {
            let currentCell = photoCollectionView?.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? DDPhotoPickerBorwserCell
            currentCell?.videoView.pause()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(round(scrollView.contentOffset.x/scrollView.bounds.width))
        if currentIndex >= photoArr?.count ?? 0 {
            currentIndex = (photoArr?.count ?? 0) - 1
        } else if currentIndex < 0 {
            currentIndex = 0
        }
        //改变导航栏标题
        changeNavigationTitle(currentIndex + 1)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isDrag = false
        //gif操作.播放gif
        setCellGif()
    }
}

private extension DDPhotoUploadBrowserController {
    func setCellGif() {
        //gif操作.播放gif
        let model: DDPhotoGridCellModel? = photoArr?[currentIndex]
    
        if model?.isGIF == false { return }
        
        let currentCell = photoCollectionView?.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? DDPhotoPickerBorwserCell
        guard let localIdentifier = model?.localIdentifier,
            let images = DDPhotoImageManager.default().getImagesCache(localIdentifier),
            let duration = DDPhotoImageManager.default().getImagesDurationCache(localIdentifier) else {
                return
        }
        currentCell?.photoImages = images
        currentCell?.photoImageView.stopAnimating()
        currentCell?.animationDuration = duration
    }
    
    func updateLayout() {
        UIView.animate(withDuration: 0.25) {
            self.navigationView.isHidden = !self.navigationView.isHidden
        }
    }
    
    func setPreviewImage(cell: DDPhotoPickerBorwserCell?, model: DDPhotoGridCellModel?) {
        cell?.setPreviewImage(model)
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.black
        //添加 navigationview
        view.addSubview(navigationView)
        
        //add collectionView
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: DDPhotoScreenWidth + 10, height: DDPhotoScreenHeight)
        photoCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: DDPhotoScreenWidth + 10, height: DDPhotoScreenHeight), collectionViewLayout: flowLayout)
        if let photoCollectionView = photoCollectionView {
            photoCollectionView.isPagingEnabled = true
            photoCollectionView.register(DDPhotoPickerBorwserCell.self,
                                         forCellWithReuseIdentifier: "DDPhotoPickerBorwserCell")
            photoCollectionView.delegate = self
            photoCollectionView.dataSource = self
            view.addSubview(photoCollectionView)
            if #available(iOS 11.0, *) {
                photoCollectionView.contentInsetAdjustmentBehavior = .never
            } else {
                automaticallyAdjustsScrollViewInsets = false
            }
        }
        
        //添加底部bottom
        view.bringSubview(toFront: navigationView)
    }
    
    func changeNavigationTitle(_ index: Int) {
        let text = "\(index)/\(photoArr?.count ?? 0)"
        navigationView.titleLabel.text = text
    }
}

extension DDPhotoUploadBrowserController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        photoCollectionView?.isScrollEnabled = false
        return true
    }
}
