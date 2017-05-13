//
//  SignUpViewController.swift
//  DCL
//
//  Created by Nikita on 2/8/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

class SignUpViewController: BaseLoginViewController {
    
    @IBOutlet weak var emailContainerView       : UIView!
    @IBOutlet weak var loginContainerView       : UIView!
    @IBOutlet weak var passwordContainerView    : UIView!
    @IBOutlet weak var retypeContainerView      : UIView!
    @IBOutlet weak var navigationView           : UIView!
    
    @IBOutlet weak var registerButton           : UIButton!
    
    fileprivate var emailView       : LoginTextFieldView?
    fileprivate var loginView       : LoginTextFieldView?
    fileprivate var passwordView    : LoginTextFieldView?
    fileprivate var retypeView      : LoginTextFieldView?
    fileprivate var navigView       : LoginNavigationView?
    
    fileprivate var viewModel = SignUpViewModel()
    fileprivate var regModel = UserFromEmailModel()
    
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
        
        registerButton.cornerRadius = registerButton.frame.height / 2
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
        
        // add email view textfield
        emailView = LoginTextFieldView.loadFromXib()
        emailView?.frame = CGRect(x: 0, y: 0, width: emailContainerView.frame.size.width, height: emailContainerView.frame.size.height)
        emailView?.delegate = self
        emailView?.updateUI(FieldType.Email, returnButtonType: UIReturnKeyType.next, keyboardEnable: true)
        emailContainerView.addSubview(emailView!)
        
        // add login view textfield
        loginView = LoginTextFieldView.loadFromXib()
        loginView?.frame = CGRect(x: 0, y: 0, width: loginContainerView.frame.size.width, height: loginContainerView.frame.size.height)
        loginView?.delegate = self
        loginView?.updateUI(FieldType.Name, returnButtonType: UIReturnKeyType.next, keyboardEnable: false)
        loginContainerView.addSubview(loginView!)

        // add password view textfield
        passwordView = LoginTextFieldView.loadFromXib()
        passwordView?.frame = CGRect(x: 0, y: 0, width: passwordContainerView.frame.size.width, height: passwordContainerView.frame.size.height)
        passwordView?.delegate = self
        passwordView?.updateUI(FieldType.Password, returnButtonType: UIReturnKeyType.next, keyboardEnable: false)
        passwordContainerView.addSubview(passwordView!)
        
        // add retype password view textfield
        retypeView = LoginTextFieldView.loadFromXib()
        retypeView?.frame = CGRect(x: 0, y: 0, width: retypeContainerView.frame.size.width, height: retypeContainerView.frame.size.height)
        retypeView?.delegate = self
        retypeView?.updateUI(FieldType.RetypePassword, returnButtonType: UIReturnKeyType.done, keyboardEnable: false)
        retypeContainerView.addSubview(retypeView!)
        
        //add navigation view
        navigView = LoginNavigationView.loadFromXib()
        navigView?.frame = CGRect(x: 0, y: 0, width: navigationView.frame.size.width, height: navigationView.frame.size.height)
        navigView?.delegate = self
        navigationView.addSubview(navigView!)
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
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        apiCall()
    }
    
    fileprivate func apiCall() {
        
        if !(regModel.user.checkFields()) {
            Alert.show(controller: self, title: AlertTitle.TitleCommon, message: DefaultText.RegistrFieldEmpty, action: nil)
            return
        }
        
        if !(regModel.user.checkPassword()) {
            Alert.show(controller: self, title: AlertTitle.TitleCommon, message: DefaultText.PasswordRetypeNotEqual, action: nil)
            return
        }
        
        viewModel.registrateByEmailAction(regModel)
    }
}

extension SignUpViewController: LoginTextFieldViewDelegate {
    
    //*****************************************************************
    // MARK: - LoginTextFieldViewDelegate
    //*****************************************************************
    
    func enteredText(_ text: String, _ type: FieldType){
        if type == FieldType.Email {
            regModel.user.email = text
        } else if type == FieldType.Name {
            regModel.user.name = text
        } else if type == FieldType.Password {
            regModel.user.password = text
        } else if type == FieldType.RetypePassword {
            regModel.user.passwordConfirmation = text
        }
    }
    
    func textFieldShouldReturnPressed(_ type: FieldType){
        if type == FieldType.Email {
            loginView?.textField.becomeFirstResponder()
        } else if type == FieldType.Name {
            passwordView?.textField.becomeFirstResponder()
        } else if type == FieldType.Password {
           retypeView?.textField.becomeFirstResponder()
        } else if type == FieldType.RetypePassword {
            self.gestureTap()
            apiCall()
        }
    }
}

extension SignUpViewController: ViewModelDelegate {

    func viewModelDidStartUpdate(){
    }
    
    func viewModelDidEndUpdate(){
    }    
}

