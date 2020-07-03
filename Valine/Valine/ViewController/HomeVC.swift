//
//  HomeVC.swift
//  LeanData
//
//  Created by xu on 2020/7/1.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit

class HomeVC: BaseVC {
    
    let table = DataTable()
    let vm = DataVM(schema: UserDefaults.standard.string(forKey: "table") ?? "Comment")
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "评论管理"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "icloud.and.arrow.down"), style: .plain, target: self, action: #selector(didTappedLeftNavBtn(_:)))
        
        
        view.addSubview(table)
        table.snp.makeConstraints { (mk) in
            mk.edges.equalToSuperview()
        }
        table.dataSource = vm
        table.delegate = vm
        vm.view = table
        vm.controller = self
        
        
        if LoginManager.isLogin {
            reloadData(toast: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onNeedReload(_:)), name: NSNotification.Name.init("reload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onLogin(_:)), name: NSNotification.Name.init("onLogin"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if LoginManager.isLogin == false {
            let vc = LoginConfigVC()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false, completion: nil)
            title = "欢迎"
            navigationItem.leftBarButtonItem?.isEnabled = false
        } else {
            title = "评论管理"
            navigationItem.leftBarButtonItem?.isEnabled = true
            reloadData(toast: false, completion: nil)
        }
    }
    
    override func loadRightNavBtnImage() -> UIImage? {
        if let user = UserManager.currentUser {
            return user.avatar ?? UIImage(systemName: "person.crop.circle.fill")
        } else {
            return UIImage(systemName: "person.crop.circle.fill")
        }
    }
    
    override func didTappedRightNavBtn(_ sender: UIBarButtonItem) {
        if LoginManager.isLogin {
            // 进入用户中心
            navigationController?.pushViewController(UserCenterVC(), animated: true)
        } else {
            // 登录
            viewWillAppear(false)
        }
    }
    
    @objc func didTappedLeftNavBtn(_ sender: UIBarButtonItem) {
        if LoginManager.isLogin {
            reloadData(toast: true, completion: nil)
        } else {
            // 登录
            LoginManager.login(from: self)
        }
    }
    
    @objc func onNeedReload(_ sender: NSNotification) {
        reloadData(toast: false, completion: nil)
    }
    @objc func onLogin(_ sender: NSNotification) {
        self.navigationController?.popToRootViewController(animated: true)
        reloadData(toast: false, completion: nil)
    }
    private var isReloading = false
    func reloadData(toast: Bool = true, completion: (() -> Void)? = nil) {
        if toast {
            Alert.push("reloadData", scene: .refresh) { (vc) in
                vc.update { (vm) in
                    vm.add(action: .default, title: "隐藏") {
                        vc.pop()
                    }
                }
            }
        }
        guard isReloading == false else { return }
        isReloading = true
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        let schema = UserDefaults.standard.string(forKey: "table") ?? "Comment"
        vm.schema = schema
        vm.reload { (err) in
            self.isReloading = false
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            if toast {
                if let e = err {
                    Alert.push("reloadData") { (vc) in
                        vc.update { (vm) in
                            vm.scene = .error
                            vm.title = "刷新失败"
                            vm.message = e.reason
                        }
                    }
                } else {
                    Alert.pop("reloadData")
                }
            }
            completion?()
        }
    }
    
}
