//
//  LoginNavigationView.swift
//  DCL
//
//  Created by Nikita on 1/30/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

protocol LoginNavigationViewDelegate: class {
    func backButtonWasPressed()
}

class LoginNavigationView: UIView {
    
    
    // var
    weak var delegate : LoginNavigationViewDelegate?
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    class func loadFromXib(bundle : Bundle? = nil) -> LoginNavigationView? {
        return UINib(
            nibName: String(describing: LoginNavigationView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? LoginNavigationView
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        guard let delegate = delegate  else {
            return
        }
        delegate.backButtonWasPressed()
    }

}

