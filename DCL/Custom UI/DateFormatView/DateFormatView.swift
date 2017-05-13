//
//  DateFormatView.swift
//  DCL
//
//  Created by Nikita on 3/23/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

class DateFormatView: UIView {
  
    @IBOutlet weak var americanDateImageView    : UIImageView!
    @IBOutlet weak var europeDateImageView      : UIImageView!
    @IBOutlet weak var americanDateLabel        : UILabel!
    @IBOutlet weak var europeDateLabel          : UILabel!
    
    var complitionHandler: (()-> ())?
    
    private var state: Bool! {
        didSet{
            if state == true {
                americanDateImageView.image = #imageLiteral(resourceName: "check_profile")
                europeDateImageView.image = #imageLiteral(resourceName: "circle_profile")
            } else {
                americanDateImageView.image = #imageLiteral(resourceName: "circle_profile")
                europeDateImageView.image = #imageLiteral(resourceName: "check_profile")
            }
        }
    }
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func loadFromXib(bundle : Bundle? = nil) -> DateFormatView? {
        return UINib(
            nibName: String(describing: DateFormatView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? DateFormatView
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
    
    func show(action: @escaping ()-> ()) {
        complitionHandler = action
        americanDateLabel.text = Date.todayToString()
        europeDateLabel.text = Date.todayEuropeToString()
        
        self.state = UserDefaultsManager.updateInfoDateFormat()
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
    // MARK: - Buttons
    //*****************************************************************
    
    private func changeStateButtons(_ currentImage: UIImageView, _ flag: Bool)  {
      
    }

    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        hideView()
    }
    
    @IBAction func okButtonPressed(_ sender: UIBarButtonItem) {
        UserDefaultsManager.saveInfoDateFormat(state)
        guard let handler = complitionHandler else { return}
        handler()
        hideView()
    }
    
    @IBAction func americanDateButtonPressed(_ sender: UIButton) {
        // true - American false - Europe
        state = true
    }
    
    @IBAction func europeDateButtonPressed(_ sender: UIButton) {
        state = false
    }
}

