//
//  DeleteGroupsModel.swift
//  DCL
//
//  Created by Nikita on 4/21/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class DeleteGroupModel: ResponseSimpleArrayModel, Meta{
    
    var groupsArray = [GroupModelItem]()
    
    required convenience init?(map: Map) {
        self.init()
        groupsArray <- map["result"]
    }
    
    // Implementation of Meta protocol
    static func url_get(method: String) -> String {
        
        switch method {
        default:
            return API_Call.getURLClear(method: API_Call.remove_group)
        }
    }
}
