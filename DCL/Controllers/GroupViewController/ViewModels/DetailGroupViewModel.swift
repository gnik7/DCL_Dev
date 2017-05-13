//
//  DetailGroupViewModel.swift
//  DCL
//
//  Created by Nikita on 3/27/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class DetailGroupViewModel : ViewModel {
    
    var userID: Int?
    
    func homeIdeaBy(id: Int) {
        let params: [String: Any] = [DefaultText.apiInnerConstParam : id]
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.get, modelType: HomeIdeasModelItemDetail.self, params: params, headers: nil)
    }
    
    func updateGroupInfoAction(_ groupId: Int) {
        let params: [String : Any] = [DefaultText.apiInnerConstParam : groupId]
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.get, modelType: DetailGroupModel.self, params: params, headers: nil)
    }
    
    
    func deleteUserFromGroupAction(_ groupId: Int, _ userId: Int) {
        self.userID = userId
        let params: [String : Any] = ["friend_id"                       : userId,
                                      DefaultText.apiInnerConstParam    : groupId]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.delete, modelType: DeleteUserFromGroup.self, params: params, headers: nil)
    }
    
    func createNewGroupAction(item: AddFriendModel)  {
        
        guard let title = item.titleGroup, let friends = item.friends else { return }
        
        var params: [String : Any]!
        
        if let id = item.id {
            params = ["id"      : id,
                      "title"   : title,
                      "friends" : friends]
        }
        
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: AddFriendModel.self, params: params , headers: nil)
    }
}

extension DetailGroupViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    func responseOperationObject(_ object: Any) {        
        
        if object is DetailGroupModel {
            ParseResponseClass.parseObject(modelType: DetailGroupModel.self, object: object, success: {[weak self] (result) in
                
                guard let this = self else {return}
                (this.delegate as? DetailGroupViewController)?.updateDetailData(result)
            })
        }
        
        if object is DeleteUserFromGroup{
            ParseResponseClass.parseObjectArray(modelType: DeleteUserFromGroup.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? DetailGroupViewController)?.deletedUser(this.userID!)
            })
        }
        
        if object is AddFriendModel {
            ParseResponseClass.parseObjectArray(modelType: AddFriendModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                
                (this.delegate as? DetailGroupViewController)?.addFriendSent(result.message)
            })
        }
        
        if object is HomeIdeasModelItem {
            ParseResponseClass.parseObjectArray(modelType: HomeIdeasModelItemDetail.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? DetailGroupViewController)?.openHomeIdea(result)
            })
        }
    }
}

