//
//  FindFriendsGroupViewViewModel.swift
//  DCL
//
//  Created by Nikita on 3/15/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class FindFriendsGroupViewViewModel : ViewModel {
    
    func updateAllFriends(page : Int, keyword: String = "" , goalId: Int?) {
        
        var params : [String : Any]!
        if let idGoal = goalId {
            params = ["filter="  : keyword,
                      "page="    : page,
                      "goal="    : idGoal]
        } else {
            params = ["filter="  : keyword,
                        "page="    : page]
        }
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.get, modelType: AllFriendListModel.self, params: params, headers: nil)
    }
    
    func updateAllExcistingUsersAction(page : Int, keyword: String = "" ) {
       
        let params: [String : Any] = ["filter="  : keyword,
                                      "page="    : page]
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.get, modelType: AllUsersListModel.self, params: params, headers: nil)
    }
    
    func inviteByEmailAction(_ email: String) {
        let params: [String : Any] = ["email": email]
        
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: InviteUserByEmail.self, params: params, headers: nil)
    }
    
    func addToFriend(_ userId: Int) {
        
        let params: [String : Any] = ["friend_id": userId]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: InviteToFiendModel.self, params: params, headers: nil)
    }
    
//    func addFriendToGoal(_ goalId: Int, _ userId: Int) {
//        
//        let params: [String : Any] = ["assign_id"                    : userId,
//                                      DefaultText.apiInnerConstParam : goalId]
//        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: InviteFriendToGoal.self, params: params, headers: nil)
//    }
}

extension FindFriendsGroupViewViewModel : APIOperationsClassDelegate {
    
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
                (this.delegate as? FindFriendsGroupViewController)?.updateFriendsData(result.items, result.paginate)
            })
        }
        
        if object is AllUsersListModel{
            ParseResponseClass.parseObjectArray(modelType: AllUsersListModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? FindFriendsGroupViewController)?.updateUsersData(result.items, result.paginate)
            })
        }
        
        if object is InviteUserByEmail{
            ParseResponseClass.parseObject(modelType: InviteUserByEmail.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? FindFriendsGroupViewController)?.invateByEmailSend()
            })
        }
        
        if object is InviteToFiendModel{
            ParseResponseClass.parseObject(modelType: InviteToFiendModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                let message = result.message
                (this.delegate as? FindFriendsGroupViewController)?.inviteToFriendSent(message)
            })
        }        
    }
}

