//
//  ChangePasswordViewModel.swift
//  DCL
//
//  Created by Nikita on 3/1/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ChangePasswordViewModel : ViewModel {
    
    /// API call for reset functionality
    ///
    /// - Parameter model: contain email for reset already checked
    func resetAction(_ model: ChangePasswordModel) {
        
        let params = ["password": model.password!, "password_confirmation": model.passwordRetype!]
        
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.patch, modelType: ChangePasswordModel.self, params: params, headers: nil)
    }
}

extension ChangePasswordViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        ParseResponseClass.parseObject(modelType: ChangePasswordModel.self, object: object, success: {[weak self] (result) in
            guard let this = self else {return}
            (this.delegate as? ChangePasswordViewController)?.bacAction()
        })
    }
}
