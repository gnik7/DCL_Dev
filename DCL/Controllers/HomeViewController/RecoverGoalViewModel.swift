//
//  RecoverGoalViewModel.swift
//  DCL
//
//  Created by Nikita on 3/23/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class RecoverGoalViewModel: ViewModel {
    
    func updateListDeletedGoals(page : Int){
        
        let params: [String : Any] = ["page="    : page]
        
        operationAPI.operationAPICallWithHUD(method: HTTPMethod.get, modelType: RecoverGaolsModel.self, params: params, headers: nil)
    }
    
    func restoreGoals(_ selectedItems: [Int]) {
        
        let params: [String : Any] = ["ids" : selectedItems]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.patch, modelType: RestoreGaolsModel.self, params: params, headers: nil)
    }
}

extension RecoverGoalViewModel: APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        if object is RecoverGaolsModel {
            ParseResponseClass.parseObjectArray(modelType: RecoverGaolsModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? RecoverGoalViewController)?.listAllDeleteGoals(result.items, result.paginate)
            })
        }
        
        if object is RestoreGaolsModel {
            ParseResponseClass.parseObjectArray(modelType: RestoreGaolsModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? RecoverGoalViewController)?.listRestoredDeleteGoals(result.items)
            })
        }
    }
}

