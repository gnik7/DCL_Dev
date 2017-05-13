//
//  EditGoalMOtivateMeModel.swift
//  DCL
//
//  Created by Nikita on 4/12/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class EditGoalMotivateMeModel: ResponseSimpleArrayModel, Meta{
    
    var motivationMessageArray = [EditGoalMotivateMeItemModel]()
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        self.motivationMessageArray <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:
            return API_Call.getURL(method: API_Call.motivate_me)
        }
    }
}

class EditGoalMotivateMeItemModel: ResponseSimpleArrayModel{
    
    var motivationMessage: String?
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        self.motivationMessage <- map["message"]
    }
}


