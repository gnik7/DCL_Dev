//
//  EditGoalUpdateDateModel.swift
//  DCL
//
//  Created by Nikita on 2/23/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class EditGoalUpdateDateModel: ResponseSimpleModel, Meta{
    
    var time: String?
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        case "PATCH" : return API_Call.getURLClear(method: API_Call.update_goal_ends_at)
        default:// GET
            return API_Call.getURLClear(method: API_Call.update_goal_ends_at)
        }
    }
}
