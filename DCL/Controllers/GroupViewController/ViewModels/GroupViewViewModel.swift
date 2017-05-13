//
//  GroupViewViewModel.swift
//  DCL
//
//  Created by Nikita on 3/15/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class GroupViewViewModel : ViewModel {   
   
    
    func updateAllGroupsAction() {
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.get, modelType: GroupsModel.self, params: nil, headers: nil)
    }
    
    
    func deleteGroupAction(_ idGroup: Int) {
        let params: [String : Any] = [DefaultText.apiInnerConstParam : idGroup]
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.delete, modelType: DeleteGroupModel.self, params: params, headers: nil)
    }
}

extension GroupViewViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    func responseOperationObject(_ object: Any) {
        
        
        if object is GroupsModel {
            ParseResponseClass.parseObjectArray(modelType: GroupsModel.self, object: object, success: {[weak self] (result) in
                
                guard let this = self else {return}
                (this.delegate as? GroupViewController)?.updateAllGroupsData(result.groupsArray)
            })
        }
        
        if object is DeleteGroupModel {
            ParseResponseClass.parseObjectArray(modelType: DeleteGroupModel.self, object: object, success: {[weak self] (result) in
                
                guard let this = self else {return}
                (this.delegate as? GroupViewController)?.removeGroup(result.groupsArray)
            })
        }
        
    }
}
