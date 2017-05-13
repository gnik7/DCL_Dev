//
//  DetailGroupModel.swift
//  DCL
//
//  Created by Nikita on 3/27/17.
//  Copyright © 2017 Nikita. All rights reserved.
//


import Foundation
import ObjectMapper

class DetailGroupModel: ResponseSimpleModel, Meta{
    
    var id      : Int?
    var name    : String?
    var friends = [DetailGroupFriendItemModel]()
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        self.id         <- map["result.id"]
        self.name       <- map["result.name"]
        self.friends    <- map["result.friends"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURLClear(method: API_Call.group_detail)
        }
    }
}

class DetailGroupGoalItemModel: ResponseSimpleModel {
    
    var id              : Int?
    var userId          : Int?
    var title           : String?
    var location        : String?
    var goalCover       = DetailGroupGoalItemCoverModel()
    var goalType        : IdeaLevel?
    var type            : String?
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        self.id             <- map["id"]
        self.userId         <- map["user_id"]
        self.title          <- map["title"]
        self.location       <- map["location"]
        self.goalCover      <- map["goal_cover"]
        self.type           <- map["goal_type"]
        self.goalType = HomeIdeasModelItem.converStringToIdeaLevel(item: self.type)
    }
}

class DetailGroupFriendItemModel: ResponseSimpleArrayModel{
    
    var id           : Int?
    var name         : String?
    var photoUrl     : String?
    var goals        = [DetailGroupGoalItemModel]()
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        self.id         <- map["id"]
        self.name       <- map["name"]
        self.photoUrl   <- map["photo_url"]
        self.goals      <- map["goals"]
    }
}

class DetailGroupGoalItemCoverModel: ResponseSimpleModel {
    
    
    var urlPhoto: String?

    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        self.urlPhoto <- map["url"]
    }
}

