//
//  BaseLoginViewController.swift
//  DCL
//
//  Created by Nikita on 1/30/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
//protocol VCprotocol {
//    var update : UIViewController {get}
//  
//}


class BaseLoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    lazy var router :Router = Router(navigationController: self.navigationController!)
    lazy var tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureTap))
    
    let deltaHeight: CGFloat = 50.0
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    final func gestureTap() {
        self.view.endEditing(true)
    }    
    
    func keyboardWillShow(_ notification: Notification) {
        self.view.addGestureRecognizer(tapGesture)
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height + deltaHeight, 0)
                self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height + deltaHeight, 0)
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        self.view.removeGestureRecognizer(tapGesture)
        
        self.scrollView.contentInset = UIEdgeInsets.zero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }

}

extension BaseLoginViewController: LoginNavigationViewDelegate {
    
    //*****************************************************************
    // MARK: - LoginNavigationViewDelegate
    //*****************************************************************
    
    func backButtonWasPressed(){
        router.popViewController()
    }
}
