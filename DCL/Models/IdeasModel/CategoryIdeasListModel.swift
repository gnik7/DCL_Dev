//
//  CategoryIdeasListModel.swift
//  DCL
//
//  Created by Nikita Gil on 29.03.17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class CategoryIdeasListModel: ResponseSimpleArrayModel, Meta {
    
    var items = [CategoryIdeaListItemModel]()
    
    
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
            return API_Call.getURLClear(method: API_Call.list_ideas_in_category)
        }
    }
}


class CategoryIdeaListItemModel: ResponseSimpleArrayModel {
    
    var id              : Int?
    var title           : String?
    var coverUrl        : String?
   
    
    required convenience init?(map: Map) {
        self.init()
        
        self.id         <- map["id"]
        self.title      <- map["title"]
        self.coverUrl   <- map["idea_image"]
    }
}
