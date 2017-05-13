//
//  CountNotificationsModel.swift
//  DCL
//
//  Created by Nikita on 3/29/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper
import UIKit

class CountNotificationsModel: ResponseSimpleModel, Meta {
    
    var count: Int?
    
    
    required convenience init?(map: Map) {
        self.init()
        
        self.count <- map["result.cnt"]
        if let number = self.count {
           UIApplication.shared.applicationIconBadgeNumber = number
        }
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.count_notifications)
        }
    }
}

