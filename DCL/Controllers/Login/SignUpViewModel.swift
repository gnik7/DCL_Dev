//
//  SignUpViewModel.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SignUpViewModel : ViewModel {

    /// API call for user login functionality
    ///
    /// - Parameters:
    ///   - email: user-entered email
    ///   - password: user-entered password
    func registrateByEmailAction(_ model: UserFromEmailModel) {
        
        let params = ["name"                    : model.user.name!,
                      "email"                   : model.user.email!,
                      "password"                : model.user.password!,
                      "password_confirmation"   : model.user.passwordConfirmation!
                      ]
        
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: UserFromEmailModel.self, params: params, headers: nil)
    }
}

// MARK: - APIOperationsClassDelegate
extension SignUpViewModel : APIOperationsClassDelegate {
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        ParseResponseClass.parseObjectArray(modelType: UserFromEmailModel.self, object: object, success: { (result) in
             TimeManager.sharedInstance.updateTime()
            (self.delegate as? SignUpViewController)?.router.showFirstTimeHomeViewController()
        })
    }
}


//TODO: not use now  it is example
//extension ViewModelDelegate where Self : SignUpViewController{
//
//    func transition() {
//        
//        self.router.showFirstTimeHomeViewController()
//    }
//}

