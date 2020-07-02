//
//  CacheManager.swift
//  Valine
//
//  Created by xu on 2020/7/2.
//  Copyright © 2020 xaoxuu.com. All rights reserved.
//

import UIKit

fileprivate let us = UserDefaults.standard



struct CacheManager {

    static var valineApps: [[String: String]] {
        get {
            if let arr = us.array(forKey: "valineApps") as? [[String: String]] {
                return arr
            } else {
                return [[String:String]]()
            }
        }
        set {
            us.set(newValue, forKey: "valineApps")
            us.synchronize()
        }
    }
    
    static var currentValineApp: [String: String]? {
        get {
            return us.dictionary(forKey: "currentValineApp") as? [String: String]
        }
        set {
            us.set(newValue, forKey: "currentValineApp")
            us.synchronize()
        }
    }

    
    
    
}
