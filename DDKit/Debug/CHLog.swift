//
//  CHLog.swift
//  CHLog
//
//  Created by wanggw on 2018/5/28.
//  Copyright © 2018年 UnionInfo. All rights reserved.
//

import UIKit

// MARK: -

public typealias CHLogClosure = (_ info: String, _ attributedString: NSMutableAttributedString) -> Void
public typealias CHLogChangedClosure = (_ infoArray: [CHLogItem]) -> Void
fileprivate let Date_Formatter = DateFormatter()

public enum CHLogShowType {
    case none    //不打印
    case all     //所有
    case error   //错误
}

public protocol DDRequstItemProtocol {
    var method: String? { get }
    var url: String? { get }
    var headers: [String: String]? { get }
    var parameters: [String: String]? { get }
    var response: [String: Any]? { get }
    var isError: Bool? { get }
}

// MARK: - API

public extension CHLog {
    
    /// 显示日志按钮
    ///
    /// - Parameters:
    ///   - showType: 显示类型
    ///   - listenUrls: 白名单
    public class func setup(with showType: CHLogShowType, listenUrls: [String]?) {
        CHLog.shared.setup(with: showType, listenUrls: listenUrls)
    }
    
    /// 显示终端打印的日志，info：终端print信息、isError：是否是错误信息
    public class func log(with info: String, isError: Bool = false) {
        CHLog.shared.log(with: info, isError: isError)
    }
    
    public class func log(with request: DDRequstItemProtocol) {
        CHLog.shared.log(with: request)
    }
}
    
public extension CHLog {
    
    /// 日志信息改变的回调
    ///
    /// - Parameter logClosure: 回调
    public class func logInfoChanged(logClosure: @escaping CHLogClosure) {
        CHLog.shared.logInfoChang(logClosure: logClosure)
    }
    
    public class func logInfoArrayChanged(logClosure: @escaping CHLogChangedClosure) {
        CHLog.shared.logInfoArrayChanged(logClosure: logClosure)
    }
    
    /// 当前的日志字符串
    public class func currentLogInfo() -> String {
        return CHLog.shared.currentLogInfo()
    }

    public class func currentInfoAttributedString() -> NSMutableAttributedString {
        return CHLog.shared.currentInfoAttributedString()
    }

    class func currentLogArray() -> [CHLogItem] {
        return CHLog.shared.currentLogArray()
    }
    
    public class func currentShowType() -> CHLogShowType {
        return CHLog.shared.currentShowType()
    }
    
    class func clean() {
        CHLog.shared.clean()
    }
    
    /// 隐藏日志按钮
    class func show() {
        CHLog.shared.show()
    }
    
    /// 隐藏日志按钮
    class func hidden() {
        CHLog.shared.hidden()
    }
}

public class CHLog: NSObject {
    fileprivate var window: UIWindow?
    fileprivate var logButton: CHButton?
    fileprivate var showType: CHLogShowType = .none
    
    fileprivate var listenUrls: [String] = []
    fileprivate var logInfoArray: [CHLogItem] = []
    fileprivate var logChangedClosure: CHLogChangedClosure?
    
    fileprivate var logInfo: String = ""
    fileprivate var infoAttributedString: NSMutableAttributedString = NSMutableAttributedString(string: "")
    fileprivate var logClosure: CHLogClosure?
    
    
    static let shared = CHLog()
    private override init() {
        super.init()
        customInit()
    }
    
    private func customInit() {
        window = CHWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()
        window?.rootViewController?.view.backgroundColor = UIColor.clear
        window?.rootViewController?.view.isUserInteractionEnabled = false
        window?.windowLevel = UIWindow.Level.alert-1
        window?.alpha = 1.0
        
        let bottom_space = (UIScreen.main.bounds.size.height == 812) ? CGFloat(49+34): CGFloat(49)
        logButton = CHButton(type: .custom)
        logButton?.frame = CGRect(x: UIScreen.main.bounds.width - 60 - 20, y: UIScreen.main.bounds.height - 60 - 20 - bottom_space, width: 60, height: 60)
        logButton?.backgroundColor = UIColor.white
        logButton?.setTitle("日志", for: .normal)
        logButton?.setTitleColor(UIColor.red, for: .normal)
        logButton?.clipsToBounds = true
        logButton?.layer.cornerRadius = 30
        logButton?.layer.borderWidth = 7
        logButton?.layer.borderColor = UIColor.red.cgColor
        if let logButton = logButton {
            window?.addSubview(logButton)
        }
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(showLogView))
        logButton?.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(show), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}

extension CHLog {
    
    @objc private func show() {
        window?.isHidden = false ///默认为YES，当你设置为NO时，这个Window就会显示了
    }
    
    private func setup(with showType: CHLogShowType, listenUrls: [String]?) {
        self.showType = showType
        self.listenUrls = listenUrls ?? []
    }
    
    private func hidden() {
        window?.isHidden = true
    }

    /// 一、处理调试打印
    private func log(with info: String, isError: Bool) {
        let logItem: CHLogItem = CHLogItem()
        logItem.logInfo = info
        logItem.isError = isError
        logItem.isRequest = false
        logInfoArray.insert(logItem, at: 0)
        
        if let logChangedClosure = self.logChangedClosure {
            logChangedClosure(self.logInfoArray)
        }
    }
    
    /// 二、处理请求日志
    private func log(with request: DDRequstItemProtocol) {
        guard let url = request.url, shouldListen(requestUrl: url) else {
            return
        }
        
        let notificaitonAction = {
            if let logChangedClosure = self.logChangedClosure {
                logChangedClosure(self.logInfoArray)
            }
        }
        
        var isContainted = false
        var exIndex = -1
        for (index, logInfo) in logInfoArray.enumerated() {
            if let url = request.url, logInfo.requstFullUrl.isEqual(url) {
                isContainted = true
                exIndex = index
                break
            }
        }
        
        //1、不包含，是一个新的网络请求
        if !isContainted {
            //新请求
            let logInfo = CHLogItem.item(with: request)
            logInfoArray.insert(logInfo, at: 0)
            notificaitonAction()
            return
        }
        
        //2、已经包含，而且是第n次发起请求，替换位置到最前面
        if request.response == nil {
            logInfoArray.swapAt(exIndex, 0)
            notificaitonAction()
            return
        }
        
        //3、请求回调，即：request.response != nil
        for logInfo in logInfoArray {
            if let url = request.url, logInfo.requstFullUrl.isEqual(url) {
                let responseLogInfo = CHLogItem.item(with: request)
                //插入到 index：0 位置，相同的请求可能会有多个相应
                logInfo.responses.insert(responseLogInfo, at: 0)
                notificaitonAction()
                break
            }
        }
    }
    
    private func shouldListen(requestUrl: String) -> Bool {
        if listenUrls.isEmpty {
            return true
        }
        
        var isShouldListen = false
        listenUrls.forEach({ (url) in
            if requestUrl.contains(url) {
                isShouldListen = true
            }
        })
        return isShouldListen
    }
    
    private func logInfoChang(logClosure: @escaping CHLogClosure) {
        self.logClosure = logClosure
    }
    
    private func logInfoArrayChanged(logClosure: @escaping CHLogChangedClosure) {
        self.logChangedClosure = logClosure
    }
    
    private func currentShowType() -> CHLogShowType {
        return showType
    }
    
    private func currentLogInfo() -> String {
        return logInfo
    }
    
    func currentLogArray() -> [CHLogItem] {
        return logInfoArray
    }

    private func currentInfoAttributedString() -> NSMutableAttributedString {
        return infoAttributedString
    }
    
    private func clean() {
        logInfo = ""
        infoAttributedString = NSMutableAttributedString(string: "")
        if let logClosure = logClosure {
            logClosure(logInfo, infoAttributedString)
        }
        
        logInfoArray.removeAll()
        if let logChangedClosure = logChangedClosure {
            logChangedClosure(logInfoArray)
        }
    }
    
    private func currentTimeString() -> String {
        Date_Formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return "\(Date_Formatter.string(from: Date()))"
    }
    
    @objc fileprivate func showLogView() {
        let vc = CHLogListViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        UIViewController.currentViewController()?.present(nav, animated: true, completion: {
            self.hidden()
        })
    }
}

// MARK: - UIViewController

extension UIViewController {
    
    /// 获取当前显示的视图
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }

        print("【DDDebug】+++++++++++++：推出日志的视图是：\(String(describing: base))")
        return base
    }
    
    /// 获取导航栏视图
    func log_navigationController() -> UINavigationController? {
        if self is UINavigationController {
            return self as? UINavigationController
        }
        else {
            if self is UITabBarController, let tabbar = self as? UITabBarController {
                return tabbar.selectedViewController?.log_navigationController()
            }
            else {
                return self.navigationController
            }
        }
    }
}
