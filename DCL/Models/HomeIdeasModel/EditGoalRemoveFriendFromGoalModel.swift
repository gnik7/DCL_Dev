//
//  EditGoalRemoveFriendFromGoalModel.swift
//  DCL
//
//  Created by Nikita on 3/15/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class EditGoalRemoveFriendFromGoalModel: ResponseSimpleModel, Meta{
    
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
        default:
            return API_Call.getURLClear(method: API_Call.goal_delete_friend)
        }
    }
}
