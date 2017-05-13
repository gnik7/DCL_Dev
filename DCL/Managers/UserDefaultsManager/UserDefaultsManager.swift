//
//  UserDefaultsManager.swift
//  DCL
//
//  Created by Nikita on 3/13/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation

struct UserDefaultsManager {
    
    static let kFBTokenKey = "FBTokenKey"
    static let kEmailTokenKey = "EmailTokenKey"
    static let kApnTokenKey = "ApnTokenKey"
    static let kDateFormate = "DateFormate"
    
    //*****************************************************************
    // MARK: -
    //*****************************************************************
    
    static func recordToken(token:String, key: String) {
        let userDefault = UserDefaults.standard
        userDefault.set(token , forKey: key)
        userDefault.synchronize()
    }
    
    static func updateToken(key: String) -> Bool {
        let userDefault = UserDefaults.standard
        guard let data = userDefault.object(forKey: key) as? String  else {
            return false
        }
        if !data.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    static func updateInfoFromKeychain(_ key: String) -> String {
        let userDefault = UserDefaults.standard
        guard let data = userDefault.string(forKey: key)  else {
            return ""
        }
        
        return data
    }
    
    static func cleanTokenInKeychain(_ key: String) {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: key)
        userDefault.synchronize()
    }
    
    //*****************************************************************
    // MARK: - Date Format
    //*****************************************************************
    
    static func createDateFormate() {
        // true - American false - Europe
        let userDefault = UserDefaults.standard
        if (userDefault.object(forKey: UserDefaultsManager.kDateFormate)) == nil {
            userDefault.set(true, forKey: UserDefaultsManager.kDateFormate)
        }
    }
    
    static func saveInfoDateFormat(_ state: Bool) {
        let userDefault = UserDefaults.standard
        userDefault.set(state, forKey: UserDefaultsManager.kDateFormate)
    }
    
    static func updateInfoDateFormat() -> Bool {
        let userDefault = UserDefaults.standard
        return (userDefault.object(forKey: UserDefaultsManager.kDateFormate) as? Bool)!
    }
}
