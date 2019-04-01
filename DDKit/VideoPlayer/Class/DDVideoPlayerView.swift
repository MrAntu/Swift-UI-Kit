//
//  DDVideoPlayerView.swift
//  mpdemo
//
//  Created by leo on 2018/10/30.
//  Copyright © 2018年 dd01.leo. All rights reserved.
//

import UIKit
import MediaPlayer
import SnapKit

//屏幕旋转动画时长
private let duration = 0.25

open class DDVideoPlayerView: UIView {
    weak public var ddPlayer : DDVideoPlayer?
    //控制视图显示时长
    private var controlViewDuration : TimeInterval = 5.0  /// default 5.0
    //player Layer
    public var playerLayer : AVPlayerLayer?
    //是否全屏
    public var isFullScreen : Bool = false {
        didSet {
            if isFullScreen == false {
                removaPanGesture()
            } else {
                addPanGesture()
            }
        }
    }
    //是否拖拽进度条
    private var isTimeSliding : Bool = false
    //是否允许非wifi播放
    public var isAllowNotWifiPlay : Bool = false
    //是否显示控制视图
    public var isDisplayControl : Bool = true {
        didSet {
            if isDisplayControl != oldValue {
                delegate?.ddPlayerView(didDisplayControl: self)
            }
        }
    }
    //播放视图delegate
    public weak var delegate : DDPlayerViewDelegate?
    // top view
    lazy private var topView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }()
    
    //titleLabel
    lazy public var titleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        return label
    }()
    
    //返回按钮
    lazy private var closeButton : UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    // bottom view
    lazy private var bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }()
    
    //亮度显示
    lazy private var brightnessView: DDPlayerBrightnessView = {
       let brightnessView = DDPlayerBrightnessView()
        return brightnessView
    }()
    
    //时间lable
    private var timeLabel : UILabel =  {
        let timeLabel = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        timeLabel.font = UIFont.systemFont(ofSize: 12.0)
        timeLabel.text = "00:00"
        return timeLabel
    }()
    
    private var currentLab : UILabel =  {
        let currentLab = UILabel()
        currentLab.textAlignment = .center
        currentLab.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        currentLab.font = UIFont.systemFont(ofSize: 12.0)
        currentLab.text = "00:00"
        return currentLab
    }()
    
    //加载失败按钮
    lazy private var failedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        button.isHidden = true
        button.setTitle("加载失败,点击重试", for: .normal)
        return button
    }()
    
    //非wifi提示视图
    lazy private var wifiTipsView = DDVideoPlayerTipsView()
    //进度条slider
    lazy private var timeSlider = DDVideoPlayerSlider ()
    //加载显示圈
    private var loadingIndicator = DDVideoPlayerLoadingIndicator()
    //全屏按钮
    private var fullscreenButton : UIButton = UIButton(type: .custom)
    //播放按钮
    private var playButtion : UIButton = UIButton(type: .custom)
    //中间播放按钮
    private var centerPlayButtion : UIButton = UIButton(type: .custom)
    //声音控制显示图
    private var volumeSlider : UISlider!
    //重新播放按钮
    private var replayButton : UIButton = UIButton(type: .custom)
    //手势
    private var panGestureDirection : DDPlayerViewPanGestureDirection = .horizontal
    //是否是调节声音,false为亮度调节
    private var isVolume : Bool = false
    //进度条滑动值
    private var sliderSeekTimeValue : TimeInterval = .nan
    //定时器
    private var timer : Timer = {
        let time = Timer()
        return time
    }()
    //父视图
    private weak var parentView : UIView?
    //父视图frame
    private var viewFrame = CGRect.zero
    // GestureRecognizer
    private var singleTapGesture = UITapGestureRecognizer()
    private var doubleTapGesture = UITapGestureRecognizer()
    private var panGesture: UIPanGestureRecognizer? = UIPanGestureRecognizer()
   
    //MARK:- life cycle
    public override init(frame: CGRect) {
        self.playerLayer = AVPlayerLayer(player: nil)
        super.init(frame: frame)
        viewFrame = frame
        addDeviceOrientationNotifications()
        addGestureRecognizer()
        configurationVolumeSlider()
        configurationUI()
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer.invalidate()
        playerLayer?.removeFromSuperlayer()
        NotificationCenter.default.removeObserver(self)
        brightnessView.removeFromSuperview()
        print(self)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
        
        setupSubViewsFrame()
//        if isFullScreen && DDVPIsiPhoneX.isIphonex() == true {
//        }
    }
}

private extension DDVideoPlayerView {
    /// 添加屏幕旋转通知
    func addDeviceOrientationNotifications() {
        //开启和监听 设备旋转的通知
        if !UIDevice.current.isGeneratingDeviceOrientationNotifications {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}

//MARK --- 屏幕旋转处理方法集合
extension DDVideoPlayerView {
    @objc internal func deviceOrientationDidChange(_ sender: Notification) {
        //如果为空，禁止旋转, 如果是tablecell播放，不触发横屏
        if ddPlayer?.player == nil || ddPlayer?.isEnableLandscape == false {
            return
        }
        //没有缓冲好就不旋转屏幕
        if ddPlayer?.bufferState == .none || ddPlayer?.bufferState == .buffering || ddPlayer?.bufferState == .stop {
            return
        }
        
        let orientation = UIDevice.current.orientation
        //状态栏方向为竖直时，记录父视图及frame
        setParentViewAndFrame()
        
        switch orientation {
        case .unknown:
            break
        case .faceDown:
            break
        case .faceUp:
            break
        case .landscapeLeft:
            onDeviceOrientation(true, orientation: .landscapeLeft)
        case .landscapeRight:
            onDeviceOrientation(true, orientation: .landscapeRight)
        case .portrait:
            exitFullscreen()
        case .portraitUpsideDown:
            break
        }
    }
    
    private func onDeviceOrientation(_ fullScreen: Bool, orientation: UIInterfaceOrientation) {
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            let rectInWindow = convert(bounds, to:  UIApplication.shared.keyWindow)
            self.frame = rectInWindow
            UIApplication.shared.keyWindow?.addSubview(self)
            brightnessView.removeFromSuperview()
            UIApplication.shared.keyWindow?.addSubview(brightnessView)
            UIApplication.shared.keyWindow?.bringSubviewToFront(brightnessView)

            //执行动画
            UIView.animate(withDuration: duration, animations: {
                self.transform = self.getTransformRotationAngle(orientation: orientation)
                self.brightnessView.transform = self.getTransformRotationAngle(orientation: orientation)
                self.bounds = CGRect(x: 0, y: 0, width: self.superview?.bounds.height ?? 0.0, height: self.superview?.bounds.width ?? 0.0)
                self.center = CGPoint(x: self.superview?.bounds.midX ?? 0.0, y: self.superview?.bounds.midY ?? 0.0)
                self.playerLayer?.frame = self.bounds
                self.setupSubViewsFrame()
            }) { (finished) in
                self.fullscreenButton.isSelected = fullScreen
                self.isFullScreen = fullScreen
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
        
        if isDisplayControl == true {
            topView.isHidden = false
        }
        
        if orientation == .landscapeLeft {
            UIApplication.shared.setStatusBarOrientation(.landscapeRight, animated: false)
        } else {
            UIApplication.shared.setStatusBarOrientation(.landscapeLeft, animated: false)
        }
        self.delegate?.ddPlayerView(self, willFullscreen: self.isFullScreen, orientation: orientation)
        if ddPlayer?.isHiddenCellPlayBottomBar == false {
            setupTimer()
        }
    }
    
    //退出全屏
    func exitFullscreen() {
        let rectInWindow = parentView?.convert(viewFrame, to:  UIApplication.shared.keyWindow)
        UIApplication.shared.keyWindow?.addSubview(self)
        //执行动画
        UIView.animate(withDuration: duration, animations: {
            self.transform = self.getTransformRotationAngle(orientation: .portrait)
            self.brightnessView.transform = self.getTransformRotationAngle(orientation: .portrait)
            self.frame = rectInWindow ?? CGRect.zero
            self.playerLayer?.frame = self.bounds
            self.setupSubViewsFrame()
         
        }) { (finished) in
            self.removeFromSuperview()
            self.frame = self.viewFrame
            self.playerLayer?.frame = self.bounds
            self.parentView?.addSubview(self)
            self.fullscreenButton.isSelected = false
            self.isFullScreen = false
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
        
        if isDisplayControl == true {
            topView.isHidden = true
        }
        UIApplication.shared.setStatusBarOrientation(.portrait, animated: false)
        self.delegate?.ddPlayerView(self, willFullscreen: self.isFullScreen, orientation: .portrait)
        if ddPlayer?.isHiddenCellPlayBottomBar == false {
            setupTimer()
        }
    }
    
    private func getTransformRotationAngle(orientation: UIInterfaceOrientation) -> CGAffineTransform {
        
        if orientation == .portrait {
            return .identity
        }
        
        if orientation == .landscapeLeft {
            return CGAffineTransform(rotationAngle: .pi/2.0)
        }
        
        if orientation == .landscapeRight {
            return CGAffineTransform(rotationAngle: -(.pi/2.0))
        }
        
        return .identity
    }
}

//MARK -- public method
extension DDVideoPlayerView {
    public func setddPlayer(ddPlayer: DDVideoPlayer) {
        self.ddPlayer = ddPlayer
    }
    
    public func reloadPlayerLayer() {
        playerLayer = AVPlayerLayer(player: self.ddPlayer?.player)
        guard let pLayer = playerLayer else {
            return
        }
        layer.insertSublayer(pLayer, at: 0)
        timeSlider.isUserInteractionEnabled = ddPlayer?.mediaFormat != .m3u8
        pLayer.frame = bounds
        reloadGravity()
    }
    
    /// play state did change
    public func playStateDidChange(_ state: DDPlayerState) {
        playButtion.isSelected = state == .playing
        centerPlayButtion.isHidden = true

        replayButton.isHidden = !(state == .playFinished)
        replayButton.isHidden = !(state == .playFinished)
        if state == .playing || state == .playFinished {
            setupTimer()
        }
        if state == .playFinished {
            loadingIndicator.isHidden = true
        }
    }
    
    /// buffer state change
    public func bufferStateDidChange(_ state: DDPlayerBufferstate) {
        centerPlayButtion.isHidden = true
        if state == .buffering {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
            //如果视频一直没播放，就显示
            if ddPlayer?.isPlay() == false {
                centerPlayButtion.isHidden = false
            }
        }
        
        var current = formatSecondsToString((ddPlayer?.currentDuration)!)
        if (ddPlayer?.totalDuration.isNaN)! {  // HLS
            current = "00:00"
        }
        
        if state == .readyToPlay && !isTimeSliding {
            timeLabel.text = formatSecondsToString(ddPlayer?.totalDuration ?? 0)
            currentLab.text = current
        }
    }
    
    /// buffer duration
    public func bufferedDidChange(_ bufferedDuration: TimeInterval, totalDuration: TimeInterval) {
        timeSlider.setProgress(Float(bufferedDuration / totalDuration), animated: true)
    }
    
    /// player duration
    public func playerDurationDidChange(_ currentDuration: TimeInterval, totalDuration: TimeInterval) {
        var current = formatSecondsToString(currentDuration)
        if totalDuration.isNaN {  // HLS
            current = "00:00"
        }
        if !isTimeSliding {
            timeLabel.text = formatSecondsToString(totalDuration)
            currentLab.text = current
            let value = Float(currentDuration / totalDuration)
            timeSlider.value = value
        }
    }
    
    public func configurationUI() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //添加屏幕亮度视图
        addSubview(brightnessView)
        configurationTopView()
        configurationBottomView()
        configurationReplayButton()
        configurationFailedButton()
        configurationNotWifiTipView()
        configurationCenterplayButton()
    }
    
    public func reloadPlayerView() {
        playerLayer = AVPlayerLayer(player: nil)
        timeSlider.value = Float(0)
        timeSlider.setProgress(0, animated: false)
        replayButton.isHidden = true
        failedButton.isHidden = true
        isTimeSliding = false
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        timeLabel.text = "00:00"
        currentLab.text = "00:00"
        reloadPlayerLayer()
    }
    
    /// control view display
    public func displayControlView(_ isDisplay:Bool) {
        if isDisplay {
            displayControlAnimation()
        } else {
            hiddenControlAnimation()
        }
    }
    
    /// play failed
   public  func playFailed(_ error: DDVideoPlayerError) {
        // error
        failedButton.isHidden = false
    }
}

// MARK: - privite method
private extension DDVideoPlayerView {
    
    func setParentViewAndFrame() {
        //状态栏方向为竖直时，记录父视图及frame
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if statusBarOrientation == .portrait {
            //记录父视图及frame
            parentView = superview
            viewFrame = frame
        }
    }
    
    func reloadGravity() {
        if ddPlayer != nil {
            switch ddPlayer!.gravityMode {
            case .resize:
                playerLayer?.videoGravity = .resize
            case .resizeAspect:
                playerLayer?.videoGravity = .resizeAspect
            case .resizeAspectFill:
                playerLayer?.videoGravity = .resizeAspectFill
            }
        }
    }

    func enterFullscreen() {
        //状态栏方向为竖直时，记录父视图及frame
        setParentViewAndFrame()
        onDeviceOrientation(true, orientation: .landscapeLeft)
    }

    func formatSecondsToString(_ seconds: TimeInterval) -> String {
        if seconds.isNaN{
            return "00:00"
        }
        let interval = Int(seconds)
        let sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        let min = interval / 60
        return String(format: "%02d:%02d", min, sec)
    }
}

// MARK: - public method
extension DDVideoPlayerView {
    public func play() {
        playButtion.isSelected = true
        centerPlayButtion.isHidden = true
    }
    
    public func pause() {
        playButtion.isSelected = false
        centerPlayButtion.isHidden = false
    }
    
    public func displayControlAnimation() {
        if ddPlayer?.isHiddenCellPlayBottomBar == false && isFullScreen == false {
            bottomView.isHidden = false
            bottomView.alpha = 1
            return
        }

        if isFullScreen == false {
            topView.isHidden = true
        } else {
            topView.isHidden = false
        }
        bottomView.isHidden = false
        isDisplayControl = true
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.alpha = 1
            self.topView.alpha = 1
        }) { (completion) in
            self.setupTimer()
        }
    }
    
    public func hiddenControlAnimation() {
        if ddPlayer?.isHiddenCellPlayBottomBar == false && isFullScreen == false {
            bottomView.isHidden = false
            bottomView.alpha = 1
            return
        }
        timer.invalidate()
        isDisplayControl = false
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.alpha = 0
            self.topView.alpha = 0
        }) { (completion) in
            self.bottomView.isHidden = true
            self.topView.isHidden = true
        }
    }
    
    public func setupTimer() {
        timer.invalidate()
        if ddPlayer?.isHiddenCellPlayBottomBar == false && isFullScreen == false {
            bottomView.isHidden = false
            bottomView.alpha = 1
            return
        }
        timer = Timer.ddPlayer_scheduledTimerWithTimeInterval(self.controlViewDuration, block: {  [weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.displayControlView(false)
            }, repeats: false)
    }
    
    public func configurationVolumeSlider() {
        let volumeView = MPVolumeView()
        if let view = volumeView.subviews.first as? UISlider {
            volumeSlider = view
        }
    }
    
    public func showNoWifiTipView() {
        loadingIndicator.isHidden = true
        wifiTipsView.isHidden = false
    }
}

// MARK: - GestureRecognizer
private extension DDVideoPlayerView {
    func addGestureRecognizer() {
        singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSingleTapGesture(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        singleTapGesture.delegate = self
        addGestureRecognizer(singleTapGesture)
        
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDoubleTapGesture(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        doubleTapGesture.delegate = self
        addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    func addPanGesture() {
        removaPanGesture()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture(_:)))
        panGesture?.delegate = self
        if let pan = panGesture {
            addGestureRecognizer(pan)
        }
    }
    
    func removaPanGesture() {
        if let pan = panGesture {
            removeGestureRecognizer(pan)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension DDVideoPlayerView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view as? DDVideoPlayerView != nil) {
            return true
        }
        return false
    }
}

// MARK: - Event
extension DDVideoPlayerView {
    
    func timeSliderTouchMoved() {
        isTimeSliding = true
        timer.invalidate()

        if let duration = ddPlayer?.totalDuration {
            let currentTime = Double(timeSlider.value) * duration
            ddPlayer?.seekTime(currentTime, completion: { [weak self] (finished) in
                guard let strongSelf = self else { return }
                if finished {
                    strongSelf.isTimeSliding = false
                    strongSelf.setupTimer()
                }
            })
            timeLabel.text = (formatSecondsToString(duration))
            currentLab.text = formatSecondsToString(currentTime)
        }
    }
    
    @objc internal func timeSliderValueChanged(_ sender: DDVideoPlayerSlider) {
        isTimeSliding = true
        if let duration = ddPlayer?.totalDuration {
            let currentTime = Double(sender.value) * duration
            timeLabel.text = formatSecondsToString(duration)
            currentLab.text = formatSecondsToString(currentTime)
        
        }
    }

    @objc internal func onPlayerButton(_ sender: UIButton) {
        if !sender.isSelected {
            ddPlayer?.play()
        } else {
            ddPlayer?.pause()
        }
    }
    
    @objc internal func onFullscreen(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isFullScreen = sender.isSelected
        if isFullScreen {
            enterFullscreen()
        } else {
            exitFullscreen()
        }
    }
    
    /// Single Tap Event
    @objc open func onSingleTapGesture(_ gesture: UITapGestureRecognizer) {
        isDisplayControl = !isDisplayControl
        displayControlView(isDisplayControl)
    }
    
    /// Double Tap Event
    @objc open func onDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        
        guard ddPlayer == nil else {
            switch ddPlayer!.state {
            case .playFinished:
                break
            case .playing:
                ddPlayer?.pause()
            case .paused:
                ddPlayer?.play()
            case .none:
                break
            case .error:
                break
            }
            return
        }
    }
    
    /// Pan Event
    @objc open func onPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let location = gesture.location(in: self)
        let velocity = gesture.velocity(in: self)
        switch gesture.state {
        case .began:
            let x = abs(translation.x)
            let y = abs(translation.y)
            if x < y {
                panGestureDirection = .vertical
                if location.x > bounds.width / 2 {
                    isVolume = true
                } else {
                    isVolume = false
                }
            } else if x > y{
                guard ddPlayer?.mediaFormat == .m3u8 else {
                    panGestureDirection = .horizontal
                    return
                }
            }
        case .changed:
            switch panGestureDirection {
            case .horizontal:
                if ddPlayer?.currentDuration == 0 { break }
                sliderSeekTimeValue = panGestureHorizontal(velocity.x)
            case .vertical:
                panGestureVertical(velocity.y)
            }
        case .ended:
            switch panGestureDirection{
            case .horizontal:
                if sliderSeekTimeValue.isNaN { return }
                self.ddPlayer?.seekTime(sliderSeekTimeValue, completion: { [weak self] (finished) in
                    guard let strongSelf = self else { return }
                    if finished {
                        strongSelf.isTimeSliding = false
                        strongSelf.setupTimer()
                    }
                })
            case .vertical:
                isVolume = false
            }
            
        default:
            break
        }
    }
    
    func panGestureHorizontal(_ velocityX: CGFloat) -> TimeInterval {
        displayControlView(true)
        isTimeSliding = true
        timer.invalidate()
        let value = timeSlider.value
        if let _ = ddPlayer?.currentDuration ,let totalDuration = ddPlayer?.totalDuration {
            let sliderValue = (TimeInterval(value) *  totalDuration) + TimeInterval(velocityX) / 100.0 * (TimeInterval(totalDuration) / 400)
            timeSlider.setValue(Float(sliderValue/totalDuration), animated: true)
            return sliderValue
        } else {
            return TimeInterval.nan
        }
    }
    
    func panGestureVertical(_ velocityY: CGFloat) {
        if isFullScreen == false {
            return
        }
        isVolume ? (volumeSlider.value -= Float(velocityY / 10000)) : (UIScreen.main.brightness -= velocityY / 10000)
    }
    
    @objc internal func onCloseView(_ sender: UIButton) {
        exitFullscreen()
        delegate?.ddPlayerView(didTappedClose: self)
    }
    
    @objc internal func onReplay(_ sender: UIButton) {
        ddPlayer?.replaceVideo((ddPlayer?.contentURL)!)
        ddPlayer?.play()
    }
    @objc internal func onFailed(_ sender: UIButton) {
        ddPlayer?.replaceVideo((ddPlayer?.contentURL)!)
        ddPlayer?.play()
    }
}

//MARK: - UI autoLayout
private extension DDVideoPlayerView {
    
    func configurationCenterplayButton() {
        addSubview(centerPlayButtion)
        if let path = Bundle(for: DDVideoPlayerView.classForCoder()).path(forResource: "DDVideoPlayer", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let playImage = UIImage(named: "video_btn_play_two", in: bundle, compatibleWith: nil) {
            centerPlayButtion.setImage(playImage, for: .normal)
        }
        centerPlayButtion.addTarget(self, action: #selector(onPlayerButton(_:)), for: .touchUpInside)
        centerPlayButtion.isHidden = true
    }
    
    func configurationNotWifiTipView () {
        addSubview(wifiTipsView)
        wifiTipsView.continuePlayBtnCallBack = { [weak self] in
            self?.isAllowNotWifiPlay = true
            self?.ddPlayer?.replaceVideo(self?.ddPlayer?.contentURL)
            self?.ddPlayer?.play()
        }
        wifiTipsView.isHidden = true
    }
    
    func configurationFailedButton() {
        addSubview(failedButton)
        failedButton.addTarget(self, action: #selector(onFailed(_:)), for: .touchUpInside)
    }
    
    func configurationReplayButton() {
        addSubview(self.replayButton)
        if let path = Bundle(for: DDVideoPlayerView.classForCoder()).path(forResource: "DDVideoPlayer", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let replayImage = UIImage(named: "ic_replay", in: bundle, compatibleWith: nil) {
            replayButton.setImage(DDVideoPlayerUtils.imageSize(image: replayImage, scaledToSize: CGSize(width: 30, height: 30)), for: .normal)
        }
        replayButton.addTarget(self, action: #selector(onReplay(_:)), for: .touchUpInside)
        replayButton.isHidden = true
    }
    
    func configurationTopView() {
        addSubview(topView)
        topView.isHidden = true
        titleLabel.text = "this is a title."
        topView.addSubview(titleLabel)
        if let path = Bundle(for: DDVideoPlayerView.classForCoder()).path(forResource: "DDVideoPlayer", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let closeImage = UIImage(named: "VGPlayer_ic_nav_back", in: bundle, compatibleWith: nil) {
            closeButton.setImage(DDVideoPlayerUtils.imageSize(image: closeImage, scaledToSize: CGSize(width: 15, height: 20)), for: .normal)

        }
        closeButton.addTarget(self, action: #selector(onCloseView(_:)), for: .touchUpInside)
        topView.addSubview(closeButton)
    }
    
    func configurationBottomView() {
        addSubview(bottomView)
        timeSlider.addTarget(self, action: #selector(timeSliderValueChanged(_:)),
                             for: .valueChanged)
//        timeSlider.addTarget(self, action: #selector(timeSliderTouchUpInside(_:)), for: .touchUpInside)
//        timeSlider.addTarget(self, action: #selector(timeSliderTouchDown(_:)), for: .touchDown)
        timeSlider.touchChangedCallBack = {[weak self] value in
            self?.timeSliderTouchMoved()
        }
//        loadingIndicator.lineWidth = 1.0
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        addSubview(loadingIndicator)
        bottomView.addSubview(timeSlider)
        if let path = Bundle(for: DDVideoPlayerView.classForCoder()).path(forResource: "DDVideoPlayer", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let playImage = UIImage(named: "video_btn_play", in: bundle, compatibleWith: nil),
            let pauseImage = UIImage(named: "video_btn_stop", in: bundle, compatibleWith: nil){
            playButtion.setImage(DDVideoPlayerUtils.imageSize(image: playImage, scaledToSize: CGSize(width: 15, height: 15)), for: .normal)
            playButtion.setImage(DDVideoPlayerUtils.imageSize(image: pauseImage, scaledToSize: CGSize(width: 15, height: 15)), for: .selected)
        }
       
        playButtion.addTarget(self, action: #selector(onPlayerButton(_:)), for: .touchUpInside)
        bottomView.addSubview(playButtion)
        bottomView.addSubview(timeLabel)
        bottomView.addSubview(currentLab)
        
        if let path = Bundle(for: DDVideoPlayerView.classForCoder()).path(forResource: "DDVideoPlayer", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let enlargeImage = UIImage(named: "ic_fullscreen", in: bundle, compatibleWith: nil),
            let narrowImage = UIImage(named: "ic_fullscreen_exit", in: bundle, compatibleWith: nil){
            fullscreenButton.setImage(DDVideoPlayerUtils.imageSize(image: enlargeImage, scaledToSize: CGSize(width: 15, height: 15)), for: .normal)
            fullscreenButton.setImage(DDVideoPlayerUtils.imageSize(image: narrowImage, scaledToSize: CGSize(width: 15, height: 15)), for: .selected)
        }
        fullscreenButton.addTarget(self, action: #selector(onFullscreen(_:)), for: .touchUpInside)
        bottomView.addSubview(fullscreenButton)
    }
    
    func setupSubViewsFrame() {
        let sWidth = bounds.width
        let sHeight = bounds.height
        //适用横屏v布局
        var leftMargin: CGFloat = 0
        if isFullScreen && DDVPIsiPhoneX.isIphonex() == true {
            leftMargin = 30
        }
        
        let viewCenter = CGPoint(x: sWidth / 2, y: sHeight / 2)
        //wifiTipsView
        wifiTipsView.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        wifiTipsView.center = viewCenter
        
        //failedButton
        failedButton.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        failedButton.center = viewCenter

        //replayButton
        replayButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        replayButton.center = viewCenter

        // top view layout
        let topViewCenterY: CGFloat = (44 - 25) / 2
        topView.frame = CGRect(x: 0 , y: 0, width: sWidth, height: 44)
        closeButton.frame = CGRect(x: 10 + leftMargin, y: topViewCenterY, width: 30, height: 30)
        titleLabel.frame = CGRect(x: 10 + leftMargin + 30 + 20, y: topViewCenterY, width: sWidth - 10 - 30 - 20 - 12 - leftMargin * 2, height: 30)
        
        // bottom view layout
        let bottmHeight: CGFloat = 44
        let bottomCenterY: CGFloat = (bottmHeight - 25) / 2
        bottomView.frame = CGRect(x: 0, y: sHeight - bottmHeight, width: sWidth, height: bottmHeight)
        playButtion.frame = CGRect(x: 10 + leftMargin, y: bottomCenterY + 2, width: 25, height: 25)
        currentLab.frame = CGRect(x: 10 + leftMargin + 10 + 25, y: bottomCenterY, width: 50, height: 30)
        fullscreenButton.frame = CGRect(x: sWidth - leftMargin - 10 - 30 - 10, y: bottomCenterY, width: 30, height: 30)
        timeLabel.frame = CGRect(x: sWidth - leftMargin - 10 - 30 - 10 - 50, y: bottomCenterY, width: 50, height: 30)
        
        let w = sWidth - leftMargin - 10 - 30 - 10 - 50 - 10 - 10 - leftMargin - 10 - 25 - 10 - 50
        timeSlider.frame = CGRect(x: 10 + leftMargin + 10 + 25 + 50 + 10, y: bottomCenterY + 2, width: w, height: 25)

        //loadingIndicator
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        loadingIndicator.center = viewCenter
        
        centerPlayButtion.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        centerPlayButtion.center = viewCenter
    }
}

extension DDVideoPlayerView {
    func getAppTopViewController() -> (UIViewController?) {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if rootViewController?.isKind(of: UITabBarController.self) == true {
            let tabBarController: UITabBarController = rootViewController as! UITabBarController
            return tabBarController.selectedViewController
        } else if rootViewController?.isKind(of: UINavigationController.self) == true {
            let navigationController: UINavigationController = rootViewController as! UINavigationController
            return navigationController.visibleViewController
        } else if let presentVC = rootViewController?.presentedViewController {
            return presentVC
        }
        return rootViewController
    }
}
