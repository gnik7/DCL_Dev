//
//  EditGoalUpdateReminderItemModel.swift
//  DCL
//
//  Created by Nikita on 2/24/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class EditGoalUpdateReminderItemModel: ResponseSimpleArrayModel, Meta{
    
    var title: String?
    var checkListItemsArray = [CheckListIdeasModelItem]()
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        self.checkListItemsArray <- map["result.reminder_items"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// POST
            return API_Call.getURLClear(method: API_Call.update_goal_reminder_item)
        }
    }
}


class EditGoalUpdateReminderSelectedModel: ResponseSimpleModel, Meta{
    
    var checkListItemsSelected = CheckListIdeasModelItem()
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        self.checkListItemsSelected <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// PATCH
            return API_Call.getURLClear(method: API_Call.update_goal_reminder_item_selected)
        }
    }
}


class EditGoalUpdateReminderTextModel: ResponseSimpleModel, Meta{
    
    var checkListItemsSelected = CheckListIdeasModelItem()
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        self.checkListItemsSelected <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// PATCH
            return API_Call.getURLClear(method: API_Call.update_goal_reminder_item_text)
        }
    }
}
