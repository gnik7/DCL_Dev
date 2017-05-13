//
//  SortView.swift
//  DCL
//
//  Created by Nikita on 2/14/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

enum SortViewType: String {
    case SortAlphabetically = "alphabetically"
    case SortByCreationDate = "created"
    case SortOnDateToAchieve = "achieved"
    case SortByColor = "color"
}

class SortView: UIView {
    
    @IBOutlet weak var alphabeticallyLabel  : UILabel!
    @IBOutlet weak var creationDateLabel    : UILabel!
    @IBOutlet weak var dateArchieveLabel    : UILabel!
    @IBOutlet weak var colorLabel           : UILabel!
    
    @IBOutlet var labels                    : [UILabel]!
  
    private var buttonPressed = false
    var complitionHandler   : ((SortViewType) -> ())?
    var currentType         : SortViewType!
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    class func loadFromXib(bundle : Bundle? = nil) -> SortView? {
        return UINib(
            nibName: String(describing: SortView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? SortView
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
    
    private func updateLabelToType(){
        
        for label in labels {
            label.textColor = DefaultGradient.noActiveSortLabelColor
        }
        
        guard let type = currentType else {
            return
        }
        
        switch type {
            case .SortAlphabetically    : alphabeticallyLabel.textColor = DefaultGradient.activeSortLabelColor
            case .SortByCreationDate    : creationDateLabel.textColor = DefaultGradient.activeSortLabelColor
            case .SortOnDateToAchieve   : dateArchieveLabel.textColor = DefaultGradient.activeSortLabelColor
            case .SortByColor           : colorLabel.textColor = DefaultGradient.activeSortLabelColor
        //default: break
        }
    }
    
    //*****************************************************************
    // MARK: - Show/ Hide
    //*****************************************************************
    
    func show(_ type: SortViewType, action: ((SortViewType) -> ())?) {
        complitionHandler = action
        currentType = type
        
        showViewAnimation()
        updateLabelToType()
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
    
    @IBAction func sortAlphabeticallyButtonPressed(_ sender: UIButton) {
        
        if !buttonPressed {
            buttonPressed = true
            updateResult(.SortAlphabetically)
        }
    }
    
    @IBAction func sortByCreationDateButtonPressed(_ sender: UIButton) {
        if !buttonPressed {
            buttonPressed = true
            updateResult(.SortByCreationDate)
        }
    }
    
    @IBAction func sortOnDateToAchieveButtonPressed(_ sender: UIButton) {
        if !buttonPressed {
            buttonPressed = true
            updateResult(.SortOnDateToAchieve)
        }
    }
    
    @IBAction func sortByColorButtonPressed(_ sender: UIButton) {
        if !buttonPressed {
            buttonPressed = true
            updateResult(.SortByColor)
        }
    }
    
    private func updateResult(_ type: SortViewType) {
        currentType = type
        updateLabelToType()
        hideView()
        if let action = complitionHandler {
            action(currentType)
        }
    }
}


