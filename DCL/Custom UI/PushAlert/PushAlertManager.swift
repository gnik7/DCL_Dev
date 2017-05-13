//
//  PushAlertManager.swift
//  DCL
//
//  Created by Nikita on 3/29/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

class PushAlertManager {
    
    var loader : PushAlertView?
    static let sharedInstance = PushAlertManager()
    
    //*****************************************************************
    // MARK: - Show / Hide loader
    //*****************************************************************
    
    func showView(_ info: PushInfo, _ action: ((_ type: PushAlertViewType) -> ())?) {
        
        DispatchQueue.main.async {
            if UIApplication.shared.keyWindow != nil {
                if self.loader == nil {
                    self.loader = PushAlertView.loadFromXib()
                    self.loader?.bringToFront()
                }
                self.loader?.showView(info, action)
            }
        }
    }
    func hideView() {
        DispatchQueue.main.async {
            self.loader?.hideView()
            self.loader = nil
        }
    }
}

