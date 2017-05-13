//
//  PhotoChooseView.swift
//  DCL
//
//  Created by Nikita on 2/28/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

enum ArtActionType {
    case Photo
    case Gallery
    case Video
}

class PhotoChooseView: UIView {
    
    @IBOutlet weak var mainView         : UIView!
    @IBOutlet weak var cancelView       : UIView!
    @IBOutlet weak var layerAlertView   : UIView!
    @IBOutlet weak var headerView       : UIView!
    @IBOutlet weak var downView         : UIView!
    
    private let dimention = UIScreen.main.bounds.size.height * 0.6
    private var takePhotoComplitionHandler   : (() -> ())?
    private var chooseGalleryComplitionHandler   : (() -> ())?
    private var chooseVideoGalleryComplitionHandler   : (() -> ())?
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    class func loadFromXib(bundle : Bundle? = nil) -> PhotoChooseView? {
        return UINib(
            nibName: String(describing: PhotoChooseView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? PhotoChooseView
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
    
    func animationMoveDown() {
        UIView.animate(withDuration: 0.2, animations: {
           self.layerAlertView.transform = CGAffineTransform(translationX: 0, y: self.dimention)
        }, completion: nil)
    }
    
    func animationMoveUp() {
        UIView.animate(withDuration: 0.5, animations: {
            self.layerAlertView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }

    
    func show(takePhotoAction: (() -> ())?, chooseGalleryAction: (() -> ())?, chooseVideoAction: (() -> ())?) {
        
        takePhotoComplitionHandler = takePhotoAction
        chooseGalleryComplitionHandler = chooseGalleryAction
        chooseVideoGalleryComplitionHandler = chooseVideoAction
        
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
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        hideView()
    }
    
    @IBAction func takePhotoButtonPressed(_ sender: UIButton) {
        hideView()
        guard let action = takePhotoComplitionHandler else { return}
        action()
    }
    
    @IBAction func chooseFromGalleryButtonPressed(_ sender: UIButton) {
        hideView()
        guard let action = chooseGalleryComplitionHandler else { return}
        action()
    }
    
//    @IBAction func chooseVideoFromGalleryButtonPressed(_ sender: UIButton) {
//        hideView()
//        guard let action = chooseVideoGalleryComplitionHandler else { return}
//        action()
//    }
}

