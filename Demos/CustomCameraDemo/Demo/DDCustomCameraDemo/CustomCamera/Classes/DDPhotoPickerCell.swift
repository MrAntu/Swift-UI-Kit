//
//  DDPhotoPickerCell.swift
//  Photo
//
//  Created by USER on 2018/10/24.
//  Copyright © 2018年 leo. All rights reserved.
//

import UIKit
import Photos

class DDPhotoPickerCell: UICollectionViewCell {
    
    private var requestId: PHImageRequestID?
    
    private lazy var selectCircle: UILabel = {
        let selectCircle = UILabel()
        selectCircle.layer.borderWidth = 1
        selectCircle.layer.borderColor = UIColor.white.cgColor
        selectCircle.layer.backgroundColor = normalBackBtnColor.cgColor
        selectCircle.layer.cornerRadius = 11
        selectCircle.layer.masksToBounds = true
        selectCircle.isUserInteractionEnabled = true
        selectCircle.textColor = UIColor.white
        selectCircle.font = UIFont.systemFont(ofSize: 13)
        selectCircle.textAlignment = .center
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        selectCircle.addGestureRecognizer(tap)
        return selectCircle
    }()
    
    private lazy var gifLab: UILabel = {
        let gifLab = UILabel()
        gifLab.textColor = UIColor.white
        gifLab.font = UIFont.systemFont(ofSize: 13)
        gifLab.text = "GIF"
        gifLab.textAlignment = .center
        return gifLab
    }()
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.contentView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var VideoImageView: UIImageView = {
        let VideoImageView = UIImageView()
        VideoImageView.contentMode = .scaleAspectFill
        if let path = Bundle(for: DDPhotoPickerCell.classForCoder()).path(forResource: "DDPhotoPicker", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "zl_video", in: bundle, compatibleWith: nil)
        {
            VideoImageView.image = image
        }
        return VideoImageView
    }()
    
    lazy var durationLab: UILabel = {
        let durationLab = UILabel()
        durationLab.textColor = UIColor.white
        durationLab.font = UIFont.systemFont(ofSize: 13)
        durationLab.textAlignment = .right
        return durationLab
    }()
    
    //当前cell的indexpath
    private var indexPath: IndexPath?

    //model
    private var model: DDPhotoGridCellModel?
    
    private var selectButtonCallBack: ((_ indexPath: IndexPath) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoImageView)
        contentView.addSubview(selectCircle)
        contentView.addSubview(gifLab)
        contentView.addSubview(VideoImageView)
        contentView.addSubview(durationLab)
        selectCircle.snp.makeConstraints { (make) in
            make.width.height.equalTo(22)
            make.right.equalTo(self.snp.right).offset(-3)
            make.top.equalTo(self.snp.top).offset(3)
        }
        gifLab.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(contentView)
        }
        VideoImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(7)
            make.bottom.equalTo(contentView).offset(-7)
            make.width.equalTo(16)
            make.height.equalTo(12)
        }
        durationLab.snp.makeConstraints { (make) in
            make.left.equalTo(VideoImageView.snp.right).offset(12)
            make.right.equalTo(contentView).offset(-5)
            make.centerY.equalTo(VideoImageView.snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DDPhotoPickerCell {
    public func displayCellWithModel(model: DDPhotoGridCellModel, indexPath: IndexPath, selectedCallBack:@escaping (_ indexPath: IndexPath)->()) {
        self.indexPath = indexPath
        selectButtonCallBack = selectedCallBack
        self.model = model
        gifLab.isHidden = true
        VideoImageView.isHidden = true
        durationLab.isHidden = true

        if model.type == .gif {
            gifLab.isHidden = false
        } else if model.type == .video {
            VideoImageView.isHidden = false
            durationLab.isHidden = false
            durationLab.text = model.duration
        }
        //设置按钮背景图片
        changeSelectCircle(model.isSelected, text: "\(model.index)")
        if let id = requestId {
            if id > 0 {
                DDPhotoImageManager.default().cancelImageRequest(id)
            }
        }
        requestId =  DDPhotoPickerSource.imageFromPHImageManager(model) {[weak self] (image) in
            self?.photoImageView.image = image
        }
    }
    
    public func changeSelectCircle(_ res: Bool? = false, text: String? = "") {
        if res == true {
            if let color = DDPhotoStyleConfig.shared.seletedImageCircleColor {
                selectCircle.layer.borderColor = color.cgColor
                selectCircle.layer.backgroundColor = color.cgColor
            } else {
                selectCircle.layer.borderColor = selectedBackBtnColor.cgColor
                selectCircle.layer.backgroundColor = selectedBackBtnColor.cgColor
            }
            selectCircle.text = text
        } else {
            selectCircle.layer.borderColor = UIColor.white.cgColor
            selectCircle.layer.backgroundColor = normalBackBtnColor.cgColor
            selectCircle.text = ""
        }
    }
}

private extension DDPhotoPickerCell {
    @objc func tapGesture(_ tap: UIGestureRecognizer) {
        if let callBack = selectButtonCallBack,
            let indexPath = indexPath {
            callBack(indexPath)
        }
    }
}
