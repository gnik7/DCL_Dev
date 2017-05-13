//
//  EmailChangeView.swift
//  DCL
//
//  Created by Nikita on 3/1/17.
//  Copyright © 2017 Nikita. All rights reserved.
//


import UIKit


class EmailChangeView: UIView {
    
    @IBOutlet weak var mainView         : UIView!
    @IBOutlet weak var emailTextField   : UITextField!

    private var oldEmail: String!
    private var complitionHandler   : ((String) -> ())?
    lazy var tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureTap))
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emailTextField.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    class func loadFromXib(bundle : Bundle? = nil) -> EmailChangeView? {
        return UINib(
            nibName: String(describing: EmailChangeView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? EmailChangeView
    }
    
    func gestureTap() {
        emailTextField.resignFirstResponder()
        hideView()
    }
    
    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    private func bringToFront() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        if let windowView = UIApplication.shared.keyWindow {
            windowView.addSubview(self)
        }
        
        self.superview?.bringSubview(toFront: self)
    }
    
    //*****************************************************************
    // MARK: - Show/ Hide
    //*****************************************************************
    
    func show(email: String, action: ((String) -> ())?) {
        oldEmail = email
        emailTextField.text = email
        complitionHandler = action
        showViewAnimation()
    }
    
    private func showViewAnimation() {
        
        bringToFront()
        
        self.alpha = 0.0
        self.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: { () -> Void in
            self.alpha = 1.0
        }, completion: nil)
    }
    
    private func hideView() {
        
        UIView.animate(withDuration: 0.7, animations: { () -> Void in
            self.alpha = 0.0
        }, completion: { (Bool) -> Void in
            
            self.isHidden = true
            self.removeFromSuperview()
        })
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************

    @IBAction func okButtonPressed(_ sender: UIButton) {
        actionOK()
    }
    
    fileprivate func actionOK() {
        let result = String.unwrapCheck(emailTextField.text, FieldType.Email)
        if !result {
            emailTextField.resignFirstResponder()
            hideView()
            return
        }
        if oldEmail == emailTextField.text! {
            guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
                return
            }
            Alert.show(controller: vc, title: AlertTitle.TitleCommon, message: DefaultText.NothingChange , action: nil)
            return
        }
        emailTextField.resignFirstResponder()
        hideView()
        guard let action = complitionHandler else { return}
        action(emailTextField.text!)
    }
}

extension EmailChangeView: UITextFieldDelegate {
    
    //*****************************************************************
    // MARK: - UITextFieldDelegate
    //*****************************************************************
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isValidEmail()  {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {        
        actionOK()
        return true
    }
}

