//
//  LoginConfigVC.swift
//  Valine
//
//  Created by xu on 2020/7/2.
//  Copyright © 2020 xaoxuu.com. All rights reserved.
//

import UIKit

class LoginConfigVC: BaseVC {

    let titleLabel = UILabel()
    
    var addBtn = UIButton()
    
    var ts = [[String]]()
    var cs = [[Callback]]()
    
    var vm = Table()
    var secs = [Section]()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = .bold(28)
        titleLabel.text = "选择一个应用"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (mk) in
            mk.top.equalToSuperview().offset(ipr.screen.safeAreaInsets.top + margin)
            mk.left.equalToSuperview().offset(margin)
            mk.height.equalTo(64)
        }
        
        addBtn = BaseButton(image: UIImage(systemName: "plus.circle.fill"), handler: { [weak self] in
            let vc = LoginConfigEditVC()
            self?.present(vc, animated: true, completion: nil)
        })
        addBtn.imageView?.snp.makeConstraints({ (mk) in
            mk.width.height.equalTo(36)
        })
        view.addSubview(addBtn)
        addBtn.snp.makeConstraints { (mk) in
            mk.centerY.equalTo(titleLabel).offset(-4)
            mk.width.equalTo(addBtn.snp.height)
            mk.right.equalToSuperview().offset(-margin)
        }
        
        reloadData()
        
        NotificationCenter.default.rx.notification(.init("onLogin")).subscribe(onNext: { [weak self] (notification) in
            self?.presentingViewController?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.init("reloadConfig")).subscribe(onNext: { [weak self] (notification) in
            self?.reloadData()
        }).disposed(by: disposeBag)
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
                mk.top.equalTo(titleLabel.snp.bottom)
            }
            vm.sections.removeAll()
            for a in all {
                vm.addSection(title: "") { (sec) in
                    sec.addRow(title: a.alias, subtitle: "id: '\(a.id)'\nkey: '\(a.key)'") { [weak self] in
                        // 登录
                        if let `self` = self, LibManager.configLeanCloud(id: a.id, key: a.key) {
                            ValineAppModel.current = a
                            let vc = LoginManager.login(from: self)
                            vc.onDismiss { [weak self] in
                                self?.reloadData()
                            }
                        }
                    }
                }
            }
            
            tableView.reloadData()
        } else {
            tableView.removeFromSuperview()
        }
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
            cell.textLabel?.font = .bold(20)
            cell.detailTextLabel?.font = .regular(12)
            cell.textLabel?.snp.makeConstraints({ (mk) in
                mk.top.equalToSuperview().offset(margin)
                mk.left.equalToSuperview().offset(margin)
                mk.right.equalToSuperview().offset(-margin)
            })
            cell.detailTextLabel?.snp.makeConstraints({ (mk) in
                mk.bottom.equalToSuperview().offset(-margin)
                mk.left.right.equalTo(cell.textLabel!)
                mk.top.equalTo(cell.textLabel!.snp.bottom).offset(margin/2)
            })
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
            if indexPath.section < vm.sections.count {
                vm.sections.remove(at: indexPath.section)
                tableView.deleteSections([indexPath.section], with: .fade)
                ValineAppModel.delete(index: indexPath.section)
            }
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

