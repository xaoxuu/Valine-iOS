//
//  ErrorManager.swift
//  Valine
//
//  Created by xu on 2020/7/2.
//  Copyright © 2020 xaoxuu.com. All rights reserved.
//

import UIKit
import LeanCloud

struct ErrorManager {
 
    
    @discardableResult
    init(error: Error?, id: String? = "error") {
        if let err = error {
            Alert.push(id ?? "error", scene: .error) { (a) in
                a.update { (vm) in
                    vm.title = "操作失败"
                    vm.message = err.localizedDescription
                    vm.add(action: .default, title: "我知道了", handler: nil)
                }
            } 
        }
    }
    
    @discardableResult
    init(lcError: LCError?, id: String? = "error") {
        if let err = lcError {
            Alert.push(id ?? "error:\(err.code)", scene: .error) { (a) in
                a.update { (vm) in
                    switch err.code {
                    case 403:
                        vm.title = "操作失败"
                        vm.message = "您没有操作权限，请在LeanCloud网页端把您当前登录的账户添加到admin角色中。"
                    default:
                        vm.title = "操作失败"
                        vm.message = err.reason
                    }
                    vm.add(action: .default, title: "我知道了", handler: nil)
                }
            }
            
        }
    }
    
}
