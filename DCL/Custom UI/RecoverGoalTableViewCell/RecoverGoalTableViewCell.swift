//
//  RecoverGoalTableViewCell.swift
//  DCL
//
//  Created by Nikita on 3/1/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit


class RecoverGoalTableViewCell:  UITableViewCell {
    
    @IBOutlet weak var checkedImageView : UIImageView!
    @IBOutlet weak var titleLabel       : UILabel! 
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = DefaultGradient.searchBarColor
        self.selectionStyle = .none
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func setupData(item :HomeIdeasModelItem){
        
        titleLabel.text = item.ideas ?? ""
        
        if item.stateCell == true {
            checkedImageView.image = #imageLiteral(resourceName: "check_profile")
            self.contentView.backgroundColor = UIColor.white
            titleLabel.textColor = DefaultGradient.selectedTextTabColor
        } else {
            checkedImageView.image = #imageLiteral(resourceName: "circle_profile")
            self.contentView.backgroundColor = DefaultGradient.searchBarColor
            titleLabel.textColor = DefaultGradient.checkListTextColor
        }
    }
}

