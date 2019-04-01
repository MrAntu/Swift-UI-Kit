//
//  DDPhotoPickerTakePicCell.swift
//  PhotoDemo
//
//  Created by USER on 2018/11/29.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

class DDPhotoPickerTakePicCell: UICollectionViewCell {
    
    public var takePicCallBack: (()->())?
    
    private lazy var takePicBtn: UIButton = {
        let takePicBtn = UIButton(type: .custom)
        takePicBtn.setTitle(Bundle.localizedString("拍摄照片"), for: .normal)
        takePicBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        takePicBtn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 12)
        if let path = Bundle(for: DDPhotoPickerTakePicCell.classForCoder()).path(forResource: "DDPhotoPicker", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "list_icon_photo", in: bundle, compatibleWith: nil)
        {
            takePicBtn.setImage(image, for: .normal)
        }
        takePicBtn.addTarget(self, action: #selector(takePicAction), for: .touchUpInside)
        return takePicBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(takePicBtn)
        takePicBtn.frame = contentView.bounds
        takePicBtn.photoimagePositionTop()
        contentView.backgroundColor = UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func takePicAction() {
        takePicCallBack?()
    }
}

extension UIButton {
    func photoimagePositionTop () {
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
