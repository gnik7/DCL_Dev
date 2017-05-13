//
//  LoaderView.swift
//  DCL
//
//  Created by Nikita on 2/10/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoaderView: UIView {

    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    /**
     Get LoaderView from xib
     
     - parameter bundle: bundle for search. Default nil
     
     - returns: object LoaderView
     */
    class func loadFromXib(bundle : Bundle? = nil) -> LoaderView? {
        return UINib(
            nibName: "LoaderView",
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? LoaderView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureView()
    }
    
    func configureView() {
        self.centerView.layer.cornerRadius = 10.0
        self.centerView.clipsToBounds = true       
    }
    
    func loadView() {
        if let windowView = UIApplication.shared.keyWindow {
            windowView.addSubview(self)
        }
    }
    
    func bringToFront() {
        let sizeFrame: CGFloat = 100.0
        let frameX = UIScreen.main.bounds.width / 2.0 - sizeFrame / 2.0
        let frameY = UIScreen.main.bounds.height / 2.0 - sizeFrame / 2.0
        
        self.frame = CGRect(x: frameX, y: frameY, width: sizeFrame, height: sizeFrame)
        
        self.superview?.bringSubview(toFront: self)
    }
    
    //*****************************************************************
    // MARK: - Show / Hide loader
    //*****************************************************************
    
    func showView() {
        loadView()
        self.bringToFront()
        self.configureView()
        
        activityIndicatorView.startAnimating()
        
        self.alpha = 0.0
        self.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: { () -> Void in
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func hideView() {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.alpha = 0.0
        }, completion: { (Bool) -> Void in
            self.isHidden = true
        })
    }
}
