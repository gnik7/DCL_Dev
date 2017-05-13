//
//  EditGoalArchiveGoalModel.swift
//  DCL
//
//  Created by Nikita on 3/15/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class EditGoalArchiveGoalModel: ResponseSimpleModel, Meta{
    
    var archivedItem : HomeIdeasModelItem?
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        self.archivedItem <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        case "PATCH" : return API_Call.getURLClear(method: API_Call.goal_celebrate)
        default:// GET
            return API_Call.getURLClear(method: API_Call.goal_celebrate)
        }
    }
}
