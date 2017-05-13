//
//  LoginViewController.swift
//  DCL
//
//  Created by Nikita on 1/30/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

class LoginViewController: BaseLoginViewController {
    
    @IBOutlet weak var signInButton     : UIButton!
    @IBOutlet weak var facebookButton   : UIButton!
    @IBOutlet weak var titleLabel       : UILabel!
    
    
    fileprivate var viewModel = LoginViewModel()
    fileprivate var regModel = UserFromFacebookModel()
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.attributedText = createTitle()
        viewModel.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signInButton.cornerRadius = signInButton.frame.height / 2
        facebookButton.cornerRadius = facebookButton.frame.height / 2
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    
    private func createTitle() -> NSAttributedString {
        
        let myAttribute1 = [ NSFontAttributeName: UIFont(name: "SFUIDisplay-Regular", size: 20) as Any,
                             NSForegroundColorAttributeName: UIColor.white ]
        
        let myAttribute2 = [ NSFontAttributeName: UIFont(name: "SFUIDisplay-Regular", size: 16) as Any,
                             NSForegroundColorAttributeName: UIColor.white ]
        
        let attributeString1 = NSMutableAttributedString(string: DefaultText.ConvertYourDreams, attributes: myAttribute1)
        let attributeString2 = NSMutableAttributedString(string: DefaultText.IntoRealLife, attributes: myAttribute2)
        let attributeString3 = NSMutableAttributedString(string: " ", attributes: myAttribute1)
        
        let attrStringAll = NSMutableAttributedString()
        attrStringAll.append(attributeString1)
        attrStringAll.append(attributeString3)
        attrStringAll.append(attributeString2)
        
        return attrStringAll
    }

    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
       router.showSignInViewController()
    }
    
    @IBAction func facebookButtonPressed(_ sender: UIButton) {
        FacebookManager.actionSignInFacebook(controller: self, response: { [weak self](result) in
            
            guard let this = self, let token = result as? String  else {return}
            this.viewModel.registerAction(token)
        })
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        router.showSignUpViewController()
    }
}


extension LoginViewController: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){
    }
    
    func viewModelDidEndUpdate(){
    }
}

