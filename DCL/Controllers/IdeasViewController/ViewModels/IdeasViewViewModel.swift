//
//  IdeasViewViewModel.swift
//  DCL
//
//  Created by Nikita Gil on 29.03.17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class IdeasViewViewModel : ViewModel {
    
    func updateIdeasDataAction() {
        operationAPI.operationAPICall(method: HTTPMethod.get, modelType: IdeaListModel.self, params: nil, headers: nil)
    }
}

extension IdeasViewViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    func responseOperationObject(_ object: Any) {

        if object is IdeaListModel {
            ParseResponseClass.parseObjectArray(modelType: IdeaListModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? IdeasViewController)?.recievedData(items: result.items)
            })
        }
    }
}
