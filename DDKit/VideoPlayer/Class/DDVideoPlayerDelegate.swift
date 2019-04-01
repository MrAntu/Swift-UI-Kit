//
//  DDVideoPlayerDelegate.swift
//  mpdemo
//
//  Created by USER on 2018/10/30.
//  Copyright © 2018年 dd01.leo. All rights reserved.
//

import UIKit

public enum DDPlayerState: Int {
    case none            // default
    case playing
    case paused
    case playFinished
    case error
}

public enum DDPlayerBufferstate: Int {
    case none           // default
    case readyToPlay
    case buffering
    case stop
    case bufferFinished
}

public enum DDVideoGravityMode: Int {
    case resize
    case resizeAspect      // default
    case resizeAspectFill
}

public enum DDPlayerBackgroundMode: Int {
    case suspend
    case autoPlayAndPaused
    case proceed
}

public protocol DDVideoPlayerDelegate: class {
    // play state
    func ddPlayer(_ player: DDVideoPlayer, stateDidChange state: DDPlayerState)
    // playe Duration
    func ddPlayer(_ player: DDVideoPlayer, playerDurationDidChange currentDuration: TimeInterval, totalDuration: TimeInterval)
    // buffer state
    func ddPlayer(_ player: DDVideoPlayer, bufferStateDidChange state: DDPlayerBufferstate)
    // buffered Duration
    func ddPlayer(_ player: DDVideoPlayer, bufferedDidChange bufferedDuration: TimeInterval, totalDuration: TimeInterval)
    // play error
    func ddPlayer(_ player: DDVideoPlayer, playerFailed error: DDVideoPlayerError)
}

// MARK: - delegate methods optional
public extension DDVideoPlayerDelegate {
    func ddPlayer(_ player: DDVideoPlayer, stateDidChange state: DDPlayerState) {}
    func ddPlayer(_ player: DDVideoPlayer, playerDurationDidChange currentDuration: TimeInterval, totalDuration: TimeInterval) {}
    func ddPlayer(_ player: DDVideoPlayer, bufferStateDidChange state: DDPlayerBufferstate) {}
    func ddPlayer(_ player: DDVideoPlayer, bufferedDidChange bufferedDuration: TimeInterval, totalDuration: TimeInterval) {}
    func ddPlayer(_ player: DDVideoPlayer, playerFailed error: DDVideoPlayerError) {}
}
