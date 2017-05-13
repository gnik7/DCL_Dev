//
//  NotesViewViewModel.swift
//  DCL
//
//  Created by Nikita on 2/23/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class NotesViewViewModel : ViewModel {
    
    var checkListItem = (title: "", indexPath: IndexPath())
    var reminderItem  = (title: "", indexPath: IndexPath())
    
    var action: (()-> ())?
    
    /// API call
    ///
    /// -
    
    //*****************************************************************
    // MARK: - Get List of Items
    //*****************************************************************
    
    func updateCheckListAction(id: Int, complition: @escaping (()-> ())) {
        action = complition
        let params: [String : Any] = [DefaultText.apiInnerConstParam : id]
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.get, modelType: EditGoalCheckListModel.self, params: params, headers: nil)
    }
    
    func updateRemindersAction(id: Int) {
        
        let params: [String : Any] = [DefaultText.apiInnerConstParam : id]
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.get, modelType: EditGoalRemindersListModel.self, params: params, headers: nil)
    }
    
    //*****************************************************************
    // MARK: - Save Item
    //*****************************************************************
    
    func saveCheckListItem(title: String, id: Int) {
        let params: [String : Any] = ["title"                        : title,
                                      DefaultText.apiInnerConstParam : id]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: EditGoalUpdateCheckListItemModel.self, params: params, headers: nil)
    }
    
    func saveReminderItem(title: String, id: Int) {
        let params: [String : Any] = ["title"                        : title,
                                      DefaultText.apiInnerConstParam : id]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: EditGoalUpdateReminderItemModel.self, params: params, headers: nil)
    }
    
    //*****************************************************************
    // MARK: - Change State
    //*****************************************************************
    
    func updateCheckListSelectedAction(id: Int) {
        
        let params: [String : Any] = [DefaultText.apiInnerConstParam : id]
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.patch, modelType: EditGoalUpdateCheckListItemSelectedModel.self, params: params, headers: nil)
    }
    
    func updateReminderSelectedAction(id: Int) {
        
        let params: [String : Any] = [DefaultText.apiInnerConstParam : id]
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.patch, modelType: EditGoalUpdateReminderSelectedModel.self, params: params, headers: nil)
    }
    
    //*****************************************************************
    // MARK: - Change Text
    //*****************************************************************
    
    func changeTextCheckListItem(title: String, id: Int) {
        let params: [String : Any] = ["title"                        : title,
                                      DefaultText.apiInnerConstParam : id]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.patch, modelType: EditGoalUpdateCheckListItemTextModel.self, params: params, headers: nil)
    }
    
    func changeTextReminderItem(title: String, id: Int) {
        let params: [String : Any] = ["title"                        : title,
                                      DefaultText.apiInnerConstParam : id]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.patch, modelType: EditGoalUpdateReminderTextModel.self, params: params, headers: nil)
    }
}

extension NotesViewViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        if object is EditGoalCheckListModel {
            ParseResponseClass.parseObjectArray(modelType: EditGoalCheckListModel.self, object: object, success: { [weak self](result) in
                
                guard let this = self else {return}
                
                (this.delegate as? NotesView)?.updateCheckList(result: result.checkListItemsArray)
            })
        }
        
        if object is EditGoalRemindersListModel {
            ParseResponseClass.parseObjectArray(modelType: EditGoalRemindersListModel.self, object: object, success: { [weak self](result) in
                guard let this = self else {return}
                (this.delegate as? NotesView)?.updateReminderList(result: result.checkListItemsArray)
            })
        }
        
        if object is EditGoalUpdateCheckListItemModel {
            ParseResponseClass.parseObjectArray(modelType: EditGoalUpdateCheckListItemModel.self, object: object, success: { [weak self] (result) in
                
                guard let this = self else {return}
                (this.delegate as? NotesView)?.updateCheckList(result: result.checkListItemsArray)
            })
        }
        
        if object is EditGoalUpdateReminderItemModel {
            ParseResponseClass.parseObjectArray(modelType: EditGoalUpdateReminderItemModel.self, object: object, success: { [weak self] (result) in
                
                guard let this = self else {return}
                (this.delegate as? NotesView)?.updateReminderList(result: result.checkListItemsArray)
            })
        }
        
        if object is EditGoalUpdateCheckListItemSelectedModel {
            ParseResponseClass.parseObject(modelType: EditGoalUpdateCheckListItemSelectedModel.self, object: object, success: { [weak self] (result) in
                
                guard let this = self else {return}
                (this.delegate as? NotesView)?.checkListSelectedReloadRow(indexPath: this.checkListItem.indexPath, selectedItem: result.checkListItemsSelected)
            })
        }
        
        if object is EditGoalUpdateReminderSelectedModel {
            ParseResponseClass.parseObject(modelType: EditGoalUpdateReminderSelectedModel.self, object: object, success: { [weak self] (result) in
                
                guard let this = self else {return}
                (this.delegate as? NotesView)?.reminderSelectedReloadRow(indexPath: this.reminderItem.indexPath, selectedItem: result.checkListItemsSelected)
            })
        }
        
               
        
        
        if object is EditGoalUpdateCheckListItemTextModel {
            ParseResponseClass.parseObject(modelType: EditGoalUpdateCheckListItemTextModel.self, object: object, success: { [weak self] (result) in
                
                guard let this = self else {return}
                (this.delegate as? NotesView)?.checkListSelectedReloadRow(indexPath: this.checkListItem.indexPath, selectedItem: result.checkListItemsSelected)
            })
        }
        
        if object is EditGoalUpdateReminderTextModel {
            ParseResponseClass.parseObject(modelType: EditGoalUpdateReminderTextModel.self, object: object, success: { [weak self] (result) in
                
                guard let this = self else {return}
                (this.delegate as? NotesView)?.reminderSelectedReloadRow(indexPath: this.reminderItem.indexPath, selectedItem: result.checkListItemsSelected)
            })
        }
        
        
    }
}

