//
//  Timer+Block.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/23.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation
extension Timer {
   public class func scheduledTimerWithTimeInterval(_ timeInterval: TimeInterval, block: @escaping()->(), repeats: Bool) -> Timer {
        return self.scheduledTimer(timeInterval: timeInterval, target:
            self, selector: #selector(self.blcokInvoke(_:)), userInfo: block, repeats: repeats)
    }
    
    @objc class func blcokInvoke(_ timer: Timer) {
        let block: ()->() = timer.userInfo as! ()->()
        block()
    }
    
}
