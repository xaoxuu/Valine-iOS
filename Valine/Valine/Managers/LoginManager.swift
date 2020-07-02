//
//  LoginManager.swift
//  LeanData
//
//  Created by xu on 2020/6/30.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit
import LoginUI
import LeanCloud
import ProHUD

struct LoginManager {
    
    static var isLogin: Bool {
        if let _ = LCApplication.default.currentUser {
            return true
        } else {
            return false
        }
    }

    static private var loginCallback: (() -> Void)?
    static func logout() {
        LCUser.logOut()
    }
    
    static func onLogin(callback: @escaping () -> Void) {
        loginCallback = callback
    }
    
    @discardableResult
    static func login(from vc: UIViewController) -> LoginVC {
        // 设置登录
        LoginUI.logo = UIImage(named: "logo")
        LoginUI.dismissIcon = UIImage(named: "prohud.xmark")
        LoginUI.title = "Valine"
        LoginUI.agreementURL = URL(string: "https://xaoxuu.com")
        LoginUI.onTappedLogin { (acc, psw) in
            login(acc: acc, psw: psw)
        }
        
        LoginUI.onTappedSignup { (acc, psw) in
            Alert.push("login", scene: .signup)
            DispatchQueue.global().async {
                let user = LCUser()
                user.username = LCString(acc)
                user.password = LCString(psw)
                user.email = user.username
                user.signUp { (result) in
                    ErrorManager(lcError: result.error)
                    switch result {
                    case .success:
                        break
                    case .failure(let error):
                        debugPrint(error)
                    }
                    DispatchQueue.main.async {
                        LoginUI.unlockButtons()
                        Alert.push("login") { (vc) in
                            vc.update { (vm) in
                                if result.isSuccess {
                                    vm.scene = .success
                                    vm.title = "注册成功"
                                } else {
                                    vm.scene = .failure
                                    vm.title = "注册失败"
                                    vm.message = result.error?.localizedDescription
                                }
                            }
                            
                        }
                    }
                }
                
            }
        }
        LoginUI.onTappedForgotPassword { (email) in
            Alert.push("reseting", scene: .loading) { (a) in
                a.update { (vm) in
                    vm.title = "请稍等"
                    vm.message = ""
                }
            }
            let _ = LCUser.requestPasswordReset(email: email) { (result) in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    ErrorManager(lcError: result.error, id: "reseting")
                    switch result {
                    case .success:
                        Alert.push("reseting", scene: .success) { (a) in
                            a.update { (vm) in
                                vm.title = "操作成功"
                                vm.message = "密码重置邮件已经发送到您的邮箱"
                            }
                        }
                    case .failure(let error):
                        debugPrint(error)
                    }
                })
            }
        }
        LoginUI.accountDefault = UserDefaults.standard.string(forKey: "leancloud.account")
        return LoginUI.present(from: vc)
    }
    
    static func login(acc: String, psw: String) {
        if let a = ValineAppModel.current {
            LibManager.configLeanCloud(id: a.id, key: a.key)
            a.save()
        }
        Alert.push("login", scene: .login)
        let _ = LCUser.logIn(username: acc, password: psw) { (result) in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                ErrorManager(lcError: result.error)
                switch result {
                case .success:
                    if let sessionToken = result.object?.sessionToken {
                        UserDefaults.standard.set(sessionToken.rawValue, forKey: "leancloud.sessionToken")
                        UserDefaults.standard.set(acc, forKey: "leancloud.account")
                        UserDefaults.standard.synchronize()
                    }
                case .failure(let error):
                    debugPrint(error)
                }
                DispatchQueue.main.async {
                    LoginUI.unlockButtons()
                    Alert.push("login") { (vc) in
                        vc.update { (vm) in
                            if result.isSuccess {
                                vm.scene = .success
                                vm.title = "登录成功"
                                loginCallback?()
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                                    LoginUI.dismiss()
                                }
                                NotificationCenter.default.post(name: .init("onLogin"), object: nil)
                            } else {
                                vm.scene = .failure
                                vm.title = "登录失败"
                                vm.message = result.error?.localizedDescription
                            }
                        }
                    }
                }
            })
        }
    }
    
}

extension ProHUD.Scene {
    static var login: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "login.rotate")
        scene.image = UIImage(named: "prohud.rainbow.circle")
        scene.title = "正在登录"
        scene.alertDuration = 0
        scene.toastDuration = 0
        return scene
    }
    static var signup: ProHUD.Scene {
        var scene = ProHUD.Scene.init(identifier: "signup.rotate")
        scene.image = UIImage(named: "prohud.rainbow.circle")
        scene.title = "正在注册"
        scene.alertDuration = 0
        scene.toastDuration = 0
        return scene
    }
}
