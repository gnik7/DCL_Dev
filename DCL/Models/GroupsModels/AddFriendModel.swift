//
//  AddFriendModel.swift
//  DCL
//
//  Created by Nikita on 3/15/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class AddFriendModel: ResponseSimpleArrayModel, Meta{
    
    var id          : Int?
    var titleGroup  : String?
    var friends     : [Int]?
    
    
    func checkFields() -> Bool {
        
        let fieldResult = String.unwrapCheck(self.titleGroup, FieldType.GroupName)
        
        if fieldResult {
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
        default:
            return API_Call.getURL(method: API_Call.list_groups)
        }
    }
}
