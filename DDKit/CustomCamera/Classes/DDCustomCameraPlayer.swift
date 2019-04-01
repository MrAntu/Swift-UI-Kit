

//
//  DDCustomCameraPlayer.swift
//  DDCustomCamera
//
//  Created by USER on 2018/11/16.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import AVFoundation

class DDCustomCameraPlayer: UIView {
    
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?

    public var videoUrl: URL? {
        didSet {
            setPlayVideoUrl(videoUrl)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        player?.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        player = nil
    }
}

extension DDCustomCameraPlayer {
    
    /// 播放
    func play() {
        player?.play()
    }
    
    /// 暂停
    func pause() {
        player?.pause()
    }
    
    /// 重置
    func reset() {
        player?.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        player = nil
    }
    
    /// 是否正在播放
    func isPlay() -> Bool {
        if (player?.rate ?? 0) > Float(0) {
            return true
        }
        return false
    }
}

private extension DDCustomCameraPlayer {
    
    func setPlayVideoUrl(_ url:URL?) {
        guard let url = url else {
            return
        }
        
        player = AVPlayer(url: url)
        if #available(iOS 10.0, *) {
            player?.automaticallyWaitsToMinimizeStalling = false
        }
        
        //kvo
//        _ = player?.observe(\.status, options: [.initial, .old, .new], changeHandler: {[weak self] (player, change) in
//            print(change)
//            player.status
//            if change.newValue == .readyToPlay {
//                UIView.animate(withDuration: 0.25, animations: {
//                    self?.alpha = 1
//                })
//            }
//        })
        let options = NSKeyValueObservingOptions([.new, .initial])
        player?.addObserver(self, forKeyPath: "status", options: options, context: nil)
        
        //通知
        NotificationCenter.default.addObserver(self, selector: #selector(playFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        playerLayer?.player = player
        playerLayer?.videoGravity = .resizeAspect
    }
    
    func setupUI() {
        backgroundColor = UIColor.black
        alpha = 0
        playerLayer = AVPlayerLayer()
        playerLayer?.frame = bounds
        if let tempLayer = playerLayer {
            layer.addSublayer(tempLayer)
        }
    }
}

extension DDCustomCameraPlayer {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let status: AVPlayerItem.Status
        if let statusNumber = change?[.newKey] as? NSNumber {
            status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
        } else {
            status = .unknown
        }
        
        if status == .readyToPlay {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 1
            })
        }
    }
    @objc func playFinished() {
        player?.seek(to: CMTime.zero)
        player?.play()
    }
}
