
//
//  DDPhotoVideoView.swift
//  PhotoDemo
//
//  Created by USER on 2018/11/19.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class DDPhotoVideoView: UIView {
    //隐藏预览图回调
    public var hiddenPreviewCallBack: ((_ isTap: Bool)->())?
    
    lazy private var playBtn: UIButton = {
        let playBtn = UIButton(type: .custom)
        if let path = Bundle(for: DDPhotoVideoView.classForCoder()).path(forResource: "DDPhotoPicker", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "video_btn_play_two", in: bundle, compatibleWith: nil)
        {
            playBtn.setImage(image, for: .normal)
        }
        playBtn.isEnabled = false
//        playBtn.addTarget(self, action: #selector(playBtnAction(_:)), for: .touchUpInside)
        return playBtn
    }()
    
    private var playLayer: AVPlayerLayer = AVPlayerLayer()
    private var player: AVPlayer?
    private var requestId: PHImageRequestID?
    lazy private var bottomView = DDPhotoVideoBottom()

    //监听player时间回调
    private var timeObserver: Any?
    private var playerItemStatus: AVPlayerItemStatus = .unknown

    var model: DDPhotoGridCellModel? {
        didSet {
            bringSubview(toFront: playBtn)
            playBtn.isHidden = false
            bottomView.isHidden = true
            reset()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playBtn.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        playBtn.center = center
        
        playLayer.frame = bounds
        
        var inset = UIEdgeInsetsMake(0, 0, 0, 0);
        if #available(iOS 11.0, *) {
            inset = safeAreaInsets
        }
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        let screenHeight: CGFloat = UIScreen.main.bounds.size.height
        
        bottomView.frame = CGRect(x: 0, y: screenHeight - inset.bottom - 50, width: screenWidth, height: 50)
    }
    
    deinit {
        print(self)
        reset()
    }
}

extension DDPhotoVideoView {
   public func play() {
        playBtn.isHidden = true
        bottomView.isHidden = false
        bringSubview(toFront: bottomView)
        player?.play()
        bottomView.changePlayBtnImage(true)
    }
    
   public func pause() {
        playBtn.isHidden = false
        bottomView.isHidden = true
        bringSubview(toFront: playBtn)
        player?.pause()
        bottomView.changePlayBtnImage(false)
    }
    
    public func reset() {
        playLayer.removeFromSuperlayer()
        player?.removeObserver(self, forKeyPath: "status")
        player?.removeTimeObserver(timeObserver as Any)
        NotificationCenter.default.removeObserver(self)
//        player?.pause()
        pause()
        player = nil
    }
    
    public func seekTime(_ time: TimeInterval, completion: ((Bool) -> Void)?) {
        if time.isNaN || playerItemStatus != .readyToPlay {
            if completion != nil {
                completion!(false)
            }
            return
        }
    
        DispatchQueue.main.async { [weak self]  in
            self?.pause()
            self?.player?.currentItem?.seek(to: CMTimeMakeWithSeconds(time, Int32(NSEC_PER_SEC)), completionHandler: { (finished) in
                DispatchQueue.main.async(execute: {
                    self?.play()
                    if let completion = completion {
                        completion(finished)
                    }
                })
            })
        }
    }
}

private extension DDPhotoVideoView {
    func setupUI() {
        addSubview(playBtn)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        addGestureRecognizer(tap)
        
        addSubview(bottomView)
        bottomView.videoView = self
    }

    /// 是否正在播放
    func isPlay() -> Bool {
        if (player?.rate ?? 0) > Float(0) {
            return true
        }
        return false
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(playFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:nil)
        
        let options = NSKeyValueObservingOptions([.new, .initial])
        player?.addObserver(self, forKeyPath: "status", options: options, context: nil)
        
        timeObserver = player?.addPeriodicTimeObserver(forInterval: .init(value: 1, timescale: 1), queue: DispatchQueue.main, using: { [weak self] time in
            if let currentTime = self?.player?.currentTime().seconds,
                let totalDuration = self?.player?.currentItem?.duration.seconds {
                self?.bottomView.playerDurationDidChange(currentTime, totalDuration: totalDuration)
            }
        })
    }
    
    func setHiddenPreviewCallBack(_ isTap: Bool) {
        if let callBack = hiddenPreviewCallBack {
            callBack(isPlay())
        }
    }
}

extension DDPhotoVideoView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: bottomView) == true {
            return false
        } else {
            return true
        }
    }
    
    @objc func playBtnAction(_ sender: UIButton?) {
        if isPlay() {
            pause()
            return
        }
        
        if player != nil {
            play()
            return
        }
        
        reset()
        if let id = requestId {
            if id > 0 {
                DDPhotoImageManager.default().cancelImageRequest(id)
            }
        }
        requestId = DDPhotoPickerSource.requesetAVPlayerItem(for: model) {[weak self] (playerItem) in
            DispatchQueue.main.async(execute: {
                guard let playerItem = playerItem else {
                    DDPhotoToast.showToast(msg: "加载失败")
                    return
                }
                
                let player = AVPlayer(playerItem: playerItem)
                
                if let playLayer = self?.playLayer {
                    self?.layer.addSublayer(playLayer)
                    self?.playLayer.player = player
                    self?.playLayer.videoGravity = .resizeAspectFill

                    self?.player = player
                    //添加通知，添加监听
                    self?.addNotification()
                    self?.play()
                }
                
            })
        }
    }
    
    @objc func tapGestureRecognizer(_ tap: UITapGestureRecognizer) {
        playBtnAction(nil)
        setHiddenPreviewCallBack(true)
    }
    
    @objc func playFinished() {
        playBtn.isHidden = false
        bottomView.isHidden = true
        bringSubview(toFront: playBtn)
        player?.seek(to: kCMTimeZero)
        setHiddenPreviewCallBack(true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let status: AVPlayerItemStatus
        if let statusNumber = change?[.newKey] as? NSNumber {
            status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
        } else {
            status = .unknown
        }
        playerItemStatus = status
        
        if status == .readyToPlay {
            setHiddenPreviewCallBack(true)
        }
    }
}


