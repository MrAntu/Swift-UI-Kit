//
//  DDVideoPlayerViewDelegate.swift
//  mpdemo
//
//  Created by USER on 2018/10/30.
//  Copyright © 2018年 dd01.leo. All rights reserved.
//

import UIKit

public protocol DDPlayerViewDelegate: class {
    
    func ddPlayerView(_ playerView: DDVideoPlayerView, willFullscreen isFullscreen: Bool, orientation: UIInterfaceOrientation)
    
    func ddPlayerView(didTappedClose playerView: DDVideoPlayerView)
    
    func ddPlayerView(didDisplayControl playerView: DDVideoPlayerView)
    
}

// MARK: - delegate methods optional
public extension DDPlayerViewDelegate {
    
    func ddPlayerView(_ playerView: DDVideoPlayerView, willFullscreen isFullscreen: Bool, orientation: UIInterfaceOrientation) {}

    func ddPlayerView(didTappedClose playerView: DDVideoPlayerView) {}
    
    func ddPlayerView(didDisplayControl playerView: DDVideoPlayerView) {}
    
    func ddPlayerView(deviceOrientationDidChange playerView: DDVideoPlayerView, orientation: UIInterfaceOrientation) {}
}

public enum DDPlayerViewPanGestureDirection: Int {
    case vertical
    case horizontal
}
