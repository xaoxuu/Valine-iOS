//
//  LoginConfigEditVC.swift
//  Valine
//
//  Created by xu on 2020/7/3.
//  Copyright © 2020 xaoxuu.com. All rights reserved.
//

import UIKit

class LoginConfigEditVC: BaseVC {

    let tfAlias = InputBar(prefix: "别名", placeholder: "请设置一个别名")
    let tfID = InputBar(prefix: "AppID", placeholder: "请输入Valine的AppID")
    let tfKEY = InputBar(prefix: "AppKey", placeholder: "请输入Valine的AppKey")
    
    var loginBtn: BaseButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleLabel = UILabel()
        titleLabel.font = .bold(28)
        titleLabel.text = "新增应用配置"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (mk) in
            mk.top.equalToSuperview().offset(margin * 2)
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
            self?.input(step: 1)
        }).disposed(by: disposeBag)
        tfID.tf.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] (void) in
            self?.input(step: 2)
        }).disposed(by: disposeBag)
        tfKEY.tf.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] (void) in
            self?.login()
        }).disposed(by: disposeBag)
        
        loginBtn = BaseButton(title: "保存") { [weak self] in
            self?.login()
        }
        
        view.addSubview(loginBtn!)
        loginBtn?.snp.makeConstraints { (mk) in
            mk.top.equalTo(inputArea.snp.bottom).offset(margin)
            mk.left.right.equalTo(inputArea)
            mk.height.equalTo(50)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        input(step: 0)
    }
    
    func input(step: Int) {
        view.endEditing(true)
        switch step {
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
            input(step: 0)
            return
        }
        if tfID.tf.text?.isEmpty ?? true {
            input(step: 1)
            return
        }
        if tfKEY.tf.text?.isEmpty ?? true {
            input(step: 2)
            return
        }
        if let alias = tfAlias.tf.text, let id = tfID.tf.text, let key = tfKEY.tf.text {
            let a = ValineAppModel(alias: alias, id: id, key: key)
            a.save()
            NotificationCenter.default.post(name: .init("reloadConfig"), object: nil)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
}
