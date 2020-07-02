//
//  SceneDelegate.swift
//  Valine
//
//  Created by xu on 2020/7/2.
//  Copyright © 2020 xaoxuu.com. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        LibManager.configInspire()
        if let app = ValineAppModel.current {
            LibManager.configLeanCloud(id: app.id, key: app.key)
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for ctx in URLContexts {
            let url = ctx.url
            let components = url.lastPathComponent.components(separatedBy: ["?","&"])
            var id: String?
            var key: String?
            var alias: String?
            var user: String?
            var psw: String?
            for c in components {
                if c.hasPrefix("id=") {
                    id = String(c.split(separator: "=")[1])
                } else if c.hasPrefix("key=") {
                    key = String(c.split(separator: "=")[1])
                } else if c.hasPrefix("alias=") {
                    alias = String(c.split(separator: "=")[1])
                } else if c.hasPrefix("user=") {
                    user = String(c.split(separator: "=")[1])
                } else if c.hasPrefix("psw=") {
                    psw = String(c.split(separator: "=")[1])
                }
            }
            
            if let id = id, let key = key {
                var selected = ValineAppModel(alias: alias ?? "", id: id, key: key)
                selected.account = user
                selected.password = psw
                ValineAppModel.current = selected
                if let u = user, let p = psw {
                    // 如果账号和密码都有，就直接登录了
                    LoginManager.login(acc: u, psw: p)
                } else {
                    NotificationCenter.default.post(name: .init("openURL.cfg"), object: selected)
                }
                
            } else {
                Alert.push(scene: .error, title: "无效的URL格式", message: "", nil)
            }
            
        }
    }
    
    
}

