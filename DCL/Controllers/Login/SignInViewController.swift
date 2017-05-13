//
//  SignInViewController.swift
//  DCL
//
//  Created by Nikita on 1/30/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

class SignInViewController: BaseLoginViewController {
    
    @IBOutlet weak var loginContainerView       : UIView!
    @IBOutlet weak var passwordContainerView    : UIView!
    @IBOutlet weak var loginNavigationView      : UIView!
    
    @IBOutlet weak var signInButton             : UIButton!
    
    fileprivate var loginView       : LoginTextFieldView?
    fileprivate var passwordView    : LoginTextFieldView?
    fileprivate var navigView       : LoginNavigationView?
    
    fileprivate var viewModel = SignInViewModel()
    fileprivate var regModel = SignInModel()
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        loadLoginPasswordView()
        subscribeForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signInButton.cornerRadius = signInButton.frame.height / 2
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .default
        }
    }
    
    //*****************************************************************
    // MARK: - Load View
    //*****************************************************************
    
    private func loadLoginPasswordView() {
        
        // add login view textfield
        loginView = LoginTextFieldView.loadFromXib()
        loginView?.frame = CGRect(x: 0, y: 0, width: loginContainerView.frame.size.width, height: loginContainerView.frame.size.height)
        loginView?.delegate = self
        loginView?.updateUI(FieldType.Email, returnButtonType: UIReturnKeyType.next, keyboardEnable: true)
        loginContainerView.addSubview(loginView!)
        
        // add password view textfield
        passwordView = LoginTextFieldView.loadFromXib()
        passwordView?.frame = CGRect(x: 0, y: 0, width: passwordContainerView.frame.size.width, height: passwordContainerView.frame.size.height)
        passwordView?.delegate = self
        passwordView?.updateUI(FieldType.Password, returnButtonType: UIReturnKeyType.done, keyboardEnable: false)
        passwordContainerView.addSubview(passwordView!)
        
        //add navigation view
        navigView = LoginNavigationView.loadFromXib()
        navigView?.frame = CGRect(x: 0, y: 0, width: loginNavigationView.frame.size.width, height: loginNavigationView.frame.size.height)
        navigView?.delegate = self
        loginNavigationView.addSubview(navigView!)
    }
    
    //*****************************************************************
    // MARK: - Keyboard Notifications
    //*****************************************************************
    
    func subscribeForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func hereButtonPressed(_ sender: UIButton) {
        router.showForgotViewController()
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        apiCall()
    }
    
    fileprivate func apiCall() {
        self.gestureTap()
        if regModel.checkFields() {
            viewModel.loginAction(regModel)
        }
    }
}

extension SignInViewController: LoginTextFieldViewDelegate {
    
    //*****************************************************************
    // MARK: - LoginTextFieldViewDelegate
    //*****************************************************************
    
    func enteredText(_ text: String, _ type: FieldType){
        if type == FieldType.Email {
            regModel.user.email = text
        } else if type == FieldType.Password {
            regModel.user.password = text
        }
    }
    
    func textFieldShouldReturnPressed(_ type: FieldType){
        if type == FieldType.Email {
            passwordView?.textField.becomeFirstResponder()
        } else if type == FieldType.Password {
            apiCall()
        }
    }
}

extension SignInViewController: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){
    }
    
    func viewModelDidEndUpdate(){
    }
}


