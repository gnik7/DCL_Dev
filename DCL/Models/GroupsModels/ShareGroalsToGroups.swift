//
//  ShareGroalsToGroups.swift
//  DCL
//
//  Created by Nikita Gil on 05.04.17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class ShareGroalsToGroups: ResponseSimpleModel, Meta{
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    // Implementation of Meta protocol
    static func url_get(method: String) -> String {
        
        switch method {
        default:
            return API_Call.getURL(method: API_Call.share_goal_to_group)
        }
    }
}
