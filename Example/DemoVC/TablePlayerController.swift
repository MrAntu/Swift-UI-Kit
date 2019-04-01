//
//  TablePlayerController.swift
//  Example
//
//  Created by USER on 2018/11/14.
//  Copyright © 2018 dd01. All rights reserved.
//

import UIKit
import DDKit
import SnapKit

class TablePlayerController: UIViewController {
    var player = DDVideoPlayer()
    var currentPlayIndexPath : IndexPath?
    var isHidden:Bool = false
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        
        tableView.register(PlayeCell.self, forCellReuseIdentifier: "PlayeCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
        
        let options = NSKeyValueObservingOptions([.new, .initial])
        tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentOffset), options: options, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    
    deinit {
        player.cleanPlayer()
        tableView.removeObserver(self, forKeyPath: #keyPath(UITableView.contentOffset))
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }
    
    override var prefersStatusBarHidden: Bool {
        return isHidden
    }
    
}

extension TablePlayerController {
    //kvo 目的是滚动table的时候。当前播放cell不可见，就自动移除播放，
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(UITableView.contentOffset) {
            if let playIndexPath = currentPlayIndexPath {
                if let cell = tableView.cellForRow(at: playIndexPath) {
                    if player.displayView.isFullScreen { return }
                    let visibleCells = tableView.visibleCells
                    if visibleCells.contains(cell) {
                    } else {
                        player.cleanPlayer()
                        player.displayView.removeFromSuperview()
                    }
                    
                } else {
                    player.cleanPlayer()
                    player.displayView.removeFromSuperview()
                }
            }
        }
    }
}


extension TablePlayerController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "PlayeCell") as! PlayeCell)
        cell.playBtn.setTitle("播放\(indexPath.row)", for: .normal)
        cell.indexPath = indexPath
        cell.playBtnCallBack = {[weak self] (cell, index) in
            self?.setPlayer(cell, indexPath: index)
        }
        return cell
    }
    
    func setPlayer(_ cell: PlayeCell?, indexPath: IndexPath?) {
        currentPlayIndexPath = indexPath
        player.cleanPlayer()
        
        let url = URL(string: "http://tb-video.bdstatic.com/videocp/12045395_f9f87b84aaf4ff1fee62742f2d39687f.mp4")!
        self.player.replaceVideo(url)
        self.player.backgroundMode = .proceed
        //tableCell竖屏播放是否执行定时器自动隐藏播放界面的底部栏
        self.player.isHiddenCellPlayBottomBar = false

        //横屏设置要显示的标题
        self.player.displayView.titleLabel.text = "DD01"
        self.player.displayView.delegate = self
        cell?.containerView.addSubview(self.player.displayView)
        self.player.displayView.frame = cell?.contentView.bounds ?? CGRect.zero
        self.player.play()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TablePlayerController: DDPlayerViewDelegate {
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

