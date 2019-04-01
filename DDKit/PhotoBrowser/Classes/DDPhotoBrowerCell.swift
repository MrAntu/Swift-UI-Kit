//
//  DDPhotoBrowerCell.swift
//  DDPhotoBrowserDemo
//
//  Created by USER on 2018/12/12.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

class DDPhotoBrowerCell: UICollectionViewCell {
    public let photoView = DDPhotoView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(photoView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = contentView.bounds
        rect.size.width = rect.width - 10
        photoView.frame = rect
        photoView.resetFrame()
    }
    
    deinit {
        photoView.removeFromSuperview()
    }
    
    func browserZoomShow(_ photo: DDPhoto?) {
        guard let photo = photo else {
            return
        }
        if photo.image != nil {
            photoView.setupPhoto(photo)
        } else {
            let imgSize = photo.sourceImageView?.image?.browserImageFrame() ?? CGSize.zero
            photoView.imageView.image = (photo.placeholderImage != nil) ? photo.placeholderImage : photo.sourceImageView?.image?.browserScaleToSize(size: imgSize)
//            photoView.adjustFrame()
//            photoView.imageView.image = (photo.placeholderImage != nil) ? photo.placeholderImage : photo.sourceImageView?.image
            photoView.adjustFrame(photo: photo)
        }
        
        let endRect = photoView.imageView.frame
        
        var sourceRect = photo.sourceFrame
        
        if sourceRect?.equalTo(CGRect.zero) == true || sourceRect == nil {
            sourceRect = photo.sourceImageView?.superview?.convert(photo.sourceImageView?.frame ?? CGRect.zero, to: (browserViewController() as? DDPhotoBrowerController)?.contentView)
        }
        
        photoView.imageView.frame = sourceRect ?? CGRect.zero
        UIView.animate(withDuration: 0.2, animations: {
            self.photoView.imageView.frame = endRect
        }) { (finished) in
            self.photoView.setupPhoto(photo)
            if photo.isVideo == true {
                let screenWidth: CGFloat = UIScreen.main.bounds.size.width
                let screenHeight: CGFloat = UIScreen.main.bounds.size.height
                self.photoView.videoView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                self.photoView.videoView.playBtnAction(nil)
                photo.isFirstPhoto = false
                self.photoView.videoView.setNeedsLayout()
                self.photoView.videoView.layoutIfNeeded()
            }
        }
    }
}

extension UIView {
    func browserViewController () -> UIViewController? {
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




