//
//  TimeManagerViewModel.swift
//  DCL
//
//  Created by Nikita Gil on 05.04.17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class TimeManagerViewModel: ViewModel {
    
    func updateTimeAction(_ timezoneType: String, _ timezone: String) {
        let params: [String : Any] = ["timezone_type"   : 3,
                                      "timezone"        : timezone]
        operationAPI.operationAPICallWithBody(method: HTTPMethod.patch, modelType: TimeModel.self, params: params, headers: nil)
    }
}

extension TimeManagerViewModel: APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        if object is TimeModel{
            ParseResponseClass.parseObject(modelType: TimeModel.self, object: object, success: {(result) in
            })
        }
    }
}


