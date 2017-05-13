//
//  DeleteUserFromGroup.swift
//  DCL
//
//  Created by Nikita on 3/28/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class DeleteUserFromGroup: ResponseSimpleArrayModel, Meta{


    required convenience init?(map: Map) {
        self.init()
    }
    
    // Implementation of Meta protocol
    static func url_get(method: String) -> String {
        
        switch method {
        default:
            return API_Call.getURLClear(method: API_Call.remove_user_from_group)
        }
    }
}
