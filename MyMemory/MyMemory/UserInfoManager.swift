//
//  UserInfoManager.swift
//  UserInfoManager
//
//  Created by bigzero on 2021/08/07.
//

import UIKit

struct UserInfoKey {
    static let loginId = "LOGIN_ID"
    static let account = "ACCOUNT"
    static let name = "NAME"
    static let profile  = "PROFILE"
    static let tutorial = "TUTORIAL"
}

class UserInfoManager {
    var loginId: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserInfoKey.loginId)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.loginId)
            ud.synchronize()
        }
    }
    
    var account: String? {  // 비로그인 일 경우 nil 이므로 optional
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.account)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.account)
            ud.synchronize()
        }
    }
    
    var name: String? {  // 비로그인 일 경우 nil 이므로 optional
        get {
            return UserDefaults.standard.string(forKey: UserInfoKey.name)
        }
        set(v) {
            let ud = UserDefaults.standard
            ud.set(v, forKey: UserInfoKey.name)
            ud.synchronize()
        }
    }
    
    var profile: UIImage? {  // 비로그인 일 경우 nil 이므로 optional
        get {
            let ud = UserDefaults.standard
            if let _profile = ud.data(forKey: UserInfoKey.profile) {
               return UIImage(data: _profile)
            } else {
//                return UIImage(named: "account.jpg")
                return UIImage(named: "튜브9.png")
            }
        }
        set(v) {
            if v != nil {
                let ud = UserDefaults.standard
                ud.set(UIImage.pngData(v!), forKey: UserInfoKey.profile)
                ud.synchronize()
            }
        }
    }
    
    var isLogin: Bool {
        return (self.loginId == 0 || self.account == nil) ? false : true
    }
    
    func login(account: String, passwd: String) -> Bool {
        if account.isEqual("bigzero@outlook.kr") && passwd.isEqual("1234") {
            let ud = UserDefaults.standard
            ud.set(100, forKey: UserInfoKey.loginId)
            ud.set(account, forKey: UserInfoKey.account)
            ud.set("bigzero", forKey: UserInfoKey.name)
            ud.synchronize()
            return true
        } else {
            return false
        }
    }
   
    func logout() -> Bool {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: UserInfoKey.loginId)
        ud.removeObject(forKey: UserInfoKey.account)
        ud.removeObject(forKey: UserInfoKey.name)
        ud.removeObject(forKey: UserInfoKey.profile)
        ud.synchronize()
        return true
    }
}
