//
//  ScanController.swift
//  Example
//
//  Created by USER on 2018/11/29.
//  Copyright © 2018 dd01. All rights reserved.
//

import UIKit
import DDKit

class ScanController: UIViewController {
    @IBOutlet weak var qrImageView: UIImageView!
    
    @IBOutlet weak var qr128ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func scanAction(_ sender: Any) {
        //请求授权
        DDScanPermissions.authorizeCamera {[weak self] (granted) in
            if granted == true {
                //方式 1 新建controller继承 DDScanViewController，建议使用第一种方式，在controller中方便做其他操作
                let vc = ScanSecondController()
                // DDScanStyleConfig中参数可任意修，选择默认，就不需要再创建 style
                let style = DDScanStyleConfig()
                vc.scanStyle = style
                self?.navigationController?.pushViewController(vc, animated: true)
                
                //方式 2 直接使用默认的扫描控制器，需要设置代理
                //                let vc2 = DDScanViewController()
                //                vc2.delegate = self
                //                self?.navigationController?.pushViewController(vc2, animated: true)
            }
        }
    }
    
    @IBAction func createQRAction(_ sender: Any) {
        //生成二维码
        qrImageView.image = DDScanWrapper.createQrCode(codeString: "WERWRwwer", size: qrImageView.bounds.size, qrColor: UIColor.black, backgroudColor: UIColor.white)
    }
    
    @IBAction func create128QRAction(_ sender: Any) {
        //生成条形码
        qr128ImageView.image = DDScanWrapper.createCode128(codeString: "sdfsdf", size: qr128ImageView.bounds.size, qrColor: UIColor.black, backgroudColor: UIColor.white)
    }
}

extension ScanController: DDScanViewControllerDelegate {
    func scanFinished(scanResult: DDScanResult?) {
//        print(scanResult?.strScanned )
    }
}
