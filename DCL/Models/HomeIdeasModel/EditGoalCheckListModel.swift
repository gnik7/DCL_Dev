//
//  EditGoalCheckListModel.swift
//  DCL
//
//  Created by Nikita on 2/23/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper


class EditGoalCheckListModel: ResponseSimpleArrayModel, Meta{
    
    var id                  : Int?
    //var goalId              : Int?
    var checkListItemsArray = [CheckListIdeasModelItem]()
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        self.id                  <- map["result.id"]
        //self.goalId              <- map["result.goal_id"]
        self.checkListItemsArray <- map["result.checklist_items"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURLClear(method: API_Call.update_goal_checklists)
        }
    }
}

class CheckListIdeasModelItem: ResponseSimpleArrayModel {
    
    var id              : Int?
    var goalChecklistId : Int?
    var title           : String?
    var isChecked       : Bool?
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        self.id                 <- map["id"]
        self.goalChecklistId    <- map["goal_checklist_id"]
        self.title              <- map["title"]
        self.isChecked          <- map["is_checked"]
    }
}

class EditGoalRemindersListModel: ResponseSimpleArrayModel, Meta{
    
    var id                  : Int?
    //var goalId              : Int?
    var checkListItemsArray = [CheckListIdeasModelItem]()
    
    //*****************************************************************
    // MARK: - Mapping
    //*****************************************************************
    
    required convenience init?(map: Map) {
        self.init()
        
        self.id                  <- map["result.id"]
        //self.goalId              <- map["result.goal_id"]
        self.checkListItemsArray <- map["result.reminder_items"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURLClear(method: API_Call.update_goal_reminders)
        }
    }
}


