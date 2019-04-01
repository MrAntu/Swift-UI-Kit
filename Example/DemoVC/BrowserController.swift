//
//  BrowserController.swift
//  Example
//
//  Created by USER on 2018/11/26.
//  Copyright © 2018 dd01. All rights reserved.
//

import UIKit
import DDKit
import Kingfisher

class BrowserController: UIViewController {
    
    let imageViewA = UIImageView()
    let imageViewB = UIImageView()
    let imageViewC = UIImageView()
    let imageViewD = UIImageView()
    
    let imageViewE = UIImageView()
    let imageViewF = UIImageView()
    
    var browser: DDPhotoBrower?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    func setupUI() {
        imageViewA.isUserInteractionEnabled = true
        imageViewB.isUserInteractionEnabled = true
        imageViewC.isUserInteractionEnabled = true
        imageViewD.isUserInteractionEnabled = true
        
        imageViewE.isUserInteractionEnabled = true
        imageViewF.isUserInteractionEnabled = true

        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tagAGesture))
        imageViewA.addGestureRecognizer(tap1)
        
        view.addSubview(imageViewA)
        view.addSubview(imageViewB)
        view.addSubview(imageViewC)
        view.addSubview(imageViewD)
        
        view.addSubview(imageViewE)
        view.addSubview(imageViewF)

        
        imageViewA.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(100)
            make.width.height.equalTo(80)
        }
        
        imageViewB.snp.makeConstraints { (make) in
            make.left.equalTo(imageViewA.snp.right).offset(20)
            make.top.equalTo(100)
            make.width.height.equalTo(80)
        }
        
        imageViewC.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(imageViewA.snp.bottom).offset(20)
            make.width.height.equalTo(80)
        }

        imageViewD.snp.makeConstraints { (make) in
            make.left.equalTo(imageViewC.snp.right).offset(20)
            make.top.equalTo(imageViewB.snp.bottom).offset(20)
            make.width.height.equalTo(80)
        }
        
        imageViewE.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(imageViewC.snp.bottom).offset(20)
            make.width.height.equalTo(80)
        }
        
        imageViewF.snp.makeConstraints { (make) in
            make.left.equalTo(imageViewE.snp.right).offset(20)
            make.top.equalTo(imageViewD.snp.bottom).offset(20)
            make.width.height.equalTo(80)
        }
        
        
        
//        let url1 = URL(string: "https://i2.hoopchina.com.cn/hupuapp/bbs/180015943752119/thread_180015943752119_20181123173449_s_5063176_w_357_h_345_28251.gif")
        let url1 =  URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1533056077048&di=e67f672075c673e6ffaa0625564133e7&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201406%2F12%2F20140612211118_YYXAC.jpeg")
        imageViewA.kf.setImage(with: url1)
        
        let url2 = URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1533056077048&di=e67f672075c673e6ffaa0625564133e7&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201406%2F12%2F20140612211118_YYXAC.jpeg")
        imageViewB.kf.setImage(with: url2)
    
        
        let url3 = URL(string: "http://img1.mydrivers.com/img/20171008/s_da7893ed38074cbc994e0ff3d85adeb5.jpg")
        imageViewC.kf.setImage(with: url3)
        
        let url4 = URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1533056728983&di=0377ea3d0ef5acdefe8863c1657a67f4&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01e90159a5094ba801211d25bec351.jpg")
        imageViewD.kf.setImage(with: url4)
        
        
        let url5 = URL(string: "https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=2908508425,3257588227&fm=173&s=F1925395C88BA20F313898C3030040B3&w=100&h=100&img.JPEG")
        imageViewE.kf.setImage(with: url5)
        
        let url6 = URL(string: "https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=137597753,3924281842&fm=173&s=E109D719483A6B9EB6ACCD5E0300F030&w=100&h=100&img.JPEG")
        imageViewF.kf.setImage(with: url6)
        
        imageViewA.contentMode = .scaleAspectFit
        imageViewB.contentMode = .scaleAspectFit
        imageViewC.contentMode = .scaleAspectFit
        imageViewD.contentMode = .scaleAspectFit
        imageViewF.contentMode = .scaleAspectFit

    }
    
    @objc func tagAGesture() {
        
        print("tagAGesture")
        var photos = [DDPhoto]()
        
        let photo1 = DDPhoto()
//        https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=925649403,644817718&fm=173&s=B084DF15C2206D1DCAA9504B0300E010&w=640&h=1058&img.JPEG
//        photo1.url = URL(string: "https://i2.hoopchina.com.cn/hupuapp/bbs/180015943752119/thread_180015943752119_20181123173449_s_5063176_w_357_h_345_28251.gif")
        photo1.url =  URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1533056077048&di=e67f672075c673e6ffaa0625564133e7&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201406%2F12%2F20140612211118_YYXAC.jpeg")

        photo1.sourceImageView = imageViewA
        
        let photo2 = DDPhoto()
        photo2.url = URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1533056077048&di=e67f672075c673e6ffaa0625564133e7&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201406%2F12%2F20140612211118_YYXAC.jpeg")
        photo2.sourceImageView = imageViewB
        
        let photo3 = DDPhoto()
        photo3.url = URL(string: "http://img1.mydrivers.com/img/20171008/s_da7893ed38074cbc994e0ff3d85adeb5.jpg")
        photo3.sourceImageView = imageViewC
        
        let photo4 = DDPhoto()
        photo4.url = URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1533056728983&di=0377ea3d0ef5acdefe8863c1657a67f4&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01e90159a5094ba801211d25bec351.jpg")
        photo4.sourceImageView = imageViewD
        
        let photo5 = DDPhoto()
        photo5.url = URL(string: "https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=2908508425,3257588227&fm=173&s=F1925395C88BA20F313898C3030040B3&w=640&h=1000&img.JPEG")
        
        let photo6 = DDPhoto()
        photo6.url = URL(string: "https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=137597753,3924281842&fm=173&s=E109D719483A6B9EB6ACCD5E0300F030&w=640&h=1000&img.JPEG")
        
        photos.append(photo1)
        photos.append(photo2)
        photos.append(photo3)
        photos.append(photo4)
        photos.append(photo5)
        photos.append(photo6)

        browser = DDPhotoBrower.photoBrowser(Photos: photos, currentIndex: 0)
        browser?.delegate = self
        browser?.show()
    }
    
}

extension BrowserController: DDPhotoBrowerDelegate {
    func photoBrowser(controller: UIViewController?, didChanged index: Int?) {
//        print(controller)
    }
    
    func photoBrowser(controller: UIViewController?, willDismiss index: Int?) {
//        print(controller)

    }
    
    func photoBrowser(controller: UIViewController?, longPress index: Int?) {
//        print(controller)

    }
}
