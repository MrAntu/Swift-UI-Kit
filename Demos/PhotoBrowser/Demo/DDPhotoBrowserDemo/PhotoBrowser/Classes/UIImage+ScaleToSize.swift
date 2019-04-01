//
//  UIImage+ScaleToSize.swift
//  DDPhotoBrowserDemo
//
//  Created by USER on 2018/12/12.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

extension UIImage {
    func browserScaleToSize(size: CGSize) -> UIImage? {
     
//        UIGraphicsBeginImageContextWithOptions(size, false, scale); //此处将画布放大两倍，这样在retina屏截取时不会影响像素
        //
        //        // 得到图片上下文，指定绘制范围
        UIGraphicsBeginImageContext(size);
        // 将图片按照指定大小绘制
        self.draw(in: CGRect(x:0,y:0,width:size.width,height:size.height))
        // 从当前图片上下文中导出图片
        let img = UIGraphicsGetImageFromCurrentImageContext()
        // 当前图片上下文出栈
        UIGraphicsEndImageContext();
        // 返回新的改变大小后的图片
        return img
    }
    
    func browserImageFrame() -> CGSize {
        let frame = UIScreen.main.bounds

        let imageSize = self.size
        var imageF = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        
        // 图片的宽度 = 屏幕的宽度
        let ratio = frame.width / imageF.size.width
        imageF.size.width = frame.width
        imageF.size.height = ratio * imageF.size.height
        return imageF.size
    }
}
