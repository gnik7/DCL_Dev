//
//  AcceptInviteToGoalModel.swift
//  DCL
//
//  Created by Nikita on 4/3/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class AcceptInviteToGoalModel: ResponseSimpleArrayModel, Meta {
    
    var items = [NotificationItemModel]()
    
    required convenience init?(map: Map) {
        self.init()
        
        items   <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:
            return API_Call.getURLClear(method: API_Call.accept_invite_to_goal)
        }
    }
}
