//
//  PhotoTableVC.swift
//  Example
//
//  Created by senyuhao on 2018/7/4.
//  Copyright © 2018年 dd01. All rights reserved.
//

import DDKit
import UIKit

class PhotoTableVC: UITableViewController {
    var images = [UIImage]()
    var items = ["SingleLocalPhoto",
                 "MutipleLocalPhotos",
                 "BrowserOnly",
                 "BrowserAndDelete",
                 "SingleOrginalPhoto",
                 "Camera",
                 "Camera origial",
                 "BrowserThenUpadte"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "图片相关"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") {
            cell.textLabel?.text = items[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
//            PhotoHelper.shared.chooseSingleLocalPhoto(basevc: self,
//                                                      handler: { [weak self] value in
//                print(value)
//                self?.images = value
//            },
//                                                      permission: {
//                print("无权限")
//            })
        } else if indexPath.row == 1 {
//            PhotoHelper.shared.rightItemTintColor = #colorLiteral(red: 0.9487375617, green: 0.4749935865, blue: 0.434479177, alpha: 1)
//            PhotoHelper.shared.chooseLocalPhotos(basevc: self,
//                                                 imagesCount: 3,
//                                                 handler: { [weak self] value in
//                                                    print(value)
//                                                    self?.images = value
//            },
//                                                 permission: {
//                print("无权限")
//            })
        } else if indexPath.row == 2 {
//            if !images.isEmpty {
//                let list: [PhotoAsset] = images.map { value -> PhotoAsset in
//                    PhotoAsset(image: value)
//                }
//                PhotoHelper.shared.browser(basevc: self, list: list, index: 0)
//            }
        } else if indexPath.row == 3 {
//            if !images.isEmpty {
//                let list: [PhotoAsset] = images.map { value -> PhotoAsset in
//                    PhotoAsset(image: value)
//                }
//                PhotoHelper.shared.browserThenDelete(basevc: self, list: list, index: 0) { value in
//                    print(value)
//                }
//            }
        } else if indexPath.row == 4 {
//            PhotoHelper.shared.chooseSingleOriginalPhoto(basevc: self,
//                                                         handler: { value in
//                                                            print(value)
//            },
//                                                         permission: {
//                                                            print("无权限")
//            })
        } else if indexPath.row == 5 {
//            PhotoHelper.shared.cameraOperation(basevc: self,
//                                               handler: { value in
//                                                print(value)
//            },
//                                               permission: {
//                                                print("无权限")
//            })
        } else if indexPath.row == 6 {
//            PhotoHelper.shared.cameraOriginalOperation(basevc: self,
//                                                       handler: { value in
//
//                                                        if let image = value.first {
//                                                            print(image)
//
//                                                            if let jpeg = UIImageJPEGRepresentation(image, 0.1),
//                                                                let jpegImage = UIImage(data: jpeg),
//                                                                let fix = jpegImage.fixOrientation() {
//                                                                if jpeg.count / 1_024 / 1_024 > 2 {
//                                                                    print("123")
//                                                                }
//                                                                print(fix)
//                                                                print(jpeg)
//                                                                self.images = [fix]
//                                                            }
//
////                                                            self.images = [temp]
//                                                        }
//            },
//                                                       permission: {
//
//            })
        } else if indexPath.row == 7 {
//            let item = UIBarButtonItem(title: "123", style: .plain, target: self, action: #selector(actionItem))
//            let list: [PhotoAsset] = images.map { value -> PhotoAsset in
//                PhotoAsset(image: value)
//            }
//            if !list.isEmpty {
//                PhotoHelper.shared.browserThenUpdate(basevc: self, asset: list[0], item: item) { _ in
//                    print("234")
//                }
//            } else {
//                print("控制")
//            }
        }
    }

    @objc private func actionItem() {
        if let window = UIApplication.shared.keyWindow {
            SheetTool.shared.show(value: (title: nil, message: "infomessage"), cancel: "取消", titles: ["2", "1"], target: window) { tag in
                print(tag)
            }
        }

    }
}
