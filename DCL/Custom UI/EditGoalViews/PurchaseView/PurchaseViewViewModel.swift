//
//  PurchaseViewViewModel.swift
//  DCL
//
//  Created by Nikita on 2/24/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class PurchaseViewViewModel : ViewModel {
    
    /// API call
    ///
    /// -
    func updateStoreListAction() {
        
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.get, modelType: StoresListModel.self, params: nil, headers: nil)
    }
}

extension PurchaseViewViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        ParseResponseClass.parseObjectArray(modelType: StoresListModel.self, object: object, success: { [weak self] (result) in
            
            guard let this = self else {return}
            (this.delegate as? PurchaseView)?.updateData(result: result)
        })
    }
}


