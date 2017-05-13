//
//  StoresListModel.swift
//  DCL
//
//  Created by Nikita on 2/17/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class StoresListModel: ResponseSimpleArrayModel, Meta {
    
    var items = [StoresListItemModel]()
    
    
    required convenience init?(map: Map) {
        self.init()
        
        items   <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.stores)
        }
    }
}

class StoresListItemModel: ResponseSimpleArrayModel {
   
    var id          : Int?
    var title       : String?
    var url         : String?
    var logoUrl    : String?
    
    required convenience init?(map: Map) {
        self.init()
        
        id          <- map["id"]
        title       <- map["name"]
        url         <- map["url"]
        logoUrl     <- map["logo_url"]
    }
}
