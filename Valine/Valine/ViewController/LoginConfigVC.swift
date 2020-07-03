//
//  LoginConfigVC.swift
//  Valine
//
//  Created by xu on 2020/7/2.
//  Copyright © 2020 xaoxuu.com. All rights reserved.
//

import UIKit

class LoginConfigVC: BaseVC {
    
    let tfAlias = InputBar(prefix: "别名", placeholder: "请设置一个别名")
    let tfID = InputBar(prefix: "AppID", placeholder: "请输入Valine的AppID")
    let tfKEY = InputBar(prefix: "AppKey", placeholder: "请输入Valine的AppKey")

    
    var ts = [[String]]()
    var cs = [[Callback]]()
    
    var vm = Table()
    var secs = [Section]()
    
    var loginBtn: BaseButton?
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel()
        titleLabel.font = .bold(28)
        titleLabel.text = "环境配置"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (mk) in
            mk.top.equalToSuperview().offset(ipr.screen.safeAreaInsets.top + margin*2)
            mk.left.equalToSuperview().offset(margin)
            mk.height.equalTo(64)
        }
        
        let inputArea = UIView()
        inputArea.backgroundColor = .secondarySystemBackground
        inputArea.layer.cornerRadius = ipr.layout.cornerRadius.medium
        
        tfAlias.tf.returnKeyType = .next
        tfID.tf.returnKeyType = .next
        
        
        view.addSubview(inputArea)
        inputArea.addSubview(tfAlias)
        inputArea.addSubview(tfID)
        inputArea.addSubview(tfKEY)
        
        inputArea.snp.makeConstraints { (mk) in
            mk.top.equalTo(titleLabel.snp.bottom).offset(margin)
            mk.centerX.equalToSuperview()
            mk.width.equalToSuperview().offset(-2*margin)
        }
        tfAlias.snp.makeConstraints { (mk) in
            mk.height.equalTo(72)
            mk.top.equalToSuperview().offset(4)
            mk.left.equalToSuperview().offset(4)
            mk.right.equalToSuperview().offset(-4)
        }
        
        tfID.snp.makeConstraints { (mk) in
            mk.height.left.right.equalTo(tfAlias)
            mk.top.equalTo(tfAlias.snp.bottom).offset(0)
        }
        
        tfKEY.snp.makeConstraints { (mk) in
            mk.height.left.right.equalTo(tfAlias)
            mk.top.equalTo(tfID.snp.bottom).offset(0)
            mk.bottom.equalToSuperview().offset(-4)
        }
        tfAlias.tf.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] (void) in
            self?.input(idx: 1)
        }).disposed(by: disposeBag)
        tfID.tf.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] (void) in
            self?.input(idx: 2)
        }).disposed(by: disposeBag)
        tfKEY.tf.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] (void) in
            self?.login()
        }).disposed(by: disposeBag)
        
        loginBtn = BaseButton(title: "去登录") { [weak self] in
            self?.login()
        }
        
        
        
        view.addSubview(loginBtn!)
        loginBtn?.snp.makeConstraints { (mk) in
            mk.top.equalTo(inputArea.snp.bottom).offset(margin)
            mk.left.right.equalTo(inputArea)
            mk.height.equalTo(50)
        }
        
        reloadData()
        
        setupDefaultText()
        
        NotificationCenter.default.rx.notification(.init("openURL.cfg")).subscribe(onNext: { [weak self] (notification) in
            if let a = notification.object as? ValineAppModel {
                self?.setupDefaultText(a)
            }
        }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(.init("onLogin")).subscribe(onNext: { [weak self] (notification) in
            self?.dismiss(animated: true, completion: nil)
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
    }
    
    func input(idx: Int) {
        view.endEditing(true)
        switch idx {
        case 0:
            tfAlias.tf.becomeFirstResponder()
        case 1:
            tfID.tf.becomeFirstResponder()
        case 2:
            tfKEY.tf.becomeFirstResponder()
        default:
            break
        }
    }
    func login() {
        view.endEditing(true)
        if tfAlias.tf.text?.isEmpty ?? true {
            input(idx: 0)
            return
        }
        if tfID.tf.text?.isEmpty ?? true {
            input(idx: 1)
            return
        }
        if tfKEY.tf.text?.isEmpty ?? true {
            input(idx: 2)
            return
        }
        if let alias = tfAlias.tf.text, let id = tfID.tf.text, let key = tfKEY.tf.text {
            if LibManager.configLeanCloud(id: id, key: key) {
                let vc = LoginManager.login(from: self)
                vc.onDismiss { [weak self] in
                    self?.reloadData()
                }
                let a = ValineAppModel(alias: alias, id: id, key: key)
                a.save()
                ValineAppModel.current = a
            }
        }
    }
    func setupDefaultText(_ model: ValineAppModel? = .current) {
        if let a = model {
            tfAlias.tf.text = a.alias
            tfID.tf.text = a.id
            tfKEY.tf.text = a.key
            if let u = a.account, let p = a.password {
                // 如果账号和密码都有，就直接登录了
                LoginManager.login(acc: u, psw: p)
            } else {
                
            }
        }
    }
    
    func reloadData() {
        let all = ValineAppModel.getAll()
        if all.count > 0 {
            view.addSubview(tableView)
            tableView.backgroundColor = .clear
            tableView.dataSource = self
            tableView.delegate = self
            tableView.snp.makeConstraints { (mk) in
                mk.left.right.bottom.equalToSuperview()
                mk.top.equalTo(loginBtn!.snp.bottom).offset(margin)
            }
            vm.sections.removeAll()
            vm.addSection(title: "最近使用的配置") { (sec) in
                for a in all {
                    sec.addRow(title: a.alias, subtitle: "id: \(a.id)\nkey: \(a.key)") { [weak self] in
                        self?.tfAlias.tf.text = a.alias
                        self?.tfID.tf.text = a.id
                        self?.tfKEY.tf.text = a.key
                    }
                }
            }
            tableView.reloadData()
        } else {
            tableView.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

}

extension LoginConfigVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = c
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.backgroundColor = .secondarySystemBackground
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.textColor = .gray
            cell.detailTextLabel?.numberOfLines = 0
            cell.accessoryType = .disclosureIndicator
        }
        cell.textLabel?.text = vm.sections[indexPath.section].rows[indexPath.row].title
        cell.detailTextLabel?.text = vm.sections[indexPath.section].rows[indexPath.row].subtitle
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return vm.sections[section].header
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return vm.sections[section].footer
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        vm.sections[indexPath.section].rows[indexPath.row].callback()
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.row < vm.sections[0].rows.count {
                vm.sections[0].rows.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                ValineAppModel.delete(index: indexPath.row)
            }
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

