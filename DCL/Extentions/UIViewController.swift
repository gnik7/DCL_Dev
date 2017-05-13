//
//  UIViewController.swift
//  DCL
//
//  Created by Nikita on 2/28/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import MobileCoreServices


extension UIViewController {

    
    func showImagePickerController(type: UIImagePickerControllerSourceType, delegate:UINavigationControllerDelegate&UIImagePickerControllerDelegate) {
        let imagePickerController = UIImagePickerController()
        if (type == .camera) {
            if (!UIImagePickerController.isCameraDeviceAvailable(.rear) && !UIImagePickerController.isCameraDeviceAvailable(.front)) {
                Alert.show(controller: self, title: "", message: "NO CAMERA!", action: nil)
                return
            }
        }
        imagePickerController.delegate = delegate
        imagePickerController.sourceType = type
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func detectCameraPermissionsAndPresent() -> Bool {
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch status {
        case .authorized:
            return true
        case .denied:
            
            Alert.show(controller: self, title: "DCL doesn't have access to camera", message: "You can enable access in Privacy Settings", action: {
                
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.openURL(url)
                }
            })
            break
        case .restricted:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted :Bool) in
                if granted == true {
                   
                }
                else {
                    Alert.show(controller: self, title: "DCL doesn't have access to camera", message: "You can enable access in Privacy Settings", action: {
                        
                        let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                        if let url = settingsUrl {
                            UIApplication.shared.openURL(url)
                        }
                    })
                    
                }
            })
            return true
        }
        
        return false
    }

    
}
