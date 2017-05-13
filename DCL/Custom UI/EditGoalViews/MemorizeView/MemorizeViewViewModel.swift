//
//  MemorizeViewViewModel.swift
//  DCL
//
//  Created by Nikita on 2/24/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MemorizeViewViewModel : ViewModel {
    
    /// API call
    ///
    /// -
    func saveCoverGoalItemAction(_ image: UIImage, _ id: Int, _ url: NSURL) {
        
        guard let dataImage = UIImageJPEGRepresentation(image, 0.9) else {return}
        var imageName = "image"
        if let imageN = url.lastPathComponent {
            imageName = imageN
        }
        
        let params: [String : Any] = ["image"                        : dataImage,
                                      "filename"                     : imageName,
                                      DefaultText.apiInnerConstParam : id]
        
        operationAPI.operationAPICallMedia(method: HTTPMethod.post, modelType: MemorizeUploadCoverModel.self, params: params, headers: nil)
    }
    
    func saveMediaGoalItemAction(_ image: UIImage, _ id: Int,  _ url: NSURL) {
        
        guard let dataImage = UIImageJPEGRepresentation(image, 0.9) else {return}
        var imageName = "image"
        if let imageN = url.lastPathComponent {
            imageName = imageN
        }
        
        let params: [String : Any] = ["image"                        : dataImage,
                                      "filename"                     : imageName,
                                      DefaultText.apiInnerConstParam : id]
        
        operationAPI.operationAPICallMedia(method: HTTPMethod.post, modelType: MemorizeUploadMediaModel.self, params: params, headers: nil)
    }
    
    func saveVideoMediaGoalItemAction(_ url: URL, _ id: Int, _ urlfile: NSURL) {

        let mediaString = String.convertVideoToBase64(video: url)
        let result = mediaString.checkFileSize()
        if !result {
            Alert.show(controller: Router.topViewController()!, title: "Error", message: DefaultText.toBigFile, action: nil)
            return
        }
        
        var videoName = "video"
        if let video = urlfile.lastPathComponent {
            videoName = video
        }
        do {
            let data = try Data(contentsOf: url)
            
            
            let params: [String : Any] = ["video"                        : data,
                                          "filename"                     : videoName,
                                          DefaultText.apiInnerConstParam : id]
            
            operationAPI.operationAPICallMedia(method: HTTPMethod.post, modelType: MemorizeUploadMediaModel.self, params: params, headers: nil)

        } catch _ {
            print("Error")
        }
    }

    
    func deleteMediaGoalItemAction( _ idGoal: Int, _ idMedia: Int) {
        
        let params: [String : Any] = [DefaultText.apiInnerConstParam        : idGoal,
                                      DefaultText.apiInnerConstParamSecond  : idMedia]
        
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.delete, modelType: MemorizeDeleteMediaModel.self, params: params, headers: nil)
    }
}

extension MemorizeViewViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        if object is MemorizeUploadCoverModel {
            ParseResponseClass.parseObject(modelType: MemorizeUploadCoverModel.self, object: object, success: { [weak self] (result) in
                
                guard let this = self else {return}
                (this.delegate as? MemorizeView)?.savedCoverGoal(result.goalItem)
            })
        }
        
        if object is MemorizeUploadMediaModel {
            ParseResponseClass.parseObject(modelType: MemorizeUploadMediaModel.self, object: object, success: { [weak self] (result) in
                
                guard let this = self else {return}
                (this.delegate as? MemorizeView)?.savedMediaGoal(result.goalItem)
            })
        }
        
        if object is MemorizeDeleteMediaModel {
            ParseResponseClass.parseObject(modelType: MemorizeDeleteMediaModel.self, object: object, success: { [weak self] (result) in
                
                guard let this = self else {return}
                (this.delegate as? MemorizeView)?.updateMediaGoal(result.goalItem)
            })
        }

    }
}
