//
//  ActionPicker.swift
//  ActionPickerDemo
//
//  Created by USER on 2018/12/20.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

public class Picker: NSObject {
    
    private var datePicker: ActionSheetDatePicker?
    private var stringPicker: ActionSheetStringPicker?

    private lazy var doneBtn: UIButton = {
        let doneBtn = UIButton(type: .system)
        doneBtn.setTitle("确定", for: .normal)
        doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        doneBtn.setTitleColor(UIColor(red: 67.0/255.0, green: 116.0/255.0, blue: 255.0/255.0, alpha: 1), for: .normal)

        doneBtn.sizeToFit()
        return doneBtn
    }()
    
    private lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .system)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelBtn.sizeToFit()
        return cancelBtn
    }()
    
    private lazy var toolBarLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1)
        return line
    }()


    /// 时间选择器
    ///
    /// - Parameters:
    ///   - datePickerOrigin: 当前需要展示的view
    ///   - datePickerMode: UIDatePickerMode
    ///   - originDate: 展示时的起始时间，默认是当前时间
    ///   - completed: 点击完成回调
    ///   - canceled: 点击取消回调
    @discardableResult public init(datePickerOrigin: UIView, datePickerMode: UIDatePicker.Mode = .date, originDate: Date = Date(), completed: @escaping ((_ selectedDate: Date?)->())) {
        super.init()
        datePicker = ActionSheetDatePicker(title: "",
                                                  datePickerMode: datePickerMode,
                                                  selectedDate: originDate,
                                                  doneBlock: {(picker, selectedDate, originDate) in
                                                        completed(selectedDate as? Date)
                                                    }, cancel: { (picker) in
                                                    }, origin: datePickerOrigin)
        datePicker?.setDoneButton(UIBarButtonItem(customView: doneBtn))
        datePicker?.setCancelButton(UIBarButtonItem(customView: cancelBtn))
        datePicker?.locale = Locale(identifier: "zh_CN")
        showDatePicker()
    }
    
    
    /// 字符串选择器
    ///
    /// - Parameters:
    ///   - stringPickerOrigin: 当前需要展示的view
    ///   - rows: 数据源
    ///   - initialSelection: 默认选择的位置
    ///   - completed: 完成回调
    @discardableResult public init(stringPickerOrigin: UIView,rows: [String],initialSelection: Int, completed: @escaping ((Int, String?)->())) {
        super.init()
        stringPicker = ActionSheetStringPicker(title: "", rows: rows, initialSelection: initialSelection, doneBlock: { (picker, seletedIndex, value) in
            completed(seletedIndex, value as? String)
        }, cancel: { (picker) in
            
        }, origin: stringPickerOrigin)
        stringPicker?.setDoneButton(UIBarButtonItem(customView: doneBtn))
        stringPicker?.setCancelButton(UIBarButtonItem(customView: cancelBtn))
        showStringPicker()
    }
    
    private func showDatePicker() {
        datePicker?.show()
        if let toolBar = datePicker?.toolbar {
            toolBarLine.frame = CGRect(x: 0, y: toolBar.frame.height - 1, width: UIScreen.main.bounds.width, height: 1)
            toolBar.addSubview(toolBarLine)
        }
    }
    
    private func showStringPicker() {
        stringPicker?.show()
        if let toolBar = stringPicker?.toolbar {
            toolBarLine.frame = CGRect(x: 0, y: toolBar.frame.height - 1, width: UIScreen.main.bounds.width, height: 1)
            toolBar.addSubview(toolBarLine)
        }
    }
}
