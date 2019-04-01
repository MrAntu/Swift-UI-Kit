

//
//  ScanSecondController.swift
//  Example
//
//  Created by USER on 2018/11/29.
//  Copyright © 2018 dd01. All rights reserved.
//

import UIKit
import DDKit

class ScanSecondController: DDScanViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// 重写此回调方法即可
    ///
    /// - Parameter results: results
    override func handleCodeResult(results: [DDScanResult]?) {
        guard let arr = results else {
            return
        }
        
        //处理信息等待可以显示菊花
        showActivity()
        
        showMsg(title: "", message: arr.first?.strScanned)
    }
    
    func showMsg(title: String?, message: String?) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertAction.Style.default) {[weak self] (alertAction) in
            self?.hiddenActivity()
            self?.navigationController?.popViewController(animated: true)
            
        }
        
        let cancelAction = UIAlertAction(title: "重新扫描", style: .default) {[weak self] (action) in
            self?.hiddenActivity()
            self?.start()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
