
//
//  DDVideoPlayer.swift
//  mpdemo
//
//  Created by leo on 2018/10/30.
//  Copyright © 2018年 dd01.leo. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire
public class DDVideoPlayer: NSObject {
    //播放视图
    public var displayView : DDVideoPlayerView
    //gravity设置
    public var gravityMode : DDVideoGravityMode = .resize
    //后台播放模式
    public var backgroundMode : DDPlayerBackgroundMode = .autoPlayAndPaused
    //buffer time
    public var bufferInterval : TimeInterval = 2.0
    //设置代理回调
    public weak var delegate : DDVideoPlayerDelegate?
    //文件格式
    public var mediaFormat : DDVideoPlayerMediaFormat
    //视屏总时长
    public var totalDuration : TimeInterval = 0.0
    //当前播放时长
    public var currentDuration : TimeInterval = 0.0
    //当前播放url
    public var contentURL : URL?
    //网络监测
    private let reachabilityManager = NetworkReachabilityManager()
    //是否自动触发横屏
    public var isEnableLandscape = false
    //tableCells竖屏播放是否执行定时器自动隐藏播放界面的底部栏
    public var isHiddenCellPlayBottomBar = true
    //player
    public var player : AVPlayer? {
        willSet{
            removePlayerObservers()
        }
        didSet {
            addPlayerObservers()
        }
    }
    //是否在缓冲
    public var buffering : Bool = false
    //监听player时间回调
    private var timeObserver: Any?
    //playerItem
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
    //playerAsset
    private var playerAsset : AVURLAsset?
    //错误信息
    private var error : DDVideoPlayerError
    //是否在seek
    private var seeking : Bool = false
    //当前播放状态
    public var state: DDPlayerState = .none {
        didSet {
            if state != oldValue {
                self.displayView.playStateDidChange(state)
                self.delegate?.ddPlayer(self, stateDidChange: state)
            }
        }
    }
    //当前缓冲状态
    public var bufferState : DDPlayerBufferstate = .none {
        didSet {
            if bufferState != oldValue {
                self.displayView.bufferStateDidChange(bufferState)
                self.delegate?.ddPlayer(self, bufferStateDidChange: bufferState)
            }
        }
    }
    
    //MARK:- life cycle
    public init(URL: URL?, playerView: DDVideoPlayerView?) {
        mediaFormat = DDVideoPlayerUtils.decoderVideoFormat(URL)
        contentURL = URL
        error = DDVideoPlayerError()
        if let view = playerView {
            displayView = view
        } else {
            displayView = DDVideoPlayerView()
        }
        super.init()
        if contentURL != nil {
            configurationPlayer(contentURL!)
        }
        
        //必须要加，否则真机插拔耳机会没声音
        if #available(iOS 10.0, *) {
            let _ = try?
                AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        }
    }
    
    public convenience init(URL: URL) {
        self.init(URL: URL, playerView: nil)
    }
    
    public convenience init(playerView: DDVideoPlayerView) {
        self.init(URL: nil, playerView: playerView)
    }
    
    public override convenience init() {
        self.init(URL: nil, playerView: nil)
    }
    
    deinit {
        removePlayerNotifations()
        cleanPlayer()
        displayView.removeFromSuperview()
        reachabilityManager?.stopListening()
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - public
extension DDVideoPlayer {
    public func replaceVideo(_ URL: URL?) {
        guard let url = URL else {
            return
        }
        contentURL = url
        reloadPlayer()
        mediaFormat = DDVideoPlayerUtils.decoderVideoFormat(url)
        configurationPlayer(url)
    }
    
    public func play() {
        if contentURL == nil { return }
        player?.play()
        state = .playing
        displayView.play()
        initializeReachability()
    }
    
   public func cleanPlayer() {
        player?.pause()
        player?.cancelPendingPrerolls()
        player?.replaceCurrentItem(with: nil)
        player = nil
        playerAsset?.cancelLoading()
        playerAsset = nil
        playerItem?.cancelPendingSeeks()
        playerItem = nil
    }
    
    public func isPlay() -> Bool {
        if player?.rate != 0 {
            return true
        }
        return false
    }
    
    public func pause() {
        guard state == .paused else {
            player?.pause()
            state = .paused
            displayView.pause()
            return
        }
    }
    
    public func seekTime(_ time: TimeInterval) {
        seekTime(time, completion: nil)
    }
    
    public func seekTime(_ time: TimeInterval, completion: ((Bool) -> Void)?) {
        if time.isNaN || playerItem?.status != .readyToPlay {
            if completion != nil {
                completion!(false)
            }
            return
        }
        
        DispatchQueue.main.async { [weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.seeking = true
            strongSelf.startPlayerBuffering()
            strongSelf.playerItem?.seek(to: CMTimeMakeWithSeconds(time, preferredTimescale: Int32(NSEC_PER_SEC)), completionHandler: { (finished) in
                DispatchQueue.main.async {
                    strongSelf.seeking = false
                    strongSelf.stopPlayerBuffering()
                    strongSelf.play()
                    if completion != nil {
                        completion!(finished)
                    }
                }
            })
        }
    }
}

//MARK: - private
private extension DDVideoPlayer {
    func initializeReachability() {
        reachabilityManager?.listener = {[weak self] status in
            var statusStr: String = ""
            var isWifi = false
            switch status {
            case .unknown:
                statusStr = "未识别的网络"
                isWifi = true
                break
            case .notReachable:
                statusStr = "不可用的网络(未连接)"
                isWifi = true
            case .reachable:
                if self?.reachabilityManager?.isReachableOnWWAN == true {
                    statusStr = "2G,3G,4G...的网络"
                    isWifi = false
                } else if self?.reachabilityManager?.isReachableOnEthernetOrWiFi == true {
                    statusStr = "wifi的网络";
                    isWifi = true
                }
                break
            }
            
            if isWifi == false && self?.displayView.isAllowNotWifiPlay == false {
                self?.displayView.showNoWifiTipView()
                self?.cleanPlayer()
            }
            print(statusStr)
        }
        reachabilityManager?.startListening()
    }
    
    func configurationPlayer(_ URL: URL?) {
        guard let URL = URL else {
            return
        }
       
        self.displayView.setddPlayer(ddPlayer: self)
        self.playerAsset = AVURLAsset(url: URL, options: .none)
        let keys = ["tracks", "playable"];
        playerItem = AVPlayerItem(asset: playerAsset!, automaticallyLoadedAssetKeys: keys)
        
        player = AVPlayer(playerItem: playerItem)
        displayView.reloadPlayerView()
    }
    
    func reloadPlayer() {
        seeking = false
        totalDuration = 0.0
        currentDuration = 0.0
        error = DDVideoPlayerError()
        state = .none
        buffering = false
        bufferState = .none
        cleanPlayer()
    }
    
    func startPlayerBuffering() {
        pause()
        bufferState = .buffering
        buffering = true
    }
    
    func stopPlayerBuffering() {
        bufferState = .stop
        buffering = false
    }
    
    func collectPlayerErrorLogEvent() {
        error.playerItemErrorLogEvent = playerItem?.errorLog()?.events
        error.error = playerItem?.error
        error.extendedLogData = playerItem?.errorLog()?.extendedLogData()
        error.extendedLogDataStringEncoding = playerItem?.errorLog()?.extendedLogDataStringEncoding
    }
}

//MARK: - Notifation & KVO
private var playerItemContext = 0
private extension DDVideoPlayer {
    // time KVO
    func addPlayerObservers() {
        timeObserver = player?.addPeriodicTimeObserver(forInterval: .init(value: 1, timescale: 1), queue: DispatchQueue.main, using: { [weak self] time in
            guard let strongSelf = self else { return }
            if let currentTime = strongSelf.player?.currentTime().seconds, let totalDuration = strongSelf.player?.currentItem?.duration.seconds {
                strongSelf.currentDuration = currentTime
                strongSelf.delegate?.ddPlayer(strongSelf, playerDurationDidChange: currentTime, totalDuration: totalDuration)
                strongSelf.displayView.playerDurationDidChange(currentTime, totalDuration: totalDuration)
            }
        })
    }
    
    func removePlayerObservers() {
        player?.removeTimeObserver(timeObserver!)
    }
    
    func addPlayerItemObservers() {
        let options = NSKeyValueObservingOptions([.new, .initial])
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: options, context: &playerItemContext)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: options, context: &playerItemContext)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.playbackBufferEmpty), options: options, context: &playerItemContext)
    }
    
    func addPlayerNotifications() {
        NotificationCenter.default.addObserver(self, selector: .playerItemDidPlayToEndTime, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: .applicationWillEnterForeground, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: .applicationDidEnterBackground, name: UIApplication.didEnterBackgroundNotification, object: nil)
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
}

//MARK--- Notification callBack
extension DDVideoPlayer {
    @objc internal func handleDeviceOrientationChange(_ notification: Notification) {
      
    }
    
    @objc internal func playerItemDidPlayToEnd(_ notification: Notification) {
        if state != .playFinished {
            state = .playFinished
        }
    }
    
    @objc internal func applicationWillEnterForeground(_ notification: Notification) {
        if let playerLayer = displayView.playerLayer  {
            playerLayer.player = player
        }
        
        switch self.backgroundMode {
        case .suspend:
            pause()
        case .autoPlayAndPaused:
            play()
        case .proceed:
            break
        }
    }
    
    @objc internal func applicationDidEnterBackground(_ notification: Notification) {
        if let playerLayer = displayView.playerLayer  {
            playerLayer.player = nil
        }
        
        switch self.backgroundMode {
        case .suspend:
            pause()
        case .autoPlayAndPaused:
            pause()
        case .proceed:
            play()
            break
        }
    }
}

//MARK ---- KVO回调
extension DDVideoPlayer {
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (context != &playerItemContext) {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            switch status {
            case .unknown:
                startPlayerBuffering()
            case .readyToPlay:
                bufferState = .readyToPlay
            case .failed:
                state = .error
                collectPlayerErrorLogEvent()
                stopPlayerBuffering()
                delegate?.ddPlayer(self, playerFailed: error)
                displayView.playFailed(error)
            }
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.playbackBufferEmpty){
            if let playbackBufferEmpty = change?[.newKey] as? Bool {
                if playbackBufferEmpty {
                    startPlayerBuffering()
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
                    delegate?.ddPlayer(self, bufferedDidChange: bufferTime, totalDuration: itemDuration)
                    displayView.bufferedDidChange(bufferTime, totalDuration: itemDuration)
                    totalDuration = itemDuration
                    if itemDuration == bufferTime {
                        bufferState = .bufferFinished
                    }
                }
                if let currentTime = playerItem?.currentTime().seconds{
                    if (bufferTime - currentTime) >= bufferInterval && state != .paused {
                        play()
                    }
                    
                    if (bufferTime - currentTime) < bufferInterval {
                        bufferState = .buffering
                        buffering = true
                    } else {
                        buffering = false
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

// MARK: - Selecter
extension Selector {
    static let playerItemDidPlayToEndTime = #selector(DDVideoPlayer.playerItemDidPlayToEnd(_:))
    static let applicationWillEnterForeground = #selector(DDVideoPlayer.applicationWillEnterForeground(_:))
    static let applicationDidEnterBackground = #selector(DDVideoPlayer.applicationDidEnterBackground(_:))
    static let handleDeviceOrientationChange = #selector(DDVideoPlayer.handleDeviceOrientationChange(_:))
}

extension DDVideoPlayer {
    
    /// 通过url获取视屏首帧图片
    ///
    /// - Parameters:
    ///   - url: url
    ///   - size: size
    /// - Returns: image
    public static func firstFrame(videoUrl url: URL?, size: CGSize, completion:@escaping (UIImage?)->()) {
        guard let url = url  else {
            completion(nil)
            return
        }
        
        DispatchQueue.global().async {
            let opts = [AVURLAssetPreferPreciseDurationAndTimingKey: false]
            let urlAsset = AVURLAsset(url: url, options: opts)
            let genarator = AVAssetImageGenerator(asset: urlAsset)
            genarator.appliesPreferredTrackTransform = true
            genarator.maximumSize = CGSize(width: size.width, height: size.height)
            let img = try? genarator.copyCGImage(at: CMTimeMake(value: 0, timescale: 10), actualTime: nil)
            DispatchQueue.main.async(execute: {
                if let image = img {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
     
    }
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
