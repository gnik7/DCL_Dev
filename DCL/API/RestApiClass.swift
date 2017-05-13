//
//  RestApiClass.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper


class RestApiClass {

    // MARK: - Singleton
    static let sharedInstance : RestApiClass = {
        let instance = RestApiClass()
        return instance
    }()
    
    let defaultManager : Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            baseHost: .disableEvaluation
        ]
        let configuration = URLSessionConfiguration.default
        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()
    
    let reachabilityManager = NetworkReachabilityManager(host: "www.apple.com")
    
    /**
     *  Start network listener
     */
    func createNetworkListener(){
        reachabilityManager?.listener = { status in
            
            switch status {
                
            case .notReachable:
                print("network connection status - lost")
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                print("network connection status - ethernet/WiFI")
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                print("network connection status - wwan")
            default:
                break
            }
            /*
             TODO - code for procced outstanding request
             */
        }
        reachabilityManager?.startListening()
    }
    
    /**
     *  Cancel only task with ID
     */
    func cancelRequestByID(_ ind : String) {
        
        RestApiClass.sharedInstance.defaultManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            
            dataTasks.forEach {
                
                if $0.taskDescription == ind {
                    print("task canceled")
                    $0.cancel()
                }
            }
        }
    }
    
    /**
     *  Cancel all task
     */
    func cancelAllRequests() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            dataTasks.forEach { $0.cancel() }
        }
    }
    
    //MARK: Simple
    
    func callAPIResponse <T:Mappable> (method: HTTPMethod, type:T.Type, params:Dictionary<String, Any>?, headers: Dictionary<String, String>?, success:@escaping (T)->Void)->Void where T:Mappable,T:Meta {
        
        var paramEncoding: ParameterEncoding = URLEncoding.default
        var parameters = params
        if method == .get {
            paramEncoding = CustomGetEncoding()
            removeAPIInnerConstParamsFrom(&parameters)
        } else if method == .post {
            paramEncoding = CustomPostEncoding()
        }
        
        let fullPath = checkFullUrlPath(currentPath: type.url_get!(method: method.rawValue), params: params)
        removeAPIInnerConstParamsFrom(&parameters)
        RestApiClass.sharedInstance.defaultManager.request(fullPath, method:method, parameters: parameters, encoding: paramEncoding, headers: Headers().updateHeaders()).validate().responseObject(queue: nil, keyPath: nil, context: nil) { (response: DataResponse<T>) in
            
            self.proccedResponse(response: response, success: { (result) in
                success(result)
            })
        }.task?.taskDescription = String(fullPath)
    }
    
    //MARK: With Body
    
    func callAPIResponseWithBody <T:Mappable> (method: HTTPMethod, type:T.Type, params:Dictionary<String, Any>?, headers: Dictionary<String, String>?, success:@escaping (T)->Void)->Void where T:Mappable,T:Meta {
        
        
        let fullPath = checkFullUrlPath(currentPath: type.url_get!(method: method.rawValue), params: params)
        var parameters = params
        removeAPIInnerConstParamsFrom(&parameters)
        
        RestApiClass.sharedInstance.defaultManager.request(fullPath, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: Headers().updateHeaders()).responseObject { (response: DataResponse<T>) in
            
            self.proccedResponse(response: response, success: { (result) in
                success(result)
            })
        }.task?.taskDescription = String(fullPath)
    }
    
    //MARK: MultiPart
    
    func callAPIResponseForMedia <T:Mappable> (method: HTTPMethod, type:T.Type, params:Dictionary<String, Any>, headers: Dictionary<String, String>?, success:@escaping (T)->Void)->Void where T:Mappable,T:Meta {
        
        let fullPath = checkFullUrlPath(currentPath: type.url_get!(method: method.rawValue), params: params)
        print(fullPath)
        
        var fileName = ""
        if params["filename"] != nil {
            fileName = params["filename"] as! String
        }
        
        RestApiClass.sharedInstance.defaultManager.upload(
            multipartFormData: { multipartFormData in
                
                if params["image"] != nil {
                    let image = params["image"]
                    multipartFormData.append(image as! Data, withName: "media", fileName: params["filename"] as! String, mimeType: "jpeg")
                }
                
                if params["video"] != nil {
                    let video = params["video"]
                    multipartFormData.append(video as! Data, withName: "media", fileName: params["filename"] as! String, mimeType: "m4v")
                }
        },
            to: fullPath,
            headers: Headers().updateHeadersMultiPart(fileName),
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseObject(completionHandler: { (response: DataResponse<T>) in
                        self.proccedResponse(response: response, success: { (result) in
                            success(result)
                        })
                    })
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    
    /**
     * Functions for parse response:
     */
    func proccedResponse <T:Mappable> (response:DataResponse<T>, success:@escaping (T)->Void) {
        
        let data = response.data
        switch response.result {
            
        case .success (let item):
            success(item)
            
        case .failure(let error as NSError):           
            
            LoaderManager.sharedInstance.hideView()
            
            switch error.localizedDescription {
            case "cancelled":
                print("response canceled")
                Alert.show(controller: Router.topViewController()!, title: AlertTitle.Error, message: "response canceled", action: nil)
                break;
            default:
                print(error.localizedDescription)
                guard let json = convertToDictionary(data: data!) else {
                     Alert.show(controller: Router.topViewController()!, title: AlertTitle.Error, message:DefaultText.ServerError, action: nil)
                    return
                }
                let respObj = Mapper<T>().map(JSON: json)
                
                guard let object = respObj else {
                    Alert.show(controller: Router.topViewController()!, title: AlertTitle.Error, message: error.localizedDescription, action: nil)
                    return
                }
                
                if let messages = (respObj as? ResponseSimpleArrayModel)  {
                    Alert.show(controller: Router.topViewController()!, title: AlertTitle.Error, message: (messages.errors.first)?.message , action: nil)
                }
                
                if let message = (respObj as? ResponseSimpleModel)?.message  {
                    Alert.show(controller: Router.topViewController()!, title: AlertTitle.Error, message: message, action: nil)
                }
                                
                success(object)
            }
            
        default:break
        }
    }
    
    /**
     * Functions for get additional url path params:
     */
    func checkFullUrlPath(currentPath: String, params:Dictionary<String, Any>?) -> String {
        
        if params?[DefaultText.apiConstParam] != nil {
            return currentPath + "/" + (params![DefaultText.apiConstParam] as! String)
        } else if params?[DefaultText.apiInnerConstParam] != nil {
            if params?[DefaultText.apiInnerConstParamSecond] != nil{
                let begin = String(format:currentPath, (params![DefaultText.apiInnerConstParam] as! Int))
                let fullString = begin + "/" + String(params![DefaultText.apiInnerConstParamSecond] as! Int)
                return fullString
            } else {
                return  String(format:currentPath, (params![DefaultText.apiInnerConstParam] as! Int))
            }
        } else {
            return currentPath
        }
        
        
    }
    
    func convertToDictionary(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    private func removeAPIInnerConstParamsFrom( _ dictionary: inout Dictionary<String, Any>?) {
        dictionary?.removeValue(forKey: DefaultText.apiInnerConstParam)
        dictionary?.removeValue(forKey: DefaultText.apiInnerConstParamSecond)
        dictionary?.removeValue(forKey: DefaultText.apiConstParam)
    }
}

// Remove square brackets for GET request
struct CustomGetEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try URLEncoding().encode(urlRequest, with: parameters)
        request.url = URL(string: request.url!.absoluteString.replacingOccurrences(of: "%3D=", with: "="))
        return request
    }
}

// Remove square brackets for POST request
struct CustomPostEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try URLEncoding().encode(urlRequest, with: parameters)
        let httpBody = NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)!
        request.httpBody = httpBody.replacingOccurrences(of: "%3D=", with: "=").data(using: .utf8)
        return request
    }
}

struct Headers {
    func updateHeaders() -> HTTPHeaders {
        let header  = [
            "Accept"        : "application/json",
            "Content-Type"  : "application/json",
            "X-Device-Key"  :  UserDefaultsManager.updateInfoFromKeychain(UserDefaultsManager.kApnTokenKey),
            "X-Device-Os"   : "iOS",
            "Authorization" : "bearer \(UserDefaultsManager.updateInfoFromKeychain(UserDefaultsManager.kEmailTokenKey))",
            "X-Device-Udid" : UIDevice.current.identifierForVendor!.uuidString
        ]
        return header
    }
    
    
    func updateHeadersMultiPart(_ filename: String) -> HTTPHeaders {
        let header  = [
            "Accept"        : "application/json",
            "Content-Type"  : "multipart/form-data",
            "X-Device-Key"  : UserDefaultsManager.updateInfoFromKeychain(UserDefaultsManager.kApnTokenKey),
            "X-Device-Os"   : "iOS",
            "X-Device-Udid" : UIDevice.current.identifierForVendor!.uuidString,
            "Authorization" : "bearer \(UserDefaultsManager.updateInfoFromKeychain(UserDefaultsManager.kEmailTokenKey))",
            "Content-Disposition" : "form-data; name=\"media\"; filename=\"\(filename)\""
        ]
        return header
    }
}





