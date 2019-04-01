//
//  PhotoBrowserVideoView.swift
//  DDPhotoBrowserDemo
//
//  Created by weiwei.li on 2019/1/23.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

enum PlayerState: Int {
    case none            // default
    case playing
    case paused
    case playFinished
    case error
}

enum PlayerBufferstate: Int {
    case none           // default
    case readyToPlay
    case buffering
    case stop
    case bufferFinished
}

class PhotoBrowserVideoView: UIView {
    lazy private var playBtn: UIButton = {
        let playBtn = UIButton(type: .custom)
        if let path = Bundle(for: PhotoBrowserVideoView.classForCoder()).path(forResource: "DDPhotoBrowser", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "video_btn_play_two", in: bundle, compatibleWith: nil)
        {
            playBtn.setImage(image, for: .normal)
        }
        playBtn.addTarget(self, action: #selector(playBtnAction(_:)), for: .touchUpInside)
        return playBtn
    }()
    
    private var playLayer: AVPlayerLayer = AVPlayerLayer()
    private var player: AVPlayer?
    private var playerAsset : AVURLAsset?
    private var playerItem : AVPlayerItem? {
        willSet {
            removePlayerItemObservers()
            removePlayerNotifations()
        }
        didSet {
            addPlayerItemObservers()
            addPlayerNotifications()
        }
    }
    lazy private var bottomView = PhotoBrowserVideoBottom()
    private lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activityView.center = CGPoint(x: UIScreen.main.bounds.width / 2.0, y:  UIScreen.main.bounds.height / 2.0)
        activityView.style = .whiteLarge
        return activityView
    }()
    //监听player时间回调
    private var timeObserver: Any?
    private var playerItemStatus: AVPlayerItem.Status = .unknown
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.delegate = self
        return tap
    }()
    
    lazy private var closeBtn: UIButton = {
        let closeBtn = UIButton(type: .custom)
        if let path = Bundle(for: PhotoBrowserVideoBottom.classForCoder()).path(forResource: "DDPhotoBrowser", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "arrow", in: bundle, compatibleWith: nil) {
            closeBtn.setImage(image, for: .normal)
        }
        closeBtn.addTarget(self, action: #selector(closeBtnAction), for: .touchUpInside)
        return closeBtn
    }()
    //当前播放状态
    var state: PlayerState = .none {
        didSet {
            if state != oldValue {
                if state == .playFinished {
                    activityView.isHidden = true
                    activityView.stopAnimating()
                }
            }
        }
    }
    //当前缓冲状态
    var bufferState : PlayerBufferstate = .none {
        didSet {
            if bufferState != oldValue {
                if bufferState == .buffering || bufferState == .stop {
                    activityView.isHidden = false
                    activityView.startAnimating()
                } else {
                    activityView.isHidden = true
                    activityView.stopAnimating()
                }
            }
        }
    }
    
    var photo: DDPhoto? {
        didSet {
            playBtn.isHidden = false
            photoImageView.isHidden = false
            photoImageView.image = photo?.sourceImageView?.image
            bottomView.isHidden = false
            closeBtn.isHidden = false
            addGestureRecognizer(tap)
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
        photoImageView.frame = bounds
        
        playLayer.frame = bounds
        
        var inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        if #available(iOS 11.0, *) {
            inset = safeAreaInsets
        }
        
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        let screenHeight: CGFloat = UIScreen.main.bounds.size.height
        bottomView.frame = CGRect(x: 0, y: screenHeight - inset.bottom - 50, width: screenWidth, height: 50)
        
        closeBtn.frame = CGRect(x: 10, y: inset.top + 10, width: 20, height: 20)
    }
    
    deinit {
        print(self)
        reset()
    }
}


extension PhotoBrowserVideoView {
    public func play() {
        playBtn.isHidden = true
        bringSubviewToFront(bottomView)
        photoImageView.isHidden = true
        player?.play()
        bottomView.isHidden = false
        closeBtn.isHidden = false
        bottomView.changePlayBtnImage(true)
    }
    
    public func pause() {
//        playBtn.isHidden = false
//        bringSubview(toFront: playBtn)
        state = .paused
        player?.pause()
        bottomView.changePlayBtnImage(false)
    }
    
    public func reset() {
        pause()
        playLayer.removeFromSuperlayer()
        player?.removeTimeObserver(timeObserver as Any)
        playerAsset?.cancelLoading()
        playerAsset = nil
        playerItem?.cancelPendingSeeks()
        playerItem = nil
        NotificationCenter.default.removeObserver(self)
        player = nil
        bottomView.playerDurationDidChange(0, totalDuration: 0)
        
        removePlayerNotifations()
        removePlayerItemObservers()
        
        playBtn.isHidden = false
        photoImageView.isHidden = false
        bottomView.isHidden = true
        closeBtn.isHidden = false
    }
    
    /// 是否正在播放
    func isPlay() -> Bool {
        if (player?.rate ?? 0) > Float(0) {
            return true
        }
        return false
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
            self?.player?.currentItem?.seek(to: CMTimeMakeWithSeconds(time, preferredTimescale: Int32(NSEC_PER_SEC)), completionHandler: { (finished) in
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

private extension PhotoBrowserVideoView {
    func addPlayerItemObservers() {
        let options = NSKeyValueObservingOptions([.new, .initial])
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: options, context: nil)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: options, context: nil)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.playbackBufferEmpty), options: options, context: nil)
    }
    
    func addPlayerNotifications() {
        NotificationCenter.default.addObserver(self, selector: .pbPlayerItemDidPlayToEndTime, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: .pbApplicationWillEnterForeground, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: .pbApplicationDidEnterBackground, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func removePlayerItemObservers() {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.playbackBufferEmpty))
    }
    
    func removePlayerNotifations() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func setupUI() {
        addSubview(photoImageView)
        addSubview(playBtn)
        addSubview(bottomView)
        addSubview(activityView)
        bottomView.videoView = self
        activityView.isHidden = true
        activityView.stopAnimating()
        bringSubviewToFront(playBtn)
        addSubview(closeBtn)
    }
    
    func addNotification() {
        timeObserver = player?.addPeriodicTimeObserver(forInterval: .init(value: 1, timescale: 1), queue: DispatchQueue.main, using: { [weak self] time in
            if let currentTime = self?.player?.currentTime().seconds,
                let totalDuration = self?.player?.currentItem?.duration.seconds {
                self?.bottomView.playerDurationDidChange(currentTime, totalDuration: totalDuration)
            }
        })
    }
    
}

extension PhotoBrowserVideoView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: bottomView) == true {
            return false
        } else {
            return true
        }
    }
    
    @objc func closeBtnAction() {
        NotificationCenter.default.post(name: NSNotification.Name("PhotoBrowserVideoViewCloseKey"), object: nil)
    }
    
    @objc func playBtnAction(_ sender: UIButton?) {
        photoImageView.isHidden = true
        if isPlay() {
            pause()
            return
        }
        
        if player != nil {
            play()
            return
        }
        guard let url = photo?.url else {
            return
        }
        reset()
        
        let playerAssetTmp = AVURLAsset(url: url, options: .none)
        playerAsset = playerAssetTmp
        
        let keys = ["tracks", "playable"];
        playerItem = AVPlayerItem(asset: playerAssetTmp, automaticallyLoadedAssetKeys: keys)
        
        player = AVPlayer(playerItem: playerItem)
        
        layer.addSublayer(playLayer)
        playLayer.player = player
        playLayer.videoGravity = .resizeAspect
        
        //添加通知，添加监听
        addNotification()
        play()
    }
    
    @objc func tapGestureRecognizer(_ tap: UITapGestureRecognizer) {
        bottomView.isHidden = !bottomView.isHidden
        closeBtn.isHidden = !closeBtn.isHidden
    }
    
    @objc func playFinished() {
        playBtn.isHidden = false
        bringSubviewToFront(playBtn)
        activityView.isHidden = true
        activityView.stopAnimating()
        photoImageView.isHidden = false
        bottomView.isHidden = true
        
        bringSubviewToFront(playBtn)
        player?.seek(to: CMTime.zero)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            switch status {
            case .unknown:
                pause()
                bufferState = .buffering
            case .readyToPlay:
                bufferState = .readyToPlay
            case .failed:
                state = .error
                bufferState = .stop
            }
            
            playerItemStatus = status

            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.playbackBufferEmpty){
            if let playbackBufferEmpty = change?[.newKey] as? Bool {
                if playbackBufferEmpty {
                   pause()
                   bufferState = .buffering
                }
            }
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.loadedTimeRanges) {
            // 计算缓冲
            let loadedTimeRanges = player?.currentItem?.loadedTimeRanges
            if let bufferTimeRange = loadedTimeRanges?.first?.timeRangeValue {
                let star = bufferTimeRange.start.seconds         // The start time of the time range.
                let duration = bufferTimeRange.duration.seconds  // The duration of the time range.
                let bufferTime = star + duration
                
                if let itemDuration = playerItem?.duration.seconds {
                    if itemDuration == bufferTime {
                        bufferState = .bufferFinished
                    }
                }
                if let currentTime = playerItem?.currentTime().seconds{
                    if (bufferTime - currentTime) >= 2.0 && state != .paused {
                        play()
                    }
                    
                    if (bufferTime - currentTime) < 2.0 {
                        bufferState = .buffering
                    } else {
                        bufferState = .readyToPlay
                    }
                }
                return
            }
            //播放
            play()
        }
    }
}

//MARK--- Notification callBack
extension PhotoBrowserVideoView {
    @objc internal func playerItemDidPlayToEnd(_ notification: Notification) {
        if state != .playFinished {
            state = .playFinished
        }
        playFinished()
    }
    
    @objc internal func applicationWillEnterForeground(_ notification: Notification) {
        pause()
    }
    
    @objc internal func applicationDidEnterBackground(_ notification: Notification) {
        pause()
    }
}

// MARK: - Selecter
extension Selector {
    static let pbPlayerItemDidPlayToEndTime = #selector(PhotoBrowserVideoView.playerItemDidPlayToEnd(_:))
    static let pbApplicationWillEnterForeground = #selector(PhotoBrowserVideoView.applicationWillEnterForeground(_:))
    static let pbApplicationDidEnterBackground = #selector(PhotoBrowserVideoView.applicationDidEnterBackground(_:))
}


