//
//  PhotoBrowserVideoBottom.swift
//  DDPhotoBrowserDemo
//
//  Created by weiwei.li on 2019/1/23.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

class PhotoBrowserVideoBottom: UIView {
    weak public var videoView : PhotoBrowserVideoView?
    
    //进度条slider
    lazy public var timeSlider = PhotoBrowserSlider()
    lazy private var currentLab: UILabel = {
        let currentLab = UILabel()
        currentLab.textColor = UIColor.white
        currentLab.font = UIFont.systemFont(ofSize: 12)
        currentLab.textAlignment = .center
        currentLab.text = "00:00"
        return currentLab
    }()
    
    lazy private var totalLab: UILabel = {
        let totalLab = UILabel()
        totalLab.textColor = UIColor.white
        totalLab.font = UIFont.systemFont(ofSize: 12)
        totalLab.textAlignment = .center
        totalLab.text = "00:00"
        return totalLab
    }()
    
    lazy private var playBtn: UIButton = {
        let playBtn = UIButton(type: .custom)
        if let path = Bundle(for: PhotoBrowserVideoBottom.classForCoder()).path(forResource: "DDPhotoBrowser", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let image = UIImage(named: "video_btn_play", in: bundle, compatibleWith: nil) {
            playBtn.setImage(image, for: .normal)
        }
        playBtn.addTarget(self, action: #selector(playBtnAction(_:)), for: .touchUpInside)
        return playBtn
    }()
    
//    lazy private var fullScreenBtn: UIButton = {
//        let fullScreenBtn = UIButton(type: .custom)
//        if let path = Bundle(for: PhotoBrowserVideoBottom.classForCoder()).path(forResource: "DDPhotoBrowser", ofType: "bundle"),
//            let bundle = Bundle(path: path),
//            let image = UIImage(named: "ic_fullscreen", in: bundle, compatibleWith: nil) {
//            fullScreenBtn.setImage(image, for: .normal)
//        }
//        fullScreenBtn.addTarget(self, action: #selector(fullScreenBtnAction(_:)), for: .touchUpInside)
//        return fullScreenBtn
//    }()
//    //是否全屏
//    private var isFullScreen : Bool = false
    //是否拖拽进度条
    private var isTimeSliding : Bool = false
    private var totalDuration : TimeInterval = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        let y = (bounds.height - 25) / 2
        playBtn.frame = CGRect(x: 6 , y: y, width: 26, height: 26)
        currentLab.frame = CGRect(x: 6 + 15 + 26, y: y, width: 50, height: 25)
        let timeSliderW = screenWidth - 6 - 26 - 15 - 50 - 50 - 26 - 15
        timeSlider.frame = CGRect(x: 6 + 15 + 26 + 50, y: y, width: timeSliderW, height: 25)
        totalLab.frame = CGRect(x: screenWidth - 32 - 15 - 50, y: y, width: 50, height: 25)
//        fullScreenBtn.frame = CGRect(x: screenWidth - 32, y: y, width: 26, height: 26)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PhotoBrowserVideoBottom {
    func playerDurationDidChange(_ currentDuration: TimeInterval, totalDuration: TimeInterval) {
        self.totalDuration = totalDuration
        var current = formatSecondsToString(currentDuration)
        if totalDuration.isNaN {
            current = "00:00"
        }
        
        if isTimeSliding == false {
            currentLab.text = current
            totalLab.text = formatSecondsToString(totalDuration)
            let value = Float(currentDuration / totalDuration)
            timeSlider.value = value
        }
    }
    
    func changePlayBtnImage(_ isPlay: Bool) {
        playBtn.isSelected = isPlay
        if isPlay == true {
            if let path = Bundle(for: PhotoBrowserVideoBottom.classForCoder()).path(forResource: "DDPhotoBrowser", ofType: "bundle"),
                let bundle = Bundle(path: path),
                let image = UIImage(named: "video_btn_stop", in: bundle, compatibleWith: nil) {
                playBtn.setImage(image, for: .normal)
            }
        } else {
            if let path = Bundle(for: PhotoBrowserVideoBottom.classForCoder()).path(forResource: "DDPhotoBrowser", ofType: "bundle"),
                let bundle = Bundle(path: path),
                let image = UIImage(named: "video_btn_play", in: bundle, compatibleWith: nil) {
                playBtn.setImage(image, for: .normal)
            }
        }
    }
    
    func changeFullScreenBtnAction(_ isFull: Bool) {
//        if isFull == true {
//            if let path = Bundle(for: PhotoBrowserVideoBottom.classForCoder()).path(forResource: "DDPhotoBrowser", ofType: "bundle"),
//                let bundle = Bundle(path: path),
//                let image = UIImage(named: "ic_fullscreen_exit", in: bundle, compatibleWith: nil) {
//                fullScreenBtn.setImage(image, for: .normal)
//            }
//        } else {
//            if let path = Bundle(for: PhotoBrowserVideoBottom.classForCoder()).path(forResource: "DDPhotoBrowser", ofType: "bundle"),
//                let bundle = Bundle(path: path),
//                let image = UIImage(named: "ic_fullscreen", in: bundle, compatibleWith: nil) {
//                fullScreenBtn.setImage(image, for: .normal)
//            }
//        }
    }
    
    @objc func timeSliderValueChanged(_ sender: PhotoBrowserSlider) {
        isTimeSliding = true
        let currentTime = Double(sender.value) * totalDuration
        currentLab.text = formatSecondsToString(currentTime)
    }
    
    @objc func playBtnAction(_ sender: UIButton) {
        playBtn.isSelected = !playBtn.isSelected
        if playBtn.isSelected == true {
            videoView?.playBtnAction(nil)
        } else {
            videoView?.pause()
            isHidden = false
        }
        changePlayBtnImage(playBtn.isSelected)
    }
    
    @objc func fullScreenBtnAction(_ sender: UIButton) {
//        fullScreenBtn.isSelected = !fullScreenBtn.isSelected
//        isFullScreen = fullScreenBtn.isSelected
        //        NotificationCenter.default.post(name: Notification.Name.DDPhotoFullScreenNotification, object: nil)
//        changeFullScreenBtnAction(fullScreenBtn.isSelected)
//        let orientation = UIDevice.current.orientation
//        if orientation == .portrait {
//            let value = UIInterfaceOrientation.landscapeLeft.rawValue
//            UIDevice.current.setValue(value, forKey: "orientation")
//        } else {
//            let value = UIInterfaceOrientation.portrait.rawValue
//            UIDevice.current.setValue(value, forKey: "orientation")
//        }
    }
    
    @objc internal func deviceOrientationDidChange(_ sender: Notification) {
//        let orientation = UIDevice.current.orientation
//        if orientation == .portrait {
//            fullScreenBtn.isSelected = false
//        } else {
//            fullScreenBtn.isSelected = true
//        }
//        changeFullScreenBtnAction(fullScreenBtn.isSelected)
    }

}


private extension PhotoBrowserVideoBottom {
    func setupUI() {
        addSubview(timeSlider)
        addSubview(currentLab)
        addSubview(totalLab)
        addSubview(playBtn)
//        addSubview(fullScreenBtn)
        
        timeSlider.addTarget(self, action: #selector(timeSliderValueChanged(_:)), for: .valueChanged)
        timeSlider.touchChangedCallBack = {[weak self] value in
            self?.timeSliderTouchMoved()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func timeSliderTouchMoved() {
        isTimeSliding = true
        let currentTime = Double(timeSlider.value) * totalDuration
        videoView?.seekTime(currentTime, completion: {[weak self] (finished) in
            if finished {
                self?.isTimeSliding = false
            }
        })
        currentLab.text = formatSecondsToString(currentTime)
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
