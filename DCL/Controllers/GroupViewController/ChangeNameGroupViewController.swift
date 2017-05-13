//
//  ChangeNameGroupViewController.swift
//  DCL
//
//  Created by Nikita Gil on 05.04.17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit


class ChangeNameGroupViewController: BaseMainViewController {
    
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    var groupItem: GroupModelItem?
    
    private var groupCustomView : LoginTextFieldView?
    fileprivate var viewModel = ChangeNameGroupViewViewModel()
    
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        loadLoginPasswordView()
        subscribeForKeyboardNotifications()
        updateUiEdit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.makeRoundView()
    }
    
    private func subscribeForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    private func updateUiEdit(){
        
        guard let item = groupItem else {return}
        
        groupCustomView?.textField.text = item.name ?? ""
    }
    
    //*****************************************************************
    // MARK: - Load View
    //*****************************************************************
    
    private func loadLoginPasswordView() {
        
        // add email view textfield
        groupCustomView = LoginTextFieldView.loadFromXib()
        groupCustomView?.frame = CGRect(x: 0, y: 0, width: groupView.frame.size.width, height: groupView.frame.size.height)
        groupCustomView?.delegate = self
        groupCustomView?.updateUI(FieldType.GroupName, returnButtonType: UIReturnKeyType.done, keyboardEnable: true)
        groupView.addSubview(groupCustomView!)
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        router.popViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        saveGroup()
    }
    
    //*****************************************************************
    // MARK: - API
    //*****************************************************************
    
    func saveGroup(){
        self.view.endEditing(true)
        viewModel.createNewGroupAction(item: groupItem!)
    }
    
    func saved(){
        router.popViewController()
    }
}

extension ChangeNameGroupViewController: LoginTextFieldViewDelegate {
    
    //*****************************************************************
    // MARK: - LoginTextFieldViewDelegate
    //*****************************************************************
    
    func enteredText(_ text: String, _ type: FieldType){
        groupItem?.name = text
    }
    
    func textFieldShouldReturnPressed(_ type: FieldType){
        if type == FieldType.GroupName {
            saveGroup()
        }
    }
}

extension ChangeNameGroupViewController: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){}
    
    func viewModelDidEndUpdate(){}
}

