//
//  RefreshTokenViewModel.swift
//  DCL
//
//  Created by Nikita on 2/17/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class RefreshTokenViewModel : ViewModel {
    
    /// API call for reset functionality
    ///
    /// - Parameter model: contain email for reset already checked
    func refreshTokenAction() {
        
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.get, modelType: RefreshTokenModel.self, params: nil, headers: nil)
    }
}

extension RefreshTokenViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        ParseResponseClass.parseObject(modelType: RefreshTokenModel.self, object: object, success: { (result) in
            
        })
    }
}


