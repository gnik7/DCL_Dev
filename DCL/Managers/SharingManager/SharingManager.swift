//
//  SharingManager.swift
//  DCL
//
//  Created by Nikita on 2/23/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit


struct SharingManager {
    
    //*****************************************************************
    // MARK: - Sharing
    //*****************************************************************
    
    static func showSharing(controller :UIViewController, shareContent:String?, action: (() -> ())?){
        
        let activityViewController = UIActivityViewController(activityItems: [shareContent! as NSString], applicationActivities: nil)
        
        let popOver = activityViewController.popoverPresentationController
        popOver?.sourceView  = controller.view
        popOver?.sourceRect = controller.view.bounds
        popOver?.permittedArrowDirections = UIPopoverArrowDirection.any
        
//        if let vc = controller as? IZSingleVideoViewController{
//            let sender = vc.shareButton
//            activityViewController.popoverPresentationController?.sourceView = sender
//        }
        
        controller.present(activityViewController, animated: true, completion: nil)
    }
}
