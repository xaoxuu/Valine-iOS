//
//  LibManager.swift
//  Valine
//
//  Created by xu on 2020/7/2.
//  Copyright © 2020 xaoxuu.com. All rights reserved.
//

import UIKit
import LeanCloud
@_exported import SnapKit
@_exported import Inspire
@_exported import ProHUD
@_exported import RxSwift
@_exported import RxCocoa


var ipr: Inspire {
    return Inspire.shared
}


struct LibManager {

    @discardableResult
    static func configLeanCloud(id: String, key: String) -> Bool {
        var configuration = LCApplication.Configuration.default
        configuration.HTTPURLCache = URLCache(memoryCapacity: 100 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024)
        do {
            try LCApplication.default.set(id: id, key: key, configuration: configuration)
            LCApplication.logLevel = .debug
            return true
        } catch {
            Alert.push("error", scene: .error) { (a) in
                a.update { (vm) in
                    vm.title = "配置失败"
                    vm.message = "找不到云应用实例"
                    vm.add(action: .default, title: "我知道了", handler: nil)
                }
            }
            return false
        }
    }
    
    
    static func configInspire() {
        Inspire.shared.layout.margin = 20
        Inspire.shared.font.body = "Courier-Bold"
        Inspire.shared.color.accent = UIColor("#32C5FF")
    }
    
    
}
