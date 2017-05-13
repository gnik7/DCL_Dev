//
//  ChangeAvatarModel.swift
//  DCL
//
//  Created by Nikita on 3/1/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class ChangeAvatarModel: ResponseSimpleModel, Meta{
    
    var avatarUrl: String?
    
    required convenience init?(map: Map) {
        self.init()
        
        self.avatarUrl <- map["result.photo_url"]
    }
        
    // Implementation of Meta protocol
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.profile_change_avatar)
        }
    }
}
