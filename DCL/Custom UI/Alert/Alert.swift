//
//  Alert.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    
    //*****************************************************************
    // MARK: - Simple
    //*****************************************************************
    
    static func show(controller :UIViewController, title :String, message:String?, action: (() -> ())?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertActionStyle.cancel,
                                      handler: { act in
                                        if let action = action {
                                            action()
                                        }
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    
    static func showPhotoAlert(controller :UIViewController, actionPhoto: (() -> ())?, actionGallery: (() -> ())?) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            if let action = actionPhoto {
                action()
            }
        }
        alertController.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            if let action = actionGallery {
                action()
            }
        }
        alertController.addAction(libraryAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
}
