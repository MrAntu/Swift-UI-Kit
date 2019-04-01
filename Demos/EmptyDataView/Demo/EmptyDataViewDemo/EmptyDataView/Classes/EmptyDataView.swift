//
//  BlankPageView.swift
//  DDMall
//
//  Created by cw on 2018/3/23.
//  Copyright © 2018年 dd01. All rights reserved.
//

import SnapKit
import UIKit


/// EmptyDataManager用户管理dataSources
public class EmptyDataManager: NSObject {
    public static let shared = EmptyDataManager()
    public var dataSources: [EmptyDataConfig]?
}


public struct EmptyDataConfig {
    public var title: String?
    public var image: UIImage?
    // Name的值请从0开始
    public var  name: EmptyDataConfig.Name
    public init(name: EmptyDataConfig.Name, title: String?, image: UIImage?) {
        self.name = name
        self.title = title
        self.image = image
    }
}

extension EmptyDataConfig {
    // Name的值请从0开始
    public struct Name : Hashable, Equatable, RawRepresentable  {
        public var rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

public typealias  EmptyDataClickBlock = (() -> Void)?

extension UIView {
    private struct EmptyDataKey {
        static var managerKey = "EmptyDateViewKey"
        static var emptyDataSources = "emptyDataSources"
    }
    
    public var emptyDataSources: [EmptyDataConfig]? {
        set (value) {
            objc_setAssociatedObject(self, &EmptyDataKey.emptyDataSources, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &EmptyDataKey.emptyDataSources) as? [EmptyDataConfig]
        }
    }

    
    fileprivate var blankView: EmptyDataView? {
        set (value) {
            objc_setAssociatedObject(self, &EmptyDataKey.managerKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &EmptyDataKey.managerKey) as? EmptyDataView
        }
    }
    
    fileprivate var blankPageContainer: UIView {
        var bView = self
        for view in subviews {
            if let view = view as? UIScrollView {
                bView = view
            }
        }
        return bView
    }
    
    /// scrollView或者view直接调用
    ///
    /// - Parameters:
    ///   - type: 类型
    ///   - offSet: 中心点偏移的位置
    ///   - showImage: 是否显示图片
    ///   - showButton: 是否显示按钮
    ///   - btnTitle: 按钮的title
    ///   - hasData: 是否有数据
    ///   - clickAction: 按钮点击回调
    public func emptyDataView(name: EmptyDataConfig.Name,
                              hasData: Bool,
                              offSet: CGPoint = CGPoint.zero,
                              showImage: Bool = true,
                              showButton: Bool = false,
                              btnTitle: String = "确定",
                              clickAction: EmptyDataClickBlock = nil) {
        guard !hasData,
            let dataSources = EmptyDataManager.shared.dataSources else {
            cleanBlankView()
            setScrollEnabled(true)
            return
        }
        
        if blankView == nil {
            blankView = EmptyDataView(frame: bounds)
            blankView?.isUserInteractionEnabled = true
        }
        blankView?.isHidden = false
        blankView?.backgroundColor = backgroundColor
        if let blankView = blankView {
            blankPageContainer.insertSubview(blankView, at: 0)
        }
    
        setScrollEnabled(false)
        let result: EmptyDataClickBlock = {[weak self] in
            self?.cleanBlankView()
            self?.setScrollEnabled(true)
            clickAction?()
        }
        
        blankView?.config(name: name,
                          sources: dataSources,
                          offSet: offSet,
                          showImage: showImage,
                          showButton: showButton,
                          btnTitle: btnTitle,
                          hasData: hasData,
                          clickAction: result)
    }
    
    private func cleanBlankView() {
        blankView?.isHidden = true
        blankView?.removeFromSuperview()
        blankView = nil
    }
    
    private func setScrollEnabled(_ enabled: Bool) {
        if let scroll = blankPageContainer as? UIScrollView {
            scroll.isScrollEnabled = enabled
        }
    }
}

public class EmptyDataView: UIView {
    public let blankImage = UIImageView(frame: CGRect.zero)
    public let tipLabel = UILabel(frame: CGRect.zero)
    public let operateButton = UIButton(type: .custom)
    var clickBlock: EmptyDataClickBlock
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func config(name: EmptyDataConfig.Name,
                            sources: [EmptyDataConfig],
                            offSet: CGPoint,
                            showImage: Bool,
                            showButton: Bool,
                            btnTitle: String,
                            hasData: Bool,
                            clickAction: EmptyDataClickBlock) {
        guard !hasData else {
            removeFromSuperview()
            return
        }
        blankImage.isHidden = !showImage
        addSubview(blankImage)
        blankImage.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX).offset(offSet.x)
            make.centerY.equalTo(snp.centerY).offset(-40 + offSet.y)
        }
        tipLabel.font = UIFont.systemFont(ofSize: 16)
        tipLabel.textColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1)
        tipLabel.textAlignment = .center
        addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.left.equalTo(snp.left).offset(20)
            make.right.equalTo(snp.right).offset(-20)
            if showImage {
                make.top.equalTo(blankImage.snp.bottom).offset(10)
            } else {
                make.centerY.equalTo(snp.centerY).offset(-40 + offSet.y)
            }
        }
        operateButton.isHidden = !showButton
        addSubview(operateButton)
        operateButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(44)
            make.centerX.equalTo(snp.centerX).offset(offSet.x)
            make.top.equalTo(tipLabel.snp.bottom).offset(40)
        }
        operateButton.setTitleColor( #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        operateButton.backgroundColor = #colorLiteral(red: 0, green: 0.5803921569, blue: 1, alpha: 1)
        operateButton.setTitle(btnTitle, for: .normal)
        operateButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        operateButton.addTarget(self, action: #selector(clickBtnAction), for: .touchUpInside)
        clickBlock = clickAction
        updateContent(name: name, dataSources: sources)
    }
    
    @objc func clickBtnAction() {
        clickBlock?()
    }
    
    private func updateContent(name: EmptyDataConfig.Name, dataSources: [EmptyDataConfig]) {
        print(name.rawValue)
        if name.rawValue < dataSources.count && name.rawValue >= 0 {
            let config = dataSources[name.rawValue]
            blankImage.image = config.image
            tipLabel.text = config.title
            return
        }
    }
    
}
