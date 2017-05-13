//
//  PushAlertView.swift
//  DCL
//
//  Created by Nikita on 3/29/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

enum PushAlertViewType {
    case Accept
    case Decline
    case Close
}

class PushAlertView: UIView {
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var complitionHandler   : ((_ type: PushAlertViewType) -> ())?
    var infoPush: PushInfo?
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    /**
     Get LoaderView from xib
     
     - parameter bundle: bundle for search. Default nil
     
     - returns: object PushAlertView
     */
    class func loadFromXib(bundle : Bundle? = nil) -> PushAlertView? {
        return UINib(
            nibName: String(describing: PushAlertView.self) ,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? PushAlertView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureView()
    }
    
    private func configureView() {
//        self.centerView.layer.cornerRadius = 10.0
//        self.centerView.clipsToBounds = true
    }
    
    func bringToFront() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        if let windowView = UIApplication.shared.keyWindow {
            windowView.addSubview(self)
        }
        
        self.superview?.bringSubview(toFront: self)
    }
    
    //*****************************************************************
    // MARK: - Show / Hide
    //*****************************************************************
    
    func showView(_ info: PushInfo, _ action: ((_ type: PushAlertViewType) -> ())?) {
        infoPush = info
        complitionHandler = action
        titleLabel.attributedText = convertData()
        
        self.configureView()
        
        self.alpha = 0.0
        self.superview?.bringSubview(toFront: self)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: { () -> Void in
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func hideView() {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.alpha = 0.0
        }, completion: { (Bool) -> Void in
            self.isHidden = true
            self.removeFromSuperview()
        })
    }
    
    //*****************************************************************
    // MARK: -  Data
    //*****************************************************************
    
    private func convertData() -> NSAttributedString {
        
        guard let name = infoPush?.name, let body = infoPush?.body else {
            return NSAttributedString()
        }
        
        let myAttribute1 = [ NSFontAttributeName: UIFont(name: "SFUIDisplay-Medium", size: 14) as Any,
                             NSForegroundColorAttributeName: DefaultGradient.inviteFriendsNameTextColor ]
        
        let myAttribute2 = [ NSFontAttributeName: UIFont(name: "SFUIDisplay-Regular", size: 14) as Any,
                             NSForegroundColorAttributeName: DefaultGradient.inviteFriendsNameTextColor ]
        
        let attributeString1 = NSMutableAttributedString(string: name, attributes: myAttribute1)
        let attributeString2 = NSMutableAttributedString(string: body.lowercased(), attributes: myAttribute2)
        let attributeString3 = NSMutableAttributedString(string: " ", attributes: myAttribute1)
        
        let attrStringAll = NSMutableAttributedString()
        attrStringAll.append(attributeString1)
        attrStringAll.append(attributeString3)
        attrStringAll.append(attributeString2)
        
        return attrStringAll
    }
    
    //*****************************************************************
    // MARK: -  Action
    //*****************************************************************
    
    @IBAction func declineButtonPressed(_ sender: UIButton) {
        guard let action = complitionHandler else { return }
        action(.Decline)
    }
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        guard let action = complitionHandler else { return }
        action(.Accept)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        guard let action = complitionHandler else { return }
        action(.Close)
    }
}
