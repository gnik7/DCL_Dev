//
//  ProfileViewModel.swift
//  DCL
//
//  Created by Nikita on 3/1/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ProfileViewModel : ViewModel {
    
    var email: String!
    var avatarImage: UIImage!
    
    /// API call for reset functionality
    ///
    /// - Parameter model: contain email for reset already checked
    func resetEmailAction(_ email: String) {
        self.email = email
        let params = ["email": email]
        
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.patch, modelType: ChangeEmailModel.self, params: params, headers: nil)
    }
    
    func resetAvatarAction(_ image: UIImage) {
        avatarImage = image
        let imageString = String.convertImageToBase64(image: image)
        let params = ["avatar": imageString]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.patch, modelType: ChangeAvatarModel.self, params: params, headers: nil)
    }
    
    func logoutAction() {       
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.post, modelType: LogoutModel.self, params: nil, headers: nil)
    }
    
    func notifiableAction(_ state: Bool) {
        
        let params: [String : Any] = ["is_notifiable" : state]
        operationAPI.operationAPICallWithBodyWithHUD(method: HTTPMethod.patch, modelType: ProfileNotifiableModel.self, params: params, headers: nil)
    }
}

extension ProfileViewModel : APIOperationsClassDelegate {
    
    //*****************************************************************
    // MARK: - APIOperationsClassDelegate
    //*****************************************************************
    
    /// Request processing logic
    ///
    /// - Parameter object: The object obtained from the API
    func responseOperationObject(_ object: Any) {
        
        if object is ChangeEmailModel{
            ParseResponseClass.parseObject(modelType: ChangeEmailModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? ProfileViewController)?.updateChangedEmail(this.email)
            })
        }
        
        if object is ChangeAvatarModel{
            ParseResponseClass.parseObject(modelType: ChangeAvatarModel.self, object: object, success: {[weak self] (result) in
                guard let this = self, let url = result.avatarUrl else {return}
                (this.delegate as? ProfileViewController)?.updateChangedAvatar(url, this.avatarImage)
            })
        }
        
        if object is LogoutModel{
            ParseResponseClass.parseObject(modelType: LogoutModel.self, object: object, success: {(result) in
            })
        }
        
        if object is ProfileNotifiableModel{
            ParseResponseClass.parseObject(modelType: ProfileNotifiableModel.self, object: object, success: {[weak self] (result) in
                guard let this = self else {return}
                (this.delegate as? ProfileViewController)?.updateNotifications(result.user)
            })
        }
    }
}
