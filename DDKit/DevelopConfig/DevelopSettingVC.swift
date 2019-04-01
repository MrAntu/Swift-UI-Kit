//
//  DevelopSettingVC.swift
//  Hotel
//
//  Created by senyuhao on 2018/12/3.
//  Copyright © 2018 HK01. All rights reserved.
//

import UIKit

class DevelopSettingVC: UITableViewController {

    private var currentHost = ""    //已经设置的 Host
    private var selectedHost = ""   //选中或输入的 Host
    private var isInput = false

    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
    }

    private func configView() {
        if let hostStr = UserDefaults.standard.value(forKey: "DD-Environment-Host") as? String {
            currentHost = hostStr
        } else {
            currentHost = DevelopManager.shared.currentHost
        }
        selectedHost = currentHost

        navigationItem.title = NSLocalizedString("开发者选项", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("取消", comment: ""), style: .plain, target: self, action: #selector(cancelBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("确定", comment: ""), style: .plain, target: self, action: #selector(confirmBtnClick))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        
        tableView.register(DevelopInputConfigCell.self, forCellReuseIdentifier: "DevelopInputConfigCell")
        
        isInput = !DevelopManager.shared.hostInfos.values.contains(currentHost)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        gesture.delegate = self
        tableView.addGestureRecognizer(gesture)
    }

    // MARK: Action
    
    @objc private func tapAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc private func cancelBtnClick() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    @objc private func confirmBtnClick() {
        view.endEditing(true)
        
        let updateClosure:((_ isChanged: Bool) -> Void) = { [weak self] (isChanged) in
            if isChanged {
                print("DevelopManager is setting host：\(self?.selectedHost ?? "unKnow host")")
                UserDefaults.standard.set(self?.selectedHost, forKey: "DD-Environment-Host")
                NotificationCenter.default.post(name: NSNotification.Name("\(DevelopManager.shared.notificationN)"), object: nil)
                DevelopManager.shared.changeHostHandle?()
            }
        
            self?.dismiss(animated: isChanged, completion: nil)
        }
        
        guard selectedHost != currentHost else {
            updateClosure(false)
            return
        }
        
        guard selectedHost.lowercased().contains("http://") else {
            self.showAlert("host 输入错误，请重新输入！")
            return
        }
    
        updateClosure(true)
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - TableView Delegate

extension DevelopSettingVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < DevelopManager.shared.hostInfos.count {
            let values = Array(DevelopManager.shared.hostInfos.values)
            selectedHost = values[indexPath.row]
            tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? DevelopManager.shared.hostInfos.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DevelopInputConfigCell") as? DevelopInputConfigCell
            if DevelopManager.shared.hostInfos.values.contains(selectedHost) {
                cell?.updateCell("")
            }
            else {
                cell?.updateCell(selectedHost)
                
            }
            cell?.inputBlock = { [weak self] (value, isBeginEdit) in
                self?.selectedHost = value
                if isBeginEdit {
                    self?.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
                }
            }
            return cell ?? UITableViewCell()
        }

        var cell = tableView.dequeueReusableCell(withIdentifier: "devReuseIdentifier")
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "devReuseIdentifier")
        }
        let keys = Array(DevelopManager.shared.hostInfos.keys)
        let values = Array(DevelopManager.shared.hostInfos.values)
        cell?.textLabel?.text = "\(keys[indexPath.row])"
        cell?.detailTextLabel?.text = "\(values[indexPath.row])"
        cell?.accessoryType = values[indexPath.row] == selectedHost ? .checkmark : .none
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? NSLocalizedString("host的切换", comment: "") : NSLocalizedString("host的自定义输入", comment: "")
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 1 ? NSLocalizedString("切换host以后应该重新登录", comment: "") : nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0001 : 30
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension DevelopSettingVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView = touch.view {
            let className = String(describing: touchView.self)
            if className.contains("UITableViewCellContentView") {
                return false
            }
        }
        return true
    }
}
