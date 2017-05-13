//
//  UserProfileModel.swift
//  DCL
//
//  Created by Nikita on 2/17/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class UserProfileModel: ResponseSimpleArrayModel, Meta {
  
    var photoUrl                : String?
    var id                      : Int?
    var isFacebook              : Bool?
    var name                    : String?
    var email                   : String?
    var isNotifiable            : Bool?
    
    required convenience init?(map: Map) {
        self.init()
        
        id          <- map["result.id"]
        name        <- map["result.name"]
        photoUrl    <- map["result.photo_url"]
        isFacebook  <- map["result.facebook"]
        email       <- map["result.email"]
        isNotifiable <- map["result.is_notifiable"]
        
        UserModel.sharedInstance.id = self.id
        UserModel.sharedInstance.name = self.name
        UserModel.sharedInstance.photoUrl = self.photoUrl
        UserModel.sharedInstance.isNotifiable = self.isNotifiable
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.profile)
        }
    }
}

class UserModel {
    
    static let sharedInstance = UserModel()
    
    // MARK: - Singleton
//    static let sharedInstance : UserModel = {
//        let instance = UserModel()
//        return instance
//    }()
    
    var photoUrl                : String?
    var id                      : Int?
    var name                    : String?
    var isNotifiable            : Bool?
}
