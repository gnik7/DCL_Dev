//
//  SignInViewModel.swift
//  DCL
//
//  Created by Nikita on 2/10/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SignInViewModel : ViewModel {
    
    /// API call for reset functionality
    ///
    /// - Parameter model: contain email and password for login already checked
    func loginAction(_ model: SignInModel) {
        
        let params = ["email"       : model.user.email!,
                      "password"    : model.user.password!]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: SignInModel.self, params: params, headers: nil)
    }
}

extension SignInViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        ///  result operation
        if object is SignInModel {
            
            ParseResponseClass.parseObjectArray(modelType: SignInModel.self, object: object, success: { (result) in
                 TimeManager.sharedInstance.updateTime()
                (self.delegate as? SignInViewController)?.router.showFirstTimeHomeViewController()
            })
            
        }
    }
}
