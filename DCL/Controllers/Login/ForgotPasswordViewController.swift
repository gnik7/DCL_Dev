//
//  ForgotPasswordViewController.swift
//  DCL
//
//  Created by Nikita on 2/6/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseLoginViewController {
    
    @IBOutlet weak var emailContainerView       : UIView!
    @IBOutlet weak var navigationView           : UIView!
    
    @IBOutlet weak var resetButton              : UIButton!
    
    private var emailView       : LoginTextFieldView?
    private var navigView       : LoginNavigationView?
    
    fileprivate var viewModel = ForgotPasswordViewModel()
    fileprivate var forgotModel = ForgotModel()
    
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
        
        resetButton.cornerRadius = resetButton.frame.height / 2
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
        emailView?.updateUI(FieldType.Email, returnButtonType: UIReturnKeyType.go, keyboardEnable: false)
        emailContainerView.addSubview(emailView!)
        
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

    @IBAction func resetButtonPressed(_ sender: UIButton) {
        updateData()
    }
    
    //*****************************************************************
    // MARK: - Api Call
    //*****************************************************************
    
    fileprivate func updateData() {
        self.gestureTap()
        if forgotModel.checkFields() {
            viewModel.resetAction(forgotModel)
        }
    }
}

extension ForgotPasswordViewController: LoginTextFieldViewDelegate {
    
    //*****************************************************************
    // MARK: - LoginTextFieldViewDelegate
    //*****************************************************************
    
    func enteredText(_ text: String, _ type: FieldType){
        forgotModel.email = text
    }
    
    func textFieldShouldReturnPressed(_ type: FieldType){
        if type == FieldType.Email {
            updateData()
        }
    }
}

extension ForgotPasswordViewController: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){
    }
    
    func viewModelDidEndUpdate(){
    }
}
