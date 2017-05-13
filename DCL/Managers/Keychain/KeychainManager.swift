//
//  KeychainManager.swift
//  DCL
//
//  Created by Nikita on 2/8/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

struct KeychainManager {
    
    static let kFBTokenKey = "FBTokenKey"
    static let kEmailTokenKey = "EmailTokenKey"
    
    //*****************************************************************
    // MARK: - FB Token
    //*****************************************************************
    
    static func recordInKeychain(token:String, key: String) -> Bool {
        let saveSuccessful: Bool = KeychainWrapper.standard.set(token, forKey: key)
        return saveSuccessful
    }
    
    static func updateInfoFromKeychain(_ key: String) -> String {
        guard let retrievedString = KeychainWrapper.standard.string(forKey: key) else {
            return ""
        }
        return retrievedString
    }
    
    static func cleanTokenInKeychain(_ key: String) {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: key)
        print(removeSuccessful)
    }
}
