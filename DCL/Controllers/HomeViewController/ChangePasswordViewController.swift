//
//  ChangePasswordViewController.swift
//  DCL
//
//  Created by Nikita on 3/1/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import AssetsLibrary
import MobileCoreServices

class ChangePasswordViewController: BaseMainViewController {
    
    @IBOutlet weak var passwordContainerView    : UIView!
    @IBOutlet weak var retypeContainerView      : UIView!
    @IBOutlet weak var saveButton     : UIButton!
    
    fileprivate var passwordView    : LoginTextFieldView?
    fileprivate var retypeView      : LoginTextFieldView?
    
    fileprivate var viewModel = ChangePasswordViewModel()
    fileprivate var regModel = ChangePasswordModel()
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        loadLoginPasswordView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //beginHeght = typesView.frame
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bordedViews()
    }
    
    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    private func bordedViews() {
        saveButton.makeRoundView()
    }
    
    //*****************************************************************
    // MARK: - Load View
    //*****************************************************************
    
    private func loadLoginPasswordView() {
        
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
    }

    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        self.gestureTap()
        apiCall()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        router.popViewController()
    }
    
    func bacAction(){
        router.popViewController()
    }
    
    //*****************************************************************
    // MARK: - API Call
    //*****************************************************************
    
    fileprivate func apiCall() {
        if regModel.checkFields() {
            viewModel.resetAction(regModel)
        } else {
            Alert.show(controller: self, title: AlertTitle.Error, message: AlertText.ValidationChangePassword, action: nil)
        }
    }
}

extension ChangePasswordViewController: LoginTextFieldViewDelegate {
    
    //*****************************************************************
    // MARK: - LoginTextFieldViewDelegate
    //*****************************************************************
    
    func enteredText(_ text: String, _ type: FieldType){
        if type == FieldType.Password {
            regModel.password = text
        } else if type == FieldType.RetypePassword {
            regModel.passwordRetype = text
        }
    }
    
    func textFieldShouldReturnPressed(_ type: FieldType){
        if type == FieldType.Password {
            retypeView?.textField.becomeFirstResponder()
        } else if type == FieldType.RetypePassword {
            self.gestureTap()
            apiCall()
        }
    }
}

extension ChangePasswordViewController: ViewModelDelegate {
    
    //*****************************************************************
    // MARK: - ViewModelDelegate
    //*****************************************************************
    
    func viewModelDidStartUpdate(){
    }
    
    func viewModelDidEndUpdate(){
    }
}

