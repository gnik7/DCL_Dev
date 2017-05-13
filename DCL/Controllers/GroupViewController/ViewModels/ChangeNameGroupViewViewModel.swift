//
//  ChangeNameGroupViewViewModel.swift
//  DCL
//
//  Created by Nikita Gil on 05.04.17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ChangeNameGroupViewViewModel : ViewModel {
    
    func createNewGroupAction(item: GroupModelItem)  {
        
        guard let title = item.name else { return }
        
        var friendsIds = [Int]()
        for i in item.friends {
            friendsIds.append(i.id!)
        }
        
        var params: [String : Any]!
        
        if let id = item.id {
            params = ["id"      : id,
                      "title"   : title,
                      "friends" : friendsIds]
        }
        
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: AddFriendModel.self, params: params , headers: nil)
    }
}

extension ChangeNameGroupViewViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        ParseResponseClass.parseObjectArray(modelType: AddFriendModel.self, object: object, success: {[weak self] (result) in
            guard let this = self else {return}
            (this.delegate as? ChangeNameGroupViewController)?.saved()
        })
    }
}

