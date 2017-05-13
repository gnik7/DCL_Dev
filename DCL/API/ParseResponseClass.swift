//
//  ParseResponseClass.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class ParseResponseClass {


    static func parseObject <T:Mappable> (modelType:T.Type, object: Any, success:@escaping (T)->Void)->Void where T:ResponseSimpleModel {
        
        switch (object as! T).code {
            
        case 200:
            success(object as! T)
            
        case 404:
             NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: userNotFoundNotification), object: nil))
            
        case 422, 400:
            let messages = (object as! T).errors
            var messageString = ""
            
            if messages.count > 0 {
                for message in messages {
                    
                    if messageString.characters.count == 0 {
                        messageString = message.message
                    }else{
                        messageString = messageString + "\r\n" + (message.message)
                    }
                }
                
            } else {
                messageString = (object as! T).message
            }
             Alert.show(controller: Router.topViewController()!, title: AlertTitle.Error, message: messageString, action: nil)
        case 500: // error server
            print((object as! T).message)
            Alert.show(controller: Router.topCurrentViewController()!, title: AlertTitle.Error, message: "error server", action: nil)
        default:
            LoaderManager.sharedInstance.hideView()
            print("Debug info - object response - undefined status code")
            //UIApplication.showAlertMessage(message: (object as! T).message)
        }
    }
    
    static func parseObjectArray <T:Mappable> (modelType:T.Type, object: Any, success:@escaping (T)->Void)->Void where T:ResponseSimpleArrayModel {
        
        LoaderManager.sharedInstance.hideView()
        var code = 0
        if let codeT = (object as? T)?.code {
            code = codeT
        }
        if let codeArray = (object as? ResponseSimpleArrayModel)?.code {
            code = codeArray
        }
        
        switch code {
            
        case 200:
            guard let newObject = object as? T else {
                return
            }
            success(newObject)
            
        case 404:
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: userNotFoundNotification), object: nil))
            
        case 422, 400, 401:
            let messages = (object as! ResponseSimpleArrayModel).errors
            var messageString = ""
            if messages.count > 0 {
                for message in messages {
                    
                    if messageString.characters.count == 0 {
                        messageString = message.message
                    }else{
                        messageString = messageString + "\r\n" + (message.message)
                    }
                }

            } else {
                messageString = (object as! T).message
            }
            
           Alert.show(controller: Router.topViewController()!, title: AlertTitle.Error, message: messageString, action: nil)
            
        case 500: // error server
            print((object as! T).message)
            Alert.show(controller: Router.topCurrentViewController()!, title: AlertTitle.Error, message: "error server", action: nil)
        default:
            LoaderManager.sharedInstance.hideView()
            print("Debug info - object response - undefined status code")
            //UIApplication.showAlertMessage(message: (object as! T).message)
        }
    }
}
