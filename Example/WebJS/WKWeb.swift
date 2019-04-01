//
//  WKWeb.swift
//  Example
//
//  Created by senyuhao on 2018/10/25.
//  Copyright © 2018年 dd01. All rights reserved.
//

import UIKit
import WebKit
import DDKit

class WKWeb: UIViewController {

    private var web: WKWebView = WKWebView(frame: CGRect(), configuration: WKWebViewConfiguration())

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        web.navigationDelegate = self
        web.uiDelegate = self
        view.addSubview(web)
        web.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view)
        }
        WebManager.shared.configManager(web)
        WebManager.shared.configBlock = { value, block in
            let param = ["vendor": "123",
                         "ios": "234"]
            if let value = WebManager.shared.callback(err: nil, response: param) {
                print("config = \(value)")
                block?(value)
            }
        }
        WebManager.shared.sendBlock = { value, block in
            if let value = WebManager.shared.callback(err: nil, response: "send response") {
                print("send = \(value)")
                block?(value)
            }
        }
        WebManager.shared.requestBlock = { value, block in
            if let value = WebManager.shared.callback(err: nil, response: "request response") {
                print("request = \(value)")
                block?(value)
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .done, target: self, action: #selector(itemClick))

        loadPage(webView: web)
    }

    private func loadPage(webView: WKWebView) {
        if let path = Bundle.main.path(forResource: "demo1", ofType: "html"),
            let html = try? String(contentsOfFile: path, encoding: .utf8) {
            let url = URL(fileURLWithPath: path)
            webView.loadHTMLString(html, baseURL: url)
        }
    }

    @objc private func itemClick() {
        if let param = WebManager.shared.callback(err: nil, response: "request response") {
            WebManager.shared.push(param: param) { value in
                print("push result = \(String(describing: value))")
            }
        }

    }
}

extension WKWeb: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation) {

    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
        print("开始加载")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        print("加载完成")
        WebManager.shared.configFinished()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation, withError error: Error) {
        print("加载失败")
    }

}

extension WKWeb: WKUIDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

    }

    @available(iOS 10.0, *)
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return true
    }

    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {

    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {

    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("message \(message)")

        let vc = UIAlertController(title: "弹窗", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { _ in
            completionHandler()
        }
        vc.addAction(action)
        self.present(vc, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("message \(message)")

        let vc = UIAlertController(title: "弹窗", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { _ in
            completionHandler(true)
        }
        vc.addAction(action)
        self.present(vc, animated: true, completion: nil)
    }
}
