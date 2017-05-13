//
//  BaseMainViewController.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

class BaseMainViewController: UIViewController {
    
    var tmpView: UIView?
    var forYPosView: UIView?
    var additionalHeigh: CGFloat = 0
    var beginHeght: CGRect = CGRect.zero
    var keyboardHeight: CGFloat = 0
    
    lazy var router :Router = Router(navigationController: self.navigationController!)
    lazy var tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureTap))
    
    let deltaHeight: CGFloat = 50.0
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(needHideKeyBoard(_:)), name: NSNotification.Name(rawValue: appFallSleepNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(needLogout(_:)), name: NSNotification.Name(rawValue: userNotFoundNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func needHideKeyBoard(_ notification: Notification) {
        self.view.endEditing(true)
    }
    
    func needLogout(_ notification: Notification) {
        UserDefaultsManager.cleanTokenInKeychain(UserDefaultsManager.kEmailTokenKey)
        UserDefaultsManager.cleanTokenInKeychain(UserDefaultsManager.kFBTokenKey)
        router.showLogoutViewController()
    }
    
    final func gestureTap() {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        self.view.addGestureRecognizer(tapGesture)
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                keyboardHeight = keyboardSize.size.height
                if tmpView != nil {
                    tmpView?.frame.size.height = (tmpView?.frame.size.height)! - keyboardSize.size.height + additionalHeigh
                }
                if forYPosView != nil {
                    forYPosView?.frame.origin.y = (forYPosView?.frame.origin.y)! - keyboardSize.size.height
                }
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        hideKeyboard()
        self.view.removeGestureRecognizer(tapGesture)
        if tmpView != nil {
            tmpView?.frame.size.height = beginHeght.size.height
            
        }
        if forYPosView != nil {
            forYPosView?.frame.origin.y = beginHeght.origin.y
            
        }
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
}

