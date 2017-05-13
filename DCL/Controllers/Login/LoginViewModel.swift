//
//  LoginViewModel.swift
//  DCL
//
//  Created by Nikita on 2/10/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class LoginViewModel : ViewModel {
    
    /// API call for reset functionality
    ///
    /// - Parameter model: contain email for reset already checked
    func registerAction(_ token: String) {
        
        let params = ["fb_access_token": token]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: UserFromFacebookModel.self, params: params, headers: nil)
    }
}

extension LoginViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        /// Email validation result operation
        if object is UserFromFacebookModel {
            
            ParseResponseClass.parseObjectArray(modelType: UserFromFacebookModel.self, object: object, success: { (result) in
                 TimeManager.sharedInstance.updateTime()
                (self.delegate as? LoginViewController)?.router.showFirstTimeHomeViewController()
            })            
        }
    }
}

