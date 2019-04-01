//
//  CountDownTimer.swift
//  CountDownTimerDemo
//
//  Created by USER on 2018/12/7.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

extension DispatchSource {
    
    /*
     
     1、 针对于NSTimer定时器的生命周期管理的不方便性，若管理不当，容易造成循环引用，因此封装了一个基于GCDTimer的定时器，常用于验证码等倒计时的功能
     2、 当用户进入后台，此定时器依然生效
     
 
     */

    //        计时器只在程序active时工作，当用户按起HOME键时，计时器停止，因为当程序进入后台时，这个线程就被挂起不工作，当然计时器就会被“暂停”。
    //        系统原理: iOS为了让设备尽量省电，减少不必要的开销，保持系统流畅，因而对后台机制采用“假后台”模式。一般开发者开发出来的应用程序后台受到以下限制：

    //        1.用户按Home之后，App转入后台进行运行，此时拥有180s后台时间（iOS7）或者600s（iOS6）运行时间可以处理后台操作
    //        2.当180S或者600S时间过去之后，可以告知系统未完成任务，需要申请继续完成，系统批准申请之后，可以继续运行，但总时间不会超过10分钟（系统提供beginBackgroundTaskWithExpirationHandler方法）。
    //        3.当10分钟时间到之后，无论怎么向系统申请继续后台，系统会强制挂起App，挂起所有后台操作、线程，直到用户再次点击App之后才会继续运行。
    
    
    /// 倒计时
    ///  基于GCDTimers实现
    /// - Parameters:
    ///   - timeInterval: 时间间隔
    ///   - handler: 每次时间间隔的回调
    @discardableResult static func dispatchTimer(timeInterval: Double = 1.0, handler:@escaping (DispatchSourceTimer?)->()) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer.schedule(deadline: .now(), repeating: timeInterval)
        timer.setEventHandler {
            DispatchQueue.main.async {
                handler(timer)
            }
        }
        timer.resume()
        //  beginBackgroundTaskWithExpirationHandler是向系统发出申请延长后台不被挂起时间
        //  endBackgroundTask是告诉系统已完事，可以结束了，
        var bgTask: UIBackgroundTaskIdentifier?
        bgTask = UIApplication.shared.beginBackgroundTask {
            DispatchQueue.main.async(execute: {
                if bgTask != UIBackgroundTaskIdentifier.invalid {
                    if var task = bgTask {
                        UIApplication.shared.endBackgroundTask(task)
                        task = UIBackgroundTaskIdentifier.invalid
                    }
                }
            })
        }
        
        return timer
    }
}


/* 使用demo
 DispatchSource.dispathTimer(timeInterval: 1) {[weak self] (timer) in
    print("~~~~~~~~\(String(describing: self?.total))~~~~~~~~~~~~")
     guard let strongSelf = self else {
        timer?.cancel()
        return
     }
 
     strongSelf.total = strongSelf.total - 1
 
     if  strongSelf.total < 0 {
        timer?.cancel()
        return
     }
     strongSelf.lab.text = "\(strongSelf.total)"
}
 
 */
