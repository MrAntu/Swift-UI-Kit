//
//  Timer+DDVideoPlayer.swift
//  mpdemo
//
//  Created by leo on 2018/10/30.
//  Copyright © 2018年 dd01.leo. All rights reserved.
//

import Foundation

extension Timer {
    class func ddPlayer_scheduledTimerWithTimeInterval(_ timeInterval: TimeInterval, block: @escaping()->(), repeats: Bool) -> Timer {
        return self.scheduledTimer(timeInterval: timeInterval, target:
            self, selector: #selector(self.ddPlayer_blcokInvoke(_:)), userInfo: block, repeats: repeats)
    }
    
    @objc class func ddPlayer_blcokInvoke(_ timer: Timer) {
        let block: ()->() = timer.userInfo as! ()->()
        block()
    }
    
}
