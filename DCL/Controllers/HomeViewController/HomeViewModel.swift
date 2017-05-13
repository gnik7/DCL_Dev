//
//  HomeViewModel.swift
//  DCL
//
//  Created by Nikita on 2/17/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class HomeViewModel : ViewModel {
    
    var currentId: Int?
    var isSearchGetAnswer: Bool = true
    
    /// API call get profile
    ///
    /// - Parameter model: contain email for reset already checked
    func updateProfileAction() {
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.get, modelType: UserProfileModel.self, params: nil, headers: nil)
    }
    
    func updateListGoals(page : Int, sorting: String = "", keyword: String = "" ){
        let params: [String : Any] = ["sorting=" : sorting,
                                      "filter="  : keyword,
                                      "page="    : page]
        let fullPath = RestApiClass.sharedInstance.checkFullUrlPath(currentPath: HomeIdeasModel.url_get(method: HTTPMethod.get.rawValue), params: params)
        
        if isSearchGetAnswer {
            isSearchGetAnswer = false          
            
            operationAPI.operationAPICallWithHUD(method: HTTPMethod.get, modelType: HomeIdeasModel.self, params: params, headers: nil)

        } else {
            
            RestApiClass.sharedInstance.cancelRequestByID(fullPath)
            isSearchGetAnswer = true
        }
        
//        RestApiClass.sharedInstance.cancelAllRequests()
    }
    
    func deleteGoalItem(itemId: Int) {
        let params: [String : Any] = [DefaultText.apiInnerConstParam : itemId]
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.delete, modelType: DeleteGoalItem.self, params: params, headers: nil)
    }
    
    func updateNotificationCountAction() {
        operationAPI.operationAPICall(method: HTTPMethod.get, modelType: CountNotificationsModel.self, params: nil, headers: nil)
    }
}

extension HomeViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        if object is UserProfileModel {
            ParseResponseClass.parseObjectArray(modelType: UserProfileModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? HomeViewController)?.currentUser = result
                (this.delegate as? HomeViewController)?.updateUI()
            })
        }
        
        if object is HomeIdeasModel {
            ParseResponseClass.parseObjectArray(modelType: HomeIdeasModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                this.isSearchGetAnswer = true
                (this.delegate as? HomeViewController)?.setupDataToTable(result.homeIdeasArray, result.paginate)
            })
        }
        
        if object is DeleteGoalItem {
            ParseResponseClass.parseObject(modelType: DeleteGoalItem.self, object: object, success: { [weak self](result) in
                guard let this = self else {return}
                guard let id = this.currentId else {return}
                (this.delegate as? HomeViewController)?.deleteItemInTable(id: id)
            })
        }
        
        if object is CountNotificationsModel {
            ParseResponseClass.parseObject(modelType: CountNotificationsModel.self, object: object, success: { [weak self](result) in
                guard let this = self else {return}
                guard let count = result.count else {return}
                (this.delegate as? HomeViewController)?.updateCountIndicatorNotification(count)
            })
        }
    }
}
