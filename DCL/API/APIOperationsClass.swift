//
//  APIOperationsClass.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import Alamofire

/**
 * Enum not use, for future refactoring
 */
enum Methods {
    case POST
    case GET
    case PUT
    case PATCH
    case DELETE
    case UPDATE
}

/**
 * Operation Delegate
 */
@objc protocol APIOperationsClassDelegate {
    
    @objc optional func responseOperationObject(_ object : Any)
    @objc optional func updateMainModel()
}

/**
 * Operation Class
 */
class APIOperationsClass : NSObject {
    
    var operationsDelegate  : APIOperationsClassDelegate?
    
    func operationAPICallWithHUD <T:Mappable> (method: HTTPMethod, modelType:T.Type, params:Dictionary<String, Any>?, headers:Dictionary<String, String>?)->Void where T:Mappable,T:Meta {
        
        LoaderManager.sharedInstance.showView()
        
        RestApiClass.sharedInstance.callAPIResponse(method: method, type: modelType, params: params, headers:headers, success: { response in
            LoaderManager.sharedInstance.hideView()
            self.operationsDelegate?.responseOperationObject!(response)
        })
    }
    
    func operationAPICallWithBodyWithHUD <T:Mappable> (method: HTTPMethod, modelType:T.Type, params:Dictionary<String, Any>?, headers:Dictionary<String, String>?)->Void where T:Mappable,T:Meta {
        
        LoaderManager.sharedInstance.showView()
        
        RestApiClass.sharedInstance.callAPIResponseWithBody(method: method, type: modelType, params: params, headers:headers, success: { response in
            LoaderManager.sharedInstance.hideView()
            self.operationsDelegate?.responseOperationObject!(response)
        })
    }
    
    func operationAPICallMedia <T:Mappable> (method: HTTPMethod, modelType:T.Type, params:Dictionary<String, Any>?, headers:Dictionary<String, String>?)->Void where T:Mappable,T:Meta {
        
        LoaderManager.sharedInstance.showView()
        RestApiClass.sharedInstance.callAPIResponseForMedia(method: method, type: modelType, params: params!, headers: headers,
                                                            success: { (response) in
            LoaderManager.sharedInstance.hideView()
            self.operationsDelegate?.responseOperationObject!(response)
        })
    }

    
    func operationAPICall <T:Mappable> (method: HTTPMethod, modelType:T.Type, params:Dictionary<String, Any>?, headers:Dictionary<String, String>?)->Void where T:Mappable,T:Meta {
        
        RestApiClass.sharedInstance.callAPIResponse(method: method, type: modelType, params: params, headers:headers, success: { response in
            self.operationsDelegate?.responseOperationObject!(response)
        })
    }
    
    func operationAPICallWithBody <T:Mappable> (method: HTTPMethod, modelType:T.Type, params:Dictionary<String, Any>?, headers:Dictionary<String, String>?)->Void where T:Mappable,T:Meta {
        RestApiClass.sharedInstance.callAPIResponseWithBody(method: method, type: modelType, params: params, headers:headers, success: { response in
            self.operationsDelegate?.responseOperationObject!(response)
        })
    }
}
