//
//  LoaderManager.swift
//  DCL
//
//  Created by Nikita on 2/10/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit


class LoaderManager {
    
    var loader : LoaderView?
    static let sharedInstance = LoaderManager()
    var isShowing = false
    
    static let notificationName = "LoaderManagerActivity"
    
    //*****************************************************************
    // MARK: - Show / Hide loader
    //*****************************************************************
   
    func showView() {
        DispatchQueue.main.async {
            if UIApplication.shared.keyWindow != nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LoaderManager.notificationName), object: nil, userInfo: ["show" : true])
                if self.loader == nil {
                    self.loader = LoaderView.loadFromXib()
                    self.loader?.loadView()
                    self.isShowing = true
                }
                self.loader?.showView()
                self.isShowing = true
            }
        }
    }
    func hideView() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LoaderManager.notificationName), object: nil, userInfo: ["show" : false])
            self.loader?.hideView()
            self.isShowing = false
        }
    }
}
