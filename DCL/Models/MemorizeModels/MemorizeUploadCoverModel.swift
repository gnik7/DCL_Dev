//
//  MemorizeUploadCoverModel.swift
//  DCL
//
//  Created by Nikita on 3/24/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class MemorizeUploadCoverModel: ResponseSimpleModel, Meta{
    
    var goalItem = HomeIdeasModelItem()
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        goalItem <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURLClear(method: API_Call.save_goal_cover)
        }
    }
}

class MemorizeUploadMediaModel: ResponseSimpleModel, Meta{
    
    var goalItem = HomeIdeasModelItem()
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        goalItem <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:
            return API_Call.getURLClear(method: API_Call.save_goal_media)
        }
    }
}

class MemorizeDeleteMediaModel: ResponseSimpleModel, Meta{
    
    var goalItem = HomeIdeasModelItem()
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        goalItem <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:
            return API_Call.getURLClear(method: API_Call.save_goal_media)
        }
    }
}




