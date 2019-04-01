//
//  DDVideoPlayerError.swift
//  mpdemo
//
//  Created by leo on 2018/10/30.
//  Copyright © 2018年 dd01.leo. All rights reserved.
//

import Foundation
import AVFoundation

public struct DDVideoPlayerError: CustomStringConvertible {
    var error : Error?
    var playerItemErrorLogEvent : [AVPlayerItemErrorLogEvent]?
    var extendedLogData : Data?
    var extendedLogDataStringEncoding : UInt?
    
    public var description: String {
        return "DDVideoPlayer Log -------------------------- \n error: \(String(describing: error))\n playerItemErrorLogEvent: \(String(describing: playerItemErrorLogEvent))\n extendedLogData: \(String(describing: extendedLogData))\n extendedLogDataStringEncoding \(String(describing: extendedLogDataStringEncoding))\n --------------------------"
    }
}
