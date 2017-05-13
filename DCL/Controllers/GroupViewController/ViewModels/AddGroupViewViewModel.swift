//
//  AddGroupViewViewModel.swift
//  DCL
//
//  Created by Nikita on 3/16/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AddGroupViewViewModel : ViewModel {
    
    func createNewGroupAction(item: AddFriendModel)  {
        
        guard let title = item.titleGroup, let friends = item.friends else { return }
       
        var params: [String : Any]!
        
        if let id = item.id {
            params = ["id"      : id,
                      "title"   : title,
                      "friends" : friends]
        } else {
            params = ["title"   : title,
                      "friends" : friends]
        }
        
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: AddFriendModel.self, params: params , headers: nil)
    }
}

extension AddGroupViewViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        ParseResponseClass.parseObjectArray(modelType: AddFriendModel.self, object: object, success: {[weak self] (result) in
            guard let this = self else {return}
            (this.delegate as? AddGroupViewController)?.saved()
        })
    }
}

