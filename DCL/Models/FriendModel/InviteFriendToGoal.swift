//
//  InviteFriendToGoal.swift
//  DCL
//
//  Created by Nikita on 3/14/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class InviteFriendToGoal: ResponseSimpleModel, Meta{
    
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
        default:// POST
            return API_Call.getURLClear(method: API_Call.invite_friend_to_goal)
        }
    }
}

