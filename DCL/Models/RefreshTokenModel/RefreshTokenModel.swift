//
//  RefreshTokenModel.swift
//  DCL
//
//  Created by Nikita on 2/17/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class RefreshTokenModel: ResponseSimpleModel, Meta{
    
    var token : String?
    
    required convenience init?(map: Map) {
        self.init()
        
        token <- map["result.token"]
        
        recordToken(token)
    }
    
    //*****************************************************************
    // MARK: - write token
    //*****************************************************************
    
    private func recordToken(_ token: String?) {
        guard let token = token else {
            return
        }
//        let _ = KeychainManager.recordInKeychain(token: token, key: KeychainManager.kEmailTokenKey)
        UserDefaultsManager.recordToken(token: token, key: UserDefaultsManager.kEmailTokenKey)
    }
    
    // Implementation of Meta protocol
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.refresh_auth)
        }
    }
}

