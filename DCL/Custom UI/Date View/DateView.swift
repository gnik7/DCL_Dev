//
//  DateView.swift
//  DCL
//
//  Created by Nikita on 2/16/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

class DateView: UIView {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var complitionHandler   : ((String, String) -> ())?
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    class func loadFromXib(bundle : Bundle? = nil) -> DateView? {
        return UINib(
            nibName: String(describing: DateView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? DateView
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
    
    func show(_  action: ((String, String) -> ())?) {
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
    // MARK: - Time
    //*****************************************************************
    
    private func createTime() -> String {
        let time = datePicker.date
        return time.dateToString()
    }
    
    private func createTimeForServer() -> String {
        let time = datePicker.date
        return time.dateForServerToString()
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        hideView()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        hideView()
        let time = createTime()
        let serverTime = createTimeForServer()
        guard let action = complitionHandler else { return}
        action(time, serverTime)
    }
}

