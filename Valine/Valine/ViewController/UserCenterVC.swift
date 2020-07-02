//
//  UserCenterVC.swift
//  LeanData
//
//  Created by xu on 2020/7/1.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit

class UserCenterVC: BaseListVC {
 
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "个人中心"
        
        setupTableView()
        
    }
    
    

}

extension UserCenterVC {
    func setupTableView() {
        vm.sections.removeAll()
        
        // Valine应用信息
        if let valine = ValineAppModel.current {
            vm.addSection(title: "实例信息") { (sec) in
                sec.addRow(title: valine.alias, subtitle: "AppID: \(valine.id)\nAppKey: \(valine.key)") {
                    
                }
            }
        }
        
        // 个人信息
        vm.addSection(title: "个人信息") { (sec) in
            sec.addRow(title: UserManager.currentUser?.email?.stringValue, subtitle: "这是您当前登录的账号") {
                Alert.push(scene: .warning, title: "是否注销", message: "您随时可以重新登录") { (a) in
                    a.update { (vm) in
                        vm.add(action: .destructive, title: "注销") {
                            LoginManager.logout()
                            self.navigationController?.popToRootViewController(animated: true)
                            a.pop()
                        }
                        vm.add(action: .cancel, title: "取消", handler: nil)
                    }
                }
            }
        }
        
    }
}
