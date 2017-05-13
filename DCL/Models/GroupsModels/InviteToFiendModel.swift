//
//  InviteToFiendModel.swift
//  DCL
//
//  Created by Nikita on 3/15/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class InviteToFiendModel: ResponseSimpleModel, Meta {
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// POST
            return API_Call.getURL(method: API_Call.invite_to_friend)
        }
    }
}
