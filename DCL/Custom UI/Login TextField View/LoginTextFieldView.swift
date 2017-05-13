//
//  LoginTextFieldView.swift
//  DCL
//
//  Created by Nikita on 1/30/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

enum FieldType: String {
    case Name = "Name"
    case Email = "Email"
    case Password = "Password"
    case RetypePassword = "Retype Password"
    case GroupName = "Group Name"
}

protocol LoginTextFieldViewDelegate: class {
    func enteredText(_ text: String, _ type: FieldType)
    func textFieldShouldReturnPressed(_ type: FieldType)
}

class LoginTextFieldView: UIView {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    // var
    weak var delegate : LoginTextFieldViewDelegate?
    
    var currentType: FieldType!
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
    }
    
    class func loadFromXib(bundle : Bundle? = nil) -> LoginTextFieldView? {
        return UINib(
            nibName: String(describing: LoginTextFieldView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? LoginTextFieldView
    }
    
    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    func updateUI(_ type: FieldType, returnButtonType: UIReturnKeyType, keyboardEnable: Bool) {
        titleLabel.text = type.rawValue
        currentType = type
        changeTextField(type)
        textField.returnKeyType = returnButtonType
        if keyboardEnable {
            textField.becomeFirstResponder()
        }
    }
    
    private func changeTextField(_ type: FieldType) {
        if type == .Password || type == .RetypePassword {
            textField.isSecureTextEntry = true
        } else if type == .Name || type == .GroupName {
            textField.autocapitalizationType = .words
        }
    }
 }

extension LoginTextFieldView: UITextFieldDelegate {
    
    //*****************************************************************
    // MARK: - UITextFieldDelegate
    //*****************************************************************
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let fullString = textField.text! + string
        
        let result = string.detectBackspacePressed()
        
        if result {
            if textField.text!.characters.count >= 0 {
                let newStr = String(textField.text!.characters.dropLast())
                guard  let delegate = delegate  else {
                    return true
                }
                delegate.enteredText(newStr, currentType)
            }
            return true
        }
        
        if string.isValidEmail() && currentType == FieldType.Email {
            return false
        }
        
        if string.containsEmoji() && currentType == FieldType.Name ||
           !string.isValidLoginOnly() && currentType == FieldType.Name {
            return false
        }
        
        if string.containsEmoji() && currentType == FieldType.Password ||
           string.containsEmoji() && currentType == FieldType.RetypePassword {
            return false
        }
        
        guard  let delegate = delegate  else {
            return true
        }
        delegate.enteredText(fullString, currentType)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard  let delegate = delegate  else {
            return true
        }
        delegate.textFieldShouldReturnPressed(currentType)

        return true
    }
}


