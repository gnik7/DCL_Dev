//
//  RecoverGaolsModel.swift
//  DCL
//
//  Created by Nikita on 3/1/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class RecoverGaolsModel: ResponseSimpleArrayModel, Meta{
    
    var items = [HomeIdeasModelItem]()
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        items <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.profile_recover_goals)
        }
    }
}

class RestoreGaolsModel: ResponseSimpleArrayModel, Meta{
    
    var items = [HomeIdeasModelItem]()
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        items <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:
            return API_Call.getURL(method: API_Call.profile_restore_goals)
        }
    }
}


