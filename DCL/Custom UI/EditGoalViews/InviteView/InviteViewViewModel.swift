//
//  InviteViewViewModel.swift
//  DCL
//
//  Created by Nikita on 3/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class InviteViewViewModel : ViewModel {
    
    fileprivate var index: Int!
    
    func sendInviteToGoal(_ goalId: Int, _ idsFriends: [Int]) {
        let params: [String : Any] = ["assign_ids" : idsFriends,
                                      DefaultText.apiInnerConstParam : goalId]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: InviteFriendToGoal.self, params: params, headers: nil)
    }
    
    func deleteFriend(_ goalId: Int, _ friendId: Int, _ index: Int) {
        self.index = index
        
        let params: [String : Any] = ["assign_id" : friendId,
                   DefaultText.apiInnerConstParam : goalId]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.delete, modelType: EditGoalRemoveFriendFromGoalModel.self, params: params, headers: nil)
    }
}

extension InviteViewViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        if object is EditGoalRemoveFriendFromGoalModel {
            ParseResponseClass.parseObject(modelType: EditGoalRemoveFriendFromGoalModel.self, object: object, success: { [weak self] (result) in
                
                guard let this = self else {return}
                (this.delegate as? InviteView)?.deleteFriend(this.index)
            })
        }
        
        if object is InviteFriendToGoal {
            ParseResponseClass.parseObject(modelType: InviteFriendToGoal.self, object: object, success: { [weak self] (result) in
                
                guard let this = self else {return}
                (this.delegate as? InviteView)?.friendsAdded(result.message)
            })
        }
    }
}
