//
//  AchieveAndCelebrateView.swift
//  DCL
//
//  Created by Nikita on 3/15/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

class AchieveAndCelebrateView: UIView {
    
    @IBOutlet weak var doneButton   : UIButton!
    @IBOutlet weak var imageView    : UIImageView!
    
    private var complitionHandler   : (() -> ())?
    lazy var tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureTap))
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.addGestureRecognizer(tapGesture)
        imageView.prepareForAnimation(withGIFNamed: "giphy")
//        self.bringSubview(toFront: imageView)
//        doneButton.isHidden = false
//        doneButton.isEnabled = true
        self.bringSubview(toFront: (self.doneButton))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    class func loadFromXib(bundle : Bundle? = nil) -> AchieveAndCelebrateView? {
        return UINib(
            nibName: String(describing: AchieveAndCelebrateView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? AchieveAndCelebrateView
    }
    
    func gestureTap() {
        
//        UIView.animate(withDuration: 0.5, animations: {
//            self.imageView.alpha = 0.0
//        }, completion: { (fin) in
//            self.imageView.stopAnimatingGIF()
//            self.imageView.image = #imageLiteral(resourceName: "well_done_archive")
//            self.removeGestureRecognizer(self.tapGesture)
//            UIView.animate(withDuration: 0.5, animations: {
//                self.imageView.alpha = 1.0
//            }, completion: { (fin) in
//                
//                self.doneButton.isHidden = false
//                self.doneButton.isEnabled = true
//                self.bringSubview(toFront: (self.doneButton))
//            })
//        })
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
    
    func show( action: (() -> ())?) {
        complitionHandler = action
        showViewAnimation()
        imageView.startAnimatingGIF()
        self.bringSubview(toFront: (self.doneButton))
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
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        actionOK()
    }
    
    fileprivate func actionOK() {
        
        hideView()
        guard let action = complitionHandler else { return}
        action()
    }
}

