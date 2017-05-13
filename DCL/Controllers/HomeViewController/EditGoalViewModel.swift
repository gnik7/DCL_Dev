//
//  EditGoalViewModel.swift
//  DCL
//
//  Created by Nikita on 2/23/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class EditGoalViewModel : ViewModel {
    
    /// API call
    ///
    /// - 
    func updateTitleAction(title: String, id: Int) {
        
        let params: [String : Any] = ["title"                           : title,
                                      DefaultText.apiInnerConstParam    : id]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.patch, modelType: EditGoalUpdateTitleModel.self, params: params, headers: nil)
    }
    
    func updateLocationAction(location: String, id: Int) {
        
        let params: [String : Any] = ["location"                     : location,
                                      DefaultText.apiInnerConstParam : id]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.patch, modelType: EditGoalUpdateLocationModel.self, params: params, headers: nil)
    }
    
    func updateDateAction(time: String, id: Int) {
        
        let params: [String : Any] = ["ends_at"                      : time,
                                      DefaultText.apiInnerConstParam : id]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.patch, modelType: EditGoalUpdateDateModel.self, params: params, headers: nil)
    }
    
    func archiveAction(id: Int) {
        
        let params: [String : Any] = [DefaultText.apiInnerConstParam : id]
        
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.patch, modelType: EditGoalArchiveGoalModel.self, params: params, headers: nil)
    }
}

extension EditGoalViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        if object is EditGoalUpdateTitleModel {
            ParseResponseClass.parseObject(modelType: EditGoalUpdateTitleModel.self, object: object, success: { (result) in
            })
        }
        
        if object is EditGoalUpdateLocationModel {
            ParseResponseClass.parseObject(modelType: EditGoalUpdateLocationModel.self, object: object, success: { (result) in
            })
        }
        
        if object is EditGoalUpdateDateModel {
            ParseResponseClass.parseObject(modelType: EditGoalUpdateDateModel.self, object: object, success: { (result) in
            })
        }
        
        if object is EditGoalArchiveGoalModel {
            ParseResponseClass.parseObject(modelType: EditGoalArchiveGoalModel.self, object: object, success: { [weak self] (result) in
                
                guard let this = self, let item = result.archivedItem else {return}
                (this.delegate as? EditGoalViewController)?.celebrateArchiveUpdate(item)
            })
        }
        

    }
}

