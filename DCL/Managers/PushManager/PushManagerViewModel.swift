//
//  PushManagerViewModel.swift
//  DCL
//
//  Created by Nikita on 4/3/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class PushManagerViewModel: ViewModel {

    
    //to friend
    func acceptInviteAction(_ userId: Int, _ notificationId: String) {
        
        let params: [String : Any] = ["friend_id" : userId,  "notification_id": notificationId]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.patch, modelType: AcceptInviteModel.self, params: params, headers: nil)
    }
    //to friend
    func declineInviteAction(_ userId: Int, _ notificationId: String) {
        
        let params: [String : Any] = ["friend_id" : userId,  "notification_id": notificationId]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.patch, modelType: DeclineInviteModel.self, params: params, headers: nil)
    }
    
    //to goal
    func acceptInviteToGoalAction(_ goalId: Int, _ notificationId: String) {
        
        let params: [String : Any] = ["notification_id"                 : notificationId,
                                      DefaultText.apiInnerConstParam    : goalId]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.patch, modelType: AcceptInviteToGoalModel.self, params: params, headers: nil)
    }
    //to goal
    func declineInviteToGoalAction(_ goalId: Int, _ notificationId: String) {
        
        let params: [String : Any] = ["notification_id"                 : notificationId,
                                      DefaultText.apiInnerConstParam    : goalId]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.patch, modelType: DeclineInviteToGoalModel.self, params: params, headers: nil)
    }
    
    func markAsReadNotificationsAction(_ idNotification: String) {
        let params: [String : Any] = ["id" : idNotification]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: MarkAsReadNotification.self, params: params, headers: nil)
    }
    
    func updateNotificationCountAction() {
        operationAPI.operationAPICall(method: HTTPMethod.get, modelType: CountNotificationsModel.self, params: nil, headers: nil)
    }
}

extension PushManagerViewModel: APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        if object is MarkAsReadNotification{
            ParseResponseClass.parseObject(modelType: MarkAsReadNotification.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? PushManager)?.markRead()
            })
        }
        
        if (object is AcceptInviteModel)  {
            ParseResponseClass.parseObjectArray(modelType: AcceptInviteModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? PushManager)?.acceptMade(result.message)
            })
        }
        
        if (object is AcceptInviteToGoalModel) {
            ParseResponseClass.parseObjectArray(modelType: AcceptInviteModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? PushManager)?.acceptMade(result.message)
            })
        }
        
        if (object is DeclineInviteModel) {
            ParseResponseClass.parseObjectArray(modelType: DeclineInviteModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? PushManager)?.declineMade(result.message)
            })
        }
        
        if (object is DeclineInviteToGoalModel) {
            ParseResponseClass.parseObjectArray(modelType: DeclineInviteModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? PushManager)?.declineMade(result.message)
            })
        }        
        
        if object is CountNotificationsModel {
            ParseResponseClass.parseObject(modelType: CountNotificationsModel.self, object: object, success: { (result) in                
            })
        }
    }
}

