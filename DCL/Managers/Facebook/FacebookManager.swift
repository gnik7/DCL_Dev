//
//  FacebookManager.swift
//  DCL
//
//  Created by Nikita on 2/8/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class FacebookManager {
    
    class func actionSignInFacebook(controller: UIViewController, response: @escaping(AnyObject?) -> ()){
    
        let manager = FBSDKLoginManager()
        manager.logOut()
        
        manager.logIn(withReadPermissions: ["public_profile", "email"], from: controller, handler: { (result, error) in
            
            if FBSDKAccessToken.current() != nil {
                FBSDKGraphRequest(graphPath: "me?fields=picture.type(large),email,name,first_name,last_name,about,birthday,education,gender,hometown,location,work", parameters: nil).start(completionHandler: { (request, data, error) in
                    
                    if (error) != nil {
                        print("Process error");
                    } else if (result?.isCancelled)! {
                        print("Cancelled");
                    } else {
                        print("Logged in");
                    }

                    UserDefaultsManager.recordToken(token: FBSDKAccessToken.current().tokenString, key: UserDefaultsManager.kFBTokenKey)
                    print(FBSDKAccessToken.current().tokenString)
                    response(FBSDKAccessToken.current().tokenString as AnyObject?)
                })
            }            
        })
    }
}
