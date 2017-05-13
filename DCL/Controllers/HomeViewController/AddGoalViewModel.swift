//
//  AddGoalViewModel.swift
//  DCL
//
//  Created by Nikita on 2/21/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AddGoalViewModel : ViewModel {
    
    /// API call get profile
    ///
    /// - Parameter model: contain email for reset already checked
    func addGoalAction(item: AddGoalItemModel) {
        guard let id = item.id,
              let title = item.text else {return}
        
        let goalType: String = (item.type.rawValue).lowercased()
        
        let params: [String : Any] = ["user_id"    : id,
                                      "goal_type"  : goalType,
                                      "title"      : title]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: AddGoalItemModel.self, params: params, headers: nil)
    }
    
    
    func saveCoverGoalItemAction(_ image: UIImage, _ id: Int) {
        
        guard let dataImage = UIImageJPEGRepresentation(image, 0.9) else {return}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm:ss"
        
        let dateObj = dateFormatter.string(from: Date())
        
        let imageName = dateObj
       
        
        let params: [String : Any] = ["image"                        : dataImage,
                                      "filename"                     : imageName,
                                      DefaultText.apiInnerConstParam : id]
        
        operationAPI.operationAPICallMedia(method: HTTPMethod.post, modelType: MemorizeUploadCoverModel.self, params: params, headers: nil)
        
//        let imageString = String.convertImageToBase64(image: image)
//        let params: [String : Any] = ["media"                        : imageString,
//                                      DefaultText.apiInnerConstParam : id]
//        
//        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: MemorizeUploadCoverModel.self, params: params, headers: nil)
    }
}

extension AddGoalViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        if object is AddGoalItemModel {
            ParseResponseClass.parseObject(modelType: AddGoalItemModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                guard let goalId = result.id else {return}
                (this.delegate as? AddGoalViewController)?.titleSaved(goalId)
            })
        }
        
        if object is MemorizeUploadCoverModel {
            ParseResponseClass.parseObject(modelType: MemorizeUploadCoverModel.self, object: object, success: { [weak self] (result) in
                
                guard let this = self else {return}
                (this.delegate as? AddGoalViewController)?.coverSaved()
            })
        }
    }
}
