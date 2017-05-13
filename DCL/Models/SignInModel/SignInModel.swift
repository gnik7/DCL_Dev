//
//  SignInModel.swift
//  DCL
//
//  Created by Nikita on 2/10/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class SignInModel: ResponseSimpleArrayModel, Meta{
    
    var user = UserRegistrationModel()
    
    //*****************************************************************
    // MARK: - Ckeck textfields
    //*****************************************************************
    
    func checkFields() -> Bool {
        
        let emailResult = String.unwrapCheck(user.email, FieldType.Email)
        let passwordResult = String.unwrapCheck(user.password, FieldType.Password)
        
        if emailResult && passwordResult {
            return true
        } else {
            return false
        }
    }
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        user <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.login)
        }
    }
}

