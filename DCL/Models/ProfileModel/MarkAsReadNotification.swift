//
//  MarkAsReadNotification.swift
//  DCL
//
//  Created by Nikita on 3/29/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class MarkAsReadNotification: ResponseSimpleModel, Meta{
    
 
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    // Implementation of Meta protocol
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.mark_as_read_notifications)
        }
    }
}
