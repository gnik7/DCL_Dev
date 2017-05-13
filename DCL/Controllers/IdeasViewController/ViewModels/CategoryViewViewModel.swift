//
//  CategoryViewViewModel.swift
//  DCL
//
//  Created by Nikita on 3/30/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class CategoryViewViewModel : ViewModel {
    
    func updateIdeasDataAction(_ categoryId: Int) {
        let params: [String : Any] = [DefaultText.apiInnerConstParam : categoryId]
        operationAPI.operationAPICall(method: HTTPMethod.get, modelType: CategoryIdeasListModel.self, params: params, headers: nil)
    }
}

extension CategoryViewViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    func responseOperationObject(_ object: Any) {
        
        if object is CategoryIdeasListModel {
            ParseResponseClass.parseObjectArray(modelType: CategoryIdeasListModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? CategoryIdeasViewController)?.recievedData(items: result.items)
            })
        }
    }
}

