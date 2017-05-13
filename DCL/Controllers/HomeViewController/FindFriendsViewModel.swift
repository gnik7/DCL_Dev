//
//  FindFriendsViewModel.swift
//  DCL
//
//  Created by Nikita on 3/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class FindFriendsViewModel : ViewModel {
    
    func updateAllExcistingUsersAction() {
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.get, modelType: AllFriendListModel.self, params: nil, headers: nil)
    }
    
    func inviteByEmailAction(_ email: String) {
        let params: [String : Any] = ["email": email]
 
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: InviteUserByEmail.self, params: params, headers: nil)
    }
    
    func addFriendToGoal(_ goalId: Int, _ userId: Int) {
       
        let params: [String : Any] = ["assign_id"                    : userId,
                                      DefaultText.apiInnerConstParam : goalId]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: InviteFriendToGoal.self, params: params, headers: nil)
    }
}

extension FindFriendsViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        if object is AllFriendListModel{
            ParseResponseClass.parseObjectArray(modelType: AllFriendListModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}                
                (this.delegate as? FindFriendsViewController)?.updateInvateFriendsData(result.items)
            })
        }
        
        if object is InviteUserByEmail{
            ParseResponseClass.parseObject(modelType: InviteUserByEmail.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? FindFriendsViewController)?.invateByEmailSend()
            })
        
        }
        
        if object is InviteFriendToGoal {
            ParseResponseClass.parseObject(modelType: InviteFriendToGoal.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? FindFriendsViewController)?.invatedToGoal()
            })
        }
    }
}

