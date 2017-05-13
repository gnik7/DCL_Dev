//
//  ForgotModel.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class ForgotModel: ResponseSimpleArrayModel, Meta{
    
    var email : String?
   
   func checkFields() -> Bool {
    
        let emailResult = String.unwrapCheck(self.email, FieldType.Email)
    
        if emailResult {
            return true
        } else {
            return false
        }
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    // Implementation of Meta protocol
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.forgot_password)
        }
    }
}
