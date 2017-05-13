//
//  UserRegistrationModel.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class UserRegistrationModel: ResponseSimpleArrayModel {
    
    var token                   : String?
    var photoUrl                : String?
    var id                      : Int?
    var isFacebook              : Bool?
    
    var name                    : String?
    var email                   : String?
    var password                : String?
    var passwordConfirmation    : String?
    
//    var name                    : String? {
//        didSet {
//            guard let name = self.name?.lowercased() else {return}
//            self.username = name.replacingOccurrences(of: " ", with: ".")
//        }
//    }

    //*****************************************************************
    // MARK: - Ckeck textfields
    //*****************************************************************
    
    func checkPassword() -> Bool {
        if password == passwordConfirmation {
            return true
        } else {
            return false
        }
    }
    
    func checkFields() -> Bool {
        let nameResult = String.unwrapCheck(self.name, FieldType.Name)
        let emailResult = String.unwrapCheck(self.email, FieldType.Email)
        let passwordResult = String.unwrapCheck(self.password, FieldType.Password)
        let passwordConfirmationResult = String.unwrapCheck(self.passwordConfirmation, FieldType.RetypePassword)
        
        if nameResult && emailResult && passwordResult && passwordConfirmationResult {
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
        
        token       <- map["token"]
        id          <- map["user.id"]
        name        <- map["user.name"]
        email       <- map["user.email"]
        photoUrl    <- map["user.photo_url"]
        isFacebook  <- map["user.facebook"]
        
        recordToken(self.token)
    }
    
    //*****************************************************************
    // MARK: - write token
    //*****************************************************************
    
    private func recordToken(_ token: String?) {
        guard let token = token else {
            return
        }
        UserDefaultsManager.recordToken(token: token, key: UserDefaultsManager.kEmailTokenKey)
//        _ = KeychainManager.recordInKeychain(token: token, key: KeychainManager.kEmailTokenKey)
//        RestApiClass.sharedInstance.defaultManager = RestApiClass.setupAlamofire()
    }
}


class UserFromEmailModel: ResponseSimpleArrayModel, Meta {
    
    var user = UserRegistrationModel()
    
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
            return API_Call.getURL(method: API_Call.register)
        }
    }
}

class UserFromFacebookModel: ResponseSimpleArrayModel, Meta {
    
    var user = UserRegistrationModel()
    
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
            return API_Call.getURL(method: API_Call.facebook_login)
        }
    }
}


