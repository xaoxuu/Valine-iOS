//
//  ValineAppModel.swift
//  Valine
//
//  Created by xu on 2020/7/2.
//  Copyright © 2020 xaoxuu.com. All rights reserved.
//

import UIKit

/// Valine应用实例
struct ValineAppModel {

    var alias = ""
    var id: String
    var key: String
    
    var account: String?
    var password: String?
    
    static var current: ValineAppModel? {
        get {
            return getCurrent()
        }
        set {
            if let a = newValue {
                CacheManager.currentValineApp = ["alias":a.alias,"id":a.id,"key":a.key]
            } else {
                CacheManager.currentValineApp = nil
            }
        }
    }
    
    func save() {
        var arr = CacheManager.valineApps
        for (i,a) in arr.enumerated() {
            if a["id"] == id && a["key"] == key {
                arr.remove(at: i)
            }
        }
        arr.insert(["alias":alias,"id":id,"key":key], at: 0)
        CacheManager.valineApps = arr
    }
    static func delete(index: Int) {
        var all = CacheManager.valineApps
        if index < all.count {
            all.remove(at: index)
        }
        CacheManager.valineApps = all
    }
    static func getAll() -> [ValineAppModel] {
        let arr = CacheManager.valineApps
        var all = [ValineAppModel]()
        for dict in arr {
            if let alias = dict["alias"], let id = dict["id"], let key = dict["key"] {
                all.append(ValineAppModel(alias: alias, id: id, key: key))
            }
        }
        // ceshi
        if all.isEmpty {
            all.append(ValineAppModel(alias: "测试", id: "7yIoRlSmfX09vQCERsuWzFnx-MdYXbMMI", key: "3zCL5GFePTUjwbqLop44QFbr"))
            all.append(ValineAppModel(alias: "清空", id: "", key: ""))
        } 
        return all
    }
    static func getCurrent() -> ValineAppModel? {
        if let dict = CacheManager.currentValineApp {
            if let alias = dict["alias"], let id = dict["id"], let key = dict["key"] {
                return ValineAppModel(alias: alias, id: id, key: key)
            }
        }
        return nil
    }

}
