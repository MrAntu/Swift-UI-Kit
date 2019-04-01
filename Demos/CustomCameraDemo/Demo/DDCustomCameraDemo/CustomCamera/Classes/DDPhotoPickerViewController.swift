//
//  DDPhotoPickerViewController.swift
//  Photo
//
//  Created by USER on 2018/10/24.
//  Copyright © 2018年 leo. All rights reserved.
//

import UIKit
import Photos
import SnapKit
private let cellIdentifier = "PhotoCollectionCell"

public enum DDPhotoPickerAssetType: Int {
    case imageOnly
    case videoOnly
    case all
}

class DDPhotoPickerViewController: UIViewController {
    private var currentFetchResult: PHFetchResult<PHAsset>?

    private lazy var bottomView = DDPhotoPickerBottomView(frame: CGRect.zero, leftBtnCallBack: {[weak self] in
        //预览按钮
        if self?.photoPickerSource.selectedPhotosArr.count == 0 {
            DDPhotoToast.showToast(msg: Bundle.localizedString("请选择图片预览"))
            return
        }
        self?.gotoBorwserVC(.preview, index: 0)
    }) { [weak self] in
        //完成按钮
        if let completion = self?.completion {
            completion(self?.photoPickerSource.selectedPhotosArr ?? [])
        }
        
        if self?.isFromDDCustomCameraPresent == true {
            var vc: UIViewController? = self
            while(vc?.presentingViewController != nil) {
                vc = vc?.presentingViewController
            }
            vc?.dismiss(animated: true, completion: nil)
            return
        }
        
        self?.dismiss(animated: true, completion: nil)
    }
    
    //为了适配iphonex以上机型，下边空白问题
    private let bottomContainer = UIView(frame: CGRect.zero)
    
    private lazy var photoCollectionView: UICollectionView = { [weak self] in
        // 竖屏时每行显示4张图片
        let shape: CGFloat = 3
        let cellWidth: CGFloat = (DDPhotoScreenWidth - 5 * shape) / 4
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: DDPhotoNavigationTotalHeight, left: shape, bottom: DDPhotoHomeBarHeight, right: shape)
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.minimumLineSpacing = shape
        flowLayout.minimumInteritemSpacing = shape
        //  collectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)

        collectionView.backgroundColor = UIColor.white
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: DDPhotoNavigationTotalHeight, left: 0, bottom: DDPhotoHomeBarHeight, right: 0)
        //  添加协议方法
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true //数量不够一个屏幕时能够拖拽
        //  设置 cell
        collectionView.register(DDPhotoPickerCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(DDPhotoPickerTakePicCell.self,
                                     forCellWithReuseIdentifier: "DDPhotoPickerTakePicCell")
        return collectionView
    }()
    
    //数据源
    private lazy var photoPickerSource = DDPhotoPickerSource()
    //选择相册类型
    public var photoAssetType:DDPhotoPickerAssetType = .all
    //最大选择数量
    public var maxSelectedNumber: Int = 1
    //完成回调
    public var completion: ((_ selectedArr: [DDPhotoGridCellModel]) -> ())?
    //当前对象是否是从DDCustomCamera present呈现
    public var isFromDDCustomCameraPresent: Bool = false
    //是否支持录制视屏
    public var isEnableRecordVideo: Bool = true
    //是否支持拍照
    public var isEnableTakePhoto: Bool = true
    //最大录制时长
    public var maxRecordDuration: Int = 15
    //是否获取限制区域中的图片
    public var isShowClipperView: Bool = false
    
    private let cameraManager = DDCustomCameraManager()

    //构造方法
    public init(assetType: DDPhotoPickerAssetType, maxSelectedNumber: Int, completion: @escaping (_ selectedArr: [DDPhotoGridCellModel]?) -> ()) {
        super.init(nibName: nil, bundle: nil)
        self.maxSelectedNumber = maxSelectedNumber
        self.completion = completion
        photoAssetType = assetType
        loadLibraryData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //监控相册的变化
        PHPhotoLibrary.shared().register(self)
        
        //添加右滑手势
        let screenEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenHanlePan(pan:)))
        screenEdgePan.edges = .left
        view.addGestureRecognizer(screenEdgePan)
        
//        navigationController?.navigationBar.barStyle = .black
    }
    
    @objc func screenHanlePan(pan: UIPanGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var inset = UIEdgeInsetsMake(0, 0, 0, 0);
        if #available(iOS 11.0, *) {
            inset = view.safeAreaInsets
        }
        bottomContainer.backgroundColor = UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1)
        bottomContainer.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(DDPhotoPickerBottomViewHeight + inset.bottom)
            make.bottom.equalTo(view)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(bottomContainer)
            make.right.equalTo(bottomContainer)
            make.height.equalTo(DDPhotoPickerBottomViewHeight)
            make.top.equalTo(bottomContainer)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DDLandscapeManager.shared.isForceLandscape = false
        navigationController?.setNavigationBarHidden(false, animated: false)
        photoCollectionView.reloadData()
        //更新bottom button状态
        bottomView.didChangeButtonStatus(count: photoPickerSource.selectedPhotosArr.count)
    }
}

//MARK -- PHPhotoLibraryChangeObserver
extension DDPhotoPickerViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let currentFetchResult = currentFetchResult,
            let collectionChanges = changeInstance.changeDetails(for: currentFetchResult) else {
            return
        }
        
        DispatchQueue.main.async {
            //重新设置数据源
            let fetchAssets = collectionChanges.fetchResultAfterChanges
            self.currentFetchResult = fetchAssets
            //将所有PHAsset存入数据源
            let tmpPHAssets = fetchAssets.objects(at: IndexSet.init(integersIn: 0..<fetchAssets.count))
            //设置cell数据源
            self.setAllCellModel(assets: tmpPHAssets)
            //刷新collection
            self.reloadCollectionView()
        }
    }
}

//MARK --- UICollectionViewDelegate & UICollectionViewDataSource
extension DDPhotoPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoPickerSource.modelsArr.count + 1
    }
    
    private func takePic() {
        if isFromDDCustomCameraPresent == true {
           dismiss(animated: true, completion: nil)
            return
        }
        cameraManager.isFromDDPhotoPickerPresent = true
        cameraManager.presentCameraController()
        cameraManager.completionBack = {[weak self] (arr) in
            let result = arr?.map({ (model) -> DDPhotoGridCellModel in
                guard let asset = model.asset else {
                    return DDPhotoGridCellModel(asset: PHAsset(), type: .unknown, duration: "")
                }

                var type:DDAssetMediaType = .unknown
                switch asset.mediaType {
                    case .unknown:
                        type = .unknown
                    case .image:
                        type = .image
                    case .video:
                        type = .video
                    default:
                        type = .unknown
                }
                let cellModel = DDPhotoGridCellModel(asset: asset, type: type, duration: model.duration ?? "")
                cellModel.image = model.image
                return cellModel
            })
            
            self?.completion?(result ?? [])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //  设置拍照cell
        if indexPath.row >= photoPickerSource.modelsArr.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDPhotoPickerTakePicCell", for: indexPath) as! DDPhotoPickerTakePicCell
            cell.takePicCallBack = {[weak self] in
                self?.takePic()
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! DDPhotoPickerCell
        cell.displayCellWithModel(model: photoPickerSource.modelsArr[indexPath.row], indexPath: indexPath) {[weak self] (index: IndexPath) in
            //大于规定选中的数量，不能选中
            let selectedCount = self?.photoPickerSource.selectedPhotosArr.count ?? 9
            let maxCount = self?.maxSelectedNumber ?? Int.max
            let cellModel = self?.photoPickerSource.modelsArr[index.row]
        
            //1.如果数量大于最大，且没有选中的图片，就不能选中。
            if (selectedCount >= maxCount){
                //2. 如果数量大于最大，当前图片是选中状态，需要改变状态
                if cellModel?.isSelected == true {
                    self?.selectedBtnChangedCellModel(indexPath: index)
                    self?.photoCollectionView.reloadData()
                    return
                }
                DDPhotoToast.showToast(msg: Bundle.localizedString("最多只能选择") + "\(maxCount)" + Bundle.localizedString("张图片"))
                return
            }
            self?.selectedBtnChangedCellModel(indexPath: index)
            self?.photoCollectionView.reloadData()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= photoPickerSource.modelsArr.count {
            return
        }
        gotoBorwserVC(.all, index: indexPath.row)
    }
}

//MARK --- private method
private extension DDPhotoPickerViewController {
    /// 跳转预览控制器
    ///
    /// - Parameter type: 选择类型
    func gotoBorwserVC(_ type: DDPhotoPickerBorwserType, index: Int) {
        let vc = DDPhotoPickerBorwserController()
        if type == .preview {
            //预览时初始化预览数组
            photoPickerSource.getPreviewPhotosArr()
        }
        vc.photoPickerSource = photoPickerSource
        vc.currentIndex = index
        vc.borwserType = type
        vc.maxSelectedNumber = maxSelectedNumber
        navigationController?.pushViewController(vc, animated: true)
    }
    //选中按钮回调，改变model状态
    func selectedBtnChangedCellModel(indexPath: IndexPath) {
        photoPickerSource.selectedBtnChangedCellModel(index: indexPath.row)
        //更新bottom button状态
        bottomView.didChangeButtonStatus(count: photoPickerSource.selectedPhotosArr.count)
    }
    
    //加载所有的图片资源
    func loadLibraryData() {
        //获取相册授权状态
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .restricted || status == .denied {
            dismiss(animated: true, completion: nil)
            return
        }
        DispatchQueue.global(qos: .userInteractive).async {
            //获取所有系统图片信息集合体
            let allOptions = PHFetchOptions()
            allOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
            if self.photoAssetType == .imageOnly {
                allOptions.predicate = NSPredicate(format: "mediaType == %d",  Int8(PHAssetMediaType.image.rawValue))
            } else if self.photoAssetType == .videoOnly {
                allOptions.predicate = NSPredicate(format: "mediaType == %d",  Int8(PHAssetMediaType.video.rawValue))
            }
//            else if self.photoAssetType == .audioOnly {
//                allOptions.predicate = NSPredicate(format: "mediaType == %d",  Int8(PHAssetMediaType.audio.rawValue))
//            }
            //将集合拆散开
            let fetchAssets = PHAsset.fetchAssets(with: allOptions)
            self.currentFetchResult = fetchAssets
            //将所有PHAsset存入数据源
            let tmpPHAssets = fetchAssets.objects(at: IndexSet.init(integersIn: 0..<fetchAssets.count))
            //设置cell数据源
            self.setAllCellModel(assets: tmpPHAssets)
            //刷新collection
            self.reloadCollectionView()
        }
    }
    
    //设置所有cell数据源
    func setAllCellModel(assets: [PHAsset]) {
        //清除所有数据
        photoPickerSource.modelsArr.removeAll()
        photoPickerSource.previewPhotosArr.removeAll()
        photoPickerSource.selectedPhotosArr.removeAll()
        //遍历创建数据
        _ = assets.map({  [weak self] (asset) -> Void in
            let type = DDPhotoImageManager.transformAssetType(asset)
            let duratiom = DDPhotoImageManager.getVideoDuration(asset)
            let model = DDPhotoGridCellModel(asset: asset, type: type, duration: duratiom)
            self?.photoPickerSource.modelsArr.append(model)
        })
    }
    
    //reload collection
    func reloadCollectionView() {
        DispatchQueue.main.async {
            //初始化底部栏状态
            self.bottomView.didChangeButtonStatus(count: 0)
            self.photoCollectionView.reloadData()
            //默认滚动到最后
            if self.photoPickerSource.modelsArr.count == 0 {
                return
            }
            let index = self.photoPickerSource.modelsArr.count - 1
            self.photoCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredVertically, animated: false)
        }
    }
    
    func setLeftBtnItem() {
        let btn = UIButton(type: .custom)
        btn.bounds = CGRect(x: 0, y: 0, width: 30, height: 21)
        if let image = DDPhotoStyleConfig.shared.navigationBackImage {
            btn.setImage(image, for: .normal)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        } else {
            if let path = Bundle(for: DDPhotoPickerViewController.classForCoder()).path(forResource: "DDPhotoPicker", ofType: "bundle"),
                let bundle = Bundle(path: path),
                let image = UIImage(named: "photo_nav_icon_back_black", in: bundle, compatibleWith: nil)
            {
                btn.setImage(image, for: .normal)
                btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
            }
        }
        
        btn.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    @objc func leftBtnAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        title = Bundle.localizedString("图片")
        //设置返回按钮
        setLeftBtnItem()
        
        //添加cellectionview
        view.addSubview(photoCollectionView)
        //添加bottom
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(bottomView)
        
        photoCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.bottomView.snp.top).offset(-5)
        }
        
        if #available(iOS 11.0, *) {
            photoCollectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}
