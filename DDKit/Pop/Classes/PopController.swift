//
//  PopController.swift
//  EatojoyBiz
//
//  Created by 胡峰 on 2016/10/31.
//  Copyright © 2018年 dd01. All rights reserved.
//

import CoreGraphics
import UIKit

class PopController: UIPresentationController {
    
    var style = PopControllerStyle.alert
    var tapToDimiss: (() -> Bool)?

    private var keyboardFrame: CGRect?
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let size = presentedViewController.preferredContentSize
        let containerSize = containerView?.bounds.size ?? size
        switch style {
        case .alert:
            return CGRect(x: (containerSize.width - size.width) / 2.0, y: (containerSize.height - size.height) / 2.0, width: size.width, height: size.height)
        case .actionSheet, .actionSheetPad:
            return CGRect(x: 0, y: containerSize.height - size.height, width: containerSize.width, height: size.height)
        case .popover:
            assertionFailure("popover 不应该使用 PopController")
            return CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }
    }
    
    // MARK: -
    private lazy var backgroundView = UIView()
    
    override func presentationTransitionWillBegin() {
        backgroundView.frame = containerView?.bounds ?? UIScreen.main.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:))))
        if let presentedView = presentedView {
            containerView?.insertSubview(backgroundView, belowSubview: presentedView)
        } else {
            containerView?.addSubview(backgroundView)
        }
        presentingViewController.transitionCoordinator?.animate( alongsideTransition: { _ in
            self.backgroundView.alpha = 0.4
        }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            backgroundView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        presentingViewController.transitionCoordinator?.animate( alongsideTransition: { _ in
            self.backgroundView.alpha = 0.0
        }, completion: { _ in
            self.backgroundView.removeFromSuperview()
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        backgroundView.removeFromSuperview()
    }
    
    @objc private func tapGestureAction(_ sender: UITapGestureRecognizer) {
        if tapToDimiss?() ?? true {
            presentedView?.endEditing(false)
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func updateKeyboard(_ frame: CGRect) {
        keyboardFrame = frame
        if style == .alert {
            UIView.animate(withDuration: 0.25) {
                self.presentedView?.transform = CGAffineTransform(translationX: 0, y: frame.origin.y < 500 ? -108: 0)
            }
        }
    }
    
}
