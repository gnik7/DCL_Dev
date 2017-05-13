//
//  GroupsModel.swift
//  DCL
//
//  Created by Nikita on 3/15/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class GroupsModel: ResponseSimpleArrayModel, Meta{
    
    var groupsArray = [GroupModelItem]()
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        groupsArray <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.list_groups)
        }
    }
}

class GroupModelItem: ResponseSimpleArrayModel {
    
    var id              : Int?
    var name            : String?
    var friends         = [FriendItemModel]()
    var isSelected      = false
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        self.id             <- map["id"]
        self.name           <- map["name"]
        self.friends        <- map["friends"]
    }
}

