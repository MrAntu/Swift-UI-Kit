//
//  PlayerViewController.swift
//  Example
//
//  Created by USER on 2018/10/29.
//  Copyright © 2018年 dd01. All rights reserved.
//

import UIKit
import SnapKit
import DDKit

class PlayerViewController: UIViewController {

    var player = DDVideoPlayer()
    
    var isHidden:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
//        let url1 = URL(string: "https://ylmtst.yejingying.com/asset/video/20180525184959_mW8WVQVd.mp4")!
        
        let url = URL(string: "http://tb-video.bdstatic.com/videocp/12045395_f9f87b84aaf4ff1fee62742f2d39687f.mp4")!
        self.player.replaceVideo(url)
        self.player.isEnableLandscape = true
        
        //设置frame，请使用下面CGRect，暂时还没兼容Snapkit，后续改进
        //原因： 需要在init中获取displayView的frame。 Snapkit在初始化方法中不能获取
        self.player.displayView.frame = CGRect(x: 0, y: 64, width: DDVPScreenWidth, height: DDVPScreenWidth * (9.0/16.0))
        view.addSubview(self.player.displayView)
        //后台模式，关于前后台切换回来的播放模式
        self.player.backgroundMode = .proceed
        //横盘设置要显示的标题
        self.player.displayView.titleLabel.text = "DD01"
        //必须设置代理
        self.player.displayView.delegate = self
        //下面协议按需要是否实现
        //self.player.delegate = self
        
        
        //获取视屏首帧图片
        let imageView = UIImageView()
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 300, width: 100, height: 100)
        DDVideoPlayer.firstFrame(videoUrl: url, size: CGSize(width: 100, height: 100)) { (image) in
            imageView.image = image
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.play()
    }
    
    deinit {
        print(self)
    }
    
    //mark 下面三个方法必须要实现
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }
    
    override var prefersStatusBarHidden: Bool {
        return isHidden
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}

extension PlayerViewController: DDPlayerViewDelegate {
    
    //此协议必须实现才能隐藏导航栏
    func ddPlayerView(_ playerView: DDVideoPlayerView, willFullscreen isFullscreen: Bool, orientation: UIInterfaceOrientation) {
        if orientation == .portrait {
            isHidden = false
        } else {
            isHidden = true
        }
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}


