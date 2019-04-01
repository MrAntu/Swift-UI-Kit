//
//  DDPhotoPickerBorwserController.swift
//  Photo
//
//  Created by USER on 2018/10/25.
//  Copyright © 2018年 leo. All rights reserved.
//

import UIKit
import Photos

enum DDPhotoPickerBorwserType: Int {
    case all
    case preview
}

class DDPhotoPickerBorwserController: UIViewController {
    
    /// 默认滚动下标
    public var currentIndex = 0
    //最大选择数量
    public var maxSelectedNumber: Int = Int.max
    //图片资源对象
    public var photoPickerSource: DDPhotoPickerSource? {
        didSet {
            photoCollectionView?.reloadData()
        }
    }
    //选择预览类型
    public var borwserType: DDPhotoPickerBorwserType = .all
    
    //导航view
    public lazy var navigationView = DDPhotoPickerNavigationView(frame: CGRect(x: 0, y: 0, width: DDPhotoScreenWidth, height: DDPhotoNavigationTotalHeight), leftBtnCallBack: { [weak self] in
            let orientation =  UIDevice.current.orientation
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                let value = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }, rightBtnCallBack: nil)

    public lazy var bottomView = DDPhotoPreviewBottomView(frame: CGRect.zero)
    
    public var photoCollectionView: UICollectionView?
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var scrollDistance: CGFloat = 0
    private var requestImageIDs = [PHImageRequestID]()
    //旋转之前index
    private var indexBeforeRotation: Int = 0
    private var isDrag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化旋转之前的index
        indexBeforeRotation = currentIndex
        //设置ui
        setupUI()
        //添加屏幕旋转通知
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationChanged(_:)), name: NSNotification.Name.UIApplicationWillChangeStatusBarOrientation, object: nil)
    }
    
    @objc func deviceOrientationChanged(_ notify: Notification) {
        isDrag = false
        indexBeforeRotation = currentIndex
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        //初始化导航栏标题
        changeNavigationTitle(currentIndex + 1)
        DDLandscapeManager.shared.isForceLandscape = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        photoCollectionView?.isScrollEnabled = true

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if DDPhotoStyleConfig.shared.navigationBarStyle == .default {
            return .default
        } else if DDPhotoStyleConfig.shared.navigationBarStyle == .black {
            return .lightContent
        }
        
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //设置gif播放，主要是防止第一次点击进来的图片是gif不播放的问题
        setCellGif()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DDLandscapeManager.shared.isForceLandscape = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        let screenHeight: CGFloat = UIScreen.main.bounds.size.height
        var inset = UIEdgeInsetsMake(20, 0, 0, 0);
        if #available(iOS 11.0, *) {
            inset = view.safeAreaInsets
        }
        navigationView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: inset.top + DDPhotoNavigationHeight)
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(DDPhotoPickerBottomViewHeight)
            make.bottom.equalTo(view.snp_bottomMargin)
        }
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.itemSize = CGSize(width: screenWidth + 10, height: screenHeight)
        photoCollectionView?.frame = CGRect(x: 0, y: 0, width: screenWidth + 10, height: screenHeight)
        
        //滚动cell
        if isDrag == false {
            photoCollectionView?.setContentOffset(CGPoint(x: Int(screenWidth + 10) * indexBeforeRotation, y: 0), animated: false)
        }
    }

    override func didMove(toParentViewController parent: UIViewController?) {
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

extension DDPhotoPickerBorwserController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        photoCollectionView?.isScrollEnabled = false
        return true
    }
}

extension DDPhotoPickerBorwserController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if borwserType == .preview {
            return photoPickerSource?.previewPhotosArr.count ?? 0
        }
        return photoPickerSource?.modelsArr.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //图片cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDPhotoPickerBorwserCell", for: indexPath) as? DDPhotoPickerBorwserCell {
            var model:DDPhotoGridCellModel? = photoPickerSource?.modelsArr[indexPath.row]
            if borwserType == .preview {
                model = photoPickerSource?.previewPhotosArr[indexPath.row]
            }
            cell.disPlayCell(model)
            cell.oneTapClosure = {[weak self] tap in
                self?.updateLayout()
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        var model:DDPhotoGridCellModel? = photoPickerSource?.modelsArr[indexPath.row]
        if borwserType == .preview {
            model = photoPickerSource?.previewPhotosArr[indexPath.row]
        }
        //设置原图
        setPreviewImage(cell: cell as? DDPhotoPickerBorwserCell, model: model)
        changeBottomStatus(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //重新改变cell的默认缩放
        (cell as? DDPhotoPickerBorwserCell)?.defaultScale = 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension DDPhotoPickerBorwserController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollDistance = scrollView.contentOffset.x
        isDrag = true
        //gif操作.停止播放gif
        var model: DDPhotoGridCellModel?
        if borwserType == .all {
            model = photoPickerSource?.modelsArr[currentIndex]
        } else {
            model = photoPickerSource?.previewPhotosArr[currentIndex]
        }
        
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
        if currentIndex >= photoPickerSource?.modelsArr.count ?? 0 {
            currentIndex = (photoPickerSource?.modelsArr.count ?? 0) - 1
        } else if currentIndex < 0 {
            currentIndex = 0
        }
        //改变导航栏标题
        changeNavigationTitle(currentIndex + 1)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isDrag = false
        //改变bottom状态
        changeBottomStatus(currentIndex)
        //gif操作.播放gif
        setCellGif()
    }
}

private extension DDPhotoPickerBorwserController {
    func setCellGif() {
        //gif操作.播放gif
        var model: DDPhotoGridCellModel?
        if borwserType == .all {
            model = photoPickerSource?.modelsArr[currentIndex]
        } else {
            model = photoPickerSource?.previewPhotosArr[currentIndex]
        }
        
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
            self.bottomView.isHidden = !self.bottomView.isHidden
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
        view.addSubview(bottomView)
        view.bringSubview(toFront: navigationView)
        view.bringSubview(toFront: bottomView)
        
        //回调
        bottomView.rightBtnCallBack = {[weak self] in
            let vc = self?.navigationController?.viewControllers.first as? DDPhotoPickerViewController
            //完成按钮
            if let completion = vc?.completion {
                completion(self?.photoPickerSource?.selectedPhotosArr ?? [])
            }
            vc?.dismiss(animated: true, completion: nil)
        }
        
        bottomView.leftBtnCallBack = {[weak self] in
            self?.isDrag = true
            self?.selectedBtnChangedCellModel(index: self?.currentIndex ?? 0)
        }
    }
    
    //选择按钮回调，改变model状态
    func selectedBtnChangedCellModel(index: Int) {
        if borwserType == .preview {
            photoPickerSource?.previewChangSelectedModel(index: index)
        } else {
            let model = photoPickerSource?.modelsArr[index]
            let selectedCount = photoPickerSource?.selectedPhotosArr.count ?? 0
            if selectedCount >= maxSelectedNumber {
                if model?.isSelected == true {
                    photoPickerSource?.selectedBtnChangedCellModel(index: index)
                    //更新bottom button状态
                    changeBottomStatus(index)
                    return
                }
                DDPhotoToast.showToast(msg: Bundle.localizedString("最多只能选择") + "\(maxSelectedNumber)" + Bundle.localizedString("张图片"))
                return
            }
            photoPickerSource?.selectedBtnChangedCellModel(index: index)
        }
        //更新bottom button状态
        changeBottomStatus(index)
    }
    
    func changeBottomStatus(_ index: Int) {
        
        var model:DDPhotoGridCellModel? = photoPickerSource?.modelsArr[index]
        if borwserType == .preview {
            model = photoPickerSource?.previewPhotosArr[index]
        }
        bottomView.changeSelectedBtnStatus(model?.isSelected,text: "\(model?.index ?? 0)")
        if borwserType == .preview {
            bottomView.changeCompleteBtnStatus(photoPickerSource?.selectedPhotosArr.count ?? 0, total:  photoPickerSource?.previewPhotosArr.count ?? 0)
        } else {
            bottomView.changeCompleteBtnStatus(photoPickerSource?.selectedPhotosArr.count ?? 0, total:0)
        }
    }
    
    func changeNavigationTitle(_ index: Int) {
        var text = "\(index)/\(photoPickerSource?.modelsArr.count ?? 0)"
        if borwserType == .preview {
            text = "\(index)/\(photoPickerSource?.previewPhotosArr.count ?? 0)"
        }
        navigationView.titleLabel.text = text
    }
}
