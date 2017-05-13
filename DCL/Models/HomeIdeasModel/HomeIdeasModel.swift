//
//  HomeIdeasModel.swift
//  DCL
//
//  Created by Nikita on 2/13/17.
//  Copyright © 2017 Nikita. All rights reserved.
//


import Foundation
import ObjectMapper

class HomeIdeasModel: ResponseSimpleArrayModel, Meta{

    var homeIdeasArray = [HomeIdeasModelItem]()

    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        homeIdeasArray <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.add_goal)
        }
    }
}

class HomeIdeasModelItemDetail: HomeIdeasModelItem, Meta {
    
    required convenience init?(map: Map) {
        self.init()
        let JSON = map.JSON;
        let newMap = Map(mappingType: .fromJSON, JSON: JSON["result"] as! [String : Any])
        
        self.mappingFrom(map: newMap)
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURLClear(method: API_Call.goals_item)
        }
    }
    
}

class HomeIdeasModelItem: ResponseSimpleArrayModel {
    
    var id              : Int?
    var userId          : Int?
    var ideas           : String?
    var friendsNumber   : Int?
    var ideasLevel      : IdeaLevel?
    var location        : String?
    var endsAt          = DateItem()
    var achievedAt      : String?
    var goalCover       = MediaGoalItem()
    var goalImages      = [MediaGoalItem]()
    var friends         = [FriendItemModel]()
    var stateCell       = false
    
    var type            : String?{
        didSet {
            guard let ideaType = self.type else {
                self.ideasLevel =  IdeaLevel.None
                return
            }
            switch ideaType {
            case "easy": self.ideasLevel =  IdeaLevel.Easy
            case "medium": self.ideasLevel =  IdeaLevel.Medium
            case "hard": self.ideasLevel =  IdeaLevel.Hard
            default: return self.ideasLevel =  IdeaLevel.None
            }
        }
    }
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************

    
    required convenience init?(map: Map) {
        self.init()
        
        self.mappingFrom(map: map)
    }
    
    class func converStringToIdeaLevel(item : String?)-> IdeaLevel {
        guard let ideaType = item else {
            return .None
        }
        switch ideaType {
            case "easy": return IdeaLevel.Easy
            case "medium": return IdeaLevel.Medium
            case "hard": return IdeaLevel.Hard
        default: return .None
        }
    }
    
    public func mappingFrom(map: Map) {
        self.id             <- map["id"]
        self.userId         <- map["user_id"]
        self.ideas          <- map["title"]
        //        self.friendsNumber  <- map["user_id"]
        self.type           <- map["goal_type"]
        self.location       <- map["location"]
        self.endsAt         <- map["ends_at"]
        self.achievedAt     <- map["achieved_at"]
        self.goalCover      <- map["goal_cover"]
        self.goalImages     <- map["goal_media"]
        self.friends        <- map["friends"]
        
        self.ideasLevel = HomeIdeasModelItem.converStringToIdeaLevel(item: self.type)
    }
    
}

class DateItem: ResponseSimpleArrayModel {
    
    var date            : String?
    var timeZoneType    : String?
    var timeZone        : String?

    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        self.date          <- map["date"]
        self.timeZoneType  <- map["timezone_type"]
        self.timeZone      <- map["timezone"]
    }
}

class DeleteGoalItem: ResponseSimpleModel, Meta{ 
  
    
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
        default:// GET
            return API_Call.getURLClear(method: API_Call.goals_item)
        }
    }
}

class MediaGoalItem: ResponseSimpleModel {
    
    var id              : Int?
    var mediaUrl        : String?
    
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        self.id          <- map["id"]
        self.mediaUrl    <- map["url"]
    }
}


