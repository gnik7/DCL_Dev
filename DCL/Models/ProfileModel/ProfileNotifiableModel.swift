//
//  ProfileNotifiableModel.swift
//  DCL
//
//  Created by Nikita on 3/23/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class ProfileNotifiableModel: ResponseSimpleModel, Meta{
    
    var user = UserProfileModel()
    var userNotif = UserProfileNotifiableModel()
    
    required convenience init?(map: Map) {
        self.init()
        
        userNotif <- map["result"]
        self.convertToUserProfileModel()
    }
    
    // Implementation of Meta protocol
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.profile_is_notifiable)
        }
    }
    
    func convertToUserProfileModel() {
        user.id = userNotif.id
        user.name = userNotif.name
        user.photoUrl = userNotif.photoUrl
        user.isNotifiable = userNotif.isNotifiable
    }
}


class UserProfileNotifiableModel: ResponseSimpleArrayModel, Meta {
    
    var photoUrl                : String?
    var id                      : Int?
    var isFacebook              : Bool?
    var name                    : String?
    var email                   : String?
    var isNotifiable            : Bool?
    
    required convenience init?(map: Map) {
        self.init()
        
        id          <- map["id"]
        name        <- map["name"]
        photoUrl    <- map["photo_url"]
        isFacebook  <- map["facebook"]
        email       <- map["email"]
        isNotifiable <- map["is_notifiable"]
        
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





