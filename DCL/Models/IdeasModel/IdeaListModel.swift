//
//  IdeaListModel.swift
//  DCL
//
//  Created by Nikita Gil on 29.03.17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class IdeaListModel: ResponseSimpleArrayModel, Meta {
    
    var items = [IdeaListItemModel]()
    
    
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
            return API_Call.getURL(method: API_Call.list_ideas)
        }
    }
}


class IdeaListItemModel: ResponseSimpleArrayModel {
    
    var id              : Int?
    var title           : String?
    var coverUrl        : String?
    var items           : Int?
    
    required convenience init?(map: Map) {
        self.init()
        
        self.id         <- map["id"]
        self.title      <- map["title"]
        self.coverUrl   <- map["cover_url"]
        self.items      <- map["items"]
    }
}

