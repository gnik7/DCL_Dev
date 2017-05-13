//
//  PhotoViewerView.swift
//  DCL
//
//  Created by Nikita Gil on 17.04.17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import Kingfisher


class PhotoViewerView: UIView {
    
    @IBOutlet weak var fullImageView        : UIImageView!
    @IBOutlet weak var activityIndicator    : UIActivityIndicatorView!

    lazy var tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureTap))
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    class func loadFromXib(bundle : Bundle? = nil) -> PhotoViewerView? {
        return UINib(
            nibName: String(describing: PhotoViewerView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? PhotoViewerView
    }
    
    func gestureTap() {
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
    
    func show(_ url: String) {
        fullImageView.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        showViewAnimation()
        
        fullImageView.kf.setImage(with:  URL(string: url), placeholder: nil, options: [], progressBlock: nil, completionHandler: {[weak self] (image, error, cache, url) in
            
            guard let this = self else {return}
            this.activityIndicator.stopAnimating()
            this.activityIndicator.isHidden = true
            
            UIView.animate(withDuration: 0.5, animations: {
                this.fullImageView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        })
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
        hideView()
    }
    
  
}

