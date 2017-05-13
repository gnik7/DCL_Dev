//
//  ChangePasswordModel.swift
//  DCL
//
//  Created by Nikita on 3/1/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class ChangePasswordModel: ResponseSimpleModel, Meta{
    
    var password        : String?
    var passwordRetype  : String?
    var token           : String?
    
    func checkFields() -> Bool {
        
        let passwordResult = String.unwrapCheck(self.password, FieldType.Password)
        let passwordRetypeResult = String.unwrapCheck(self.passwordRetype, FieldType.RetypePassword)
        if passwordResult && passwordRetypeResult &&  password == passwordRetype {
            return true
        } else {
            return false
        }
    }
    
    required convenience init?(map: Map) {
        self.init()
        self.token  <- map["result.token"]
        recordToken(self.token)
    }
    
    private func recordToken(_ token: String?) {
        guard let token = token else {
            return
        }
        UserDefaultsManager.recordToken(token: token, key: UserDefaultsManager.kEmailTokenKey)
//        _ = KeychainManager.recordInKeychain(token: token, key: KeychainManager.kEmailTokenKey)
//        RestApiClass.sharedInstance.defaultManager = RestApiClass.setupAlamofire()
    }
    
    // Implementation of Meta protocol
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.update_password)
        }
    }
}
