//
//  ForgotPasswordViewModel.swift
//  DCL
//
//  Created by Nikita on 2/10/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ForgotPasswordViewModel : ViewModel {
    
    /// API call for reset functionality
    ///
    /// - Parameter model: contain email for reset already checked
    func resetAction(_ model: ForgotModel) {
        
        let params = ["email": model.email!]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: ForgotModel.self, params: params, headers: nil)
    }
}

extension ForgotPasswordViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        /// Email validation result operation
        if object is ForgotModel {
            
            ParseResponseClass.parseObjectArray(modelType: UserRegistrationModel.self, object: object, success: { (result) in
                (self.delegate as? SignInViewController)?.router.popViewController()
            })
            
        }
    }
}

