//
//  HomeTableViewCell.swift
//  DCL
//
//  Created by Nikita on 2/13/17.
//  Copyright © 2017 Nikita. All rights reserved.
//


import UIKit
import MGSwipeTableCell

class HomeTableViewCell:  MGSwipeTableCell {
    
    @IBOutlet weak var ideaLabel    : UILabel!
    @IBOutlet weak var mainView     : UIView!   
    
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
        ideaLabel.text = (item.ideas != nil) ? item.ideas : ""
        
        
        if item.ideasLevel == .Easy {
            ideaLabel.textColor = DefaultGradient.easyColor
        } else if item.ideasLevel == .Medium {
            ideaLabel.textColor = DefaultGradient.mediumColor
        } else if item.ideasLevel == .Hard {
            ideaLabel.textColor = DefaultGradient.hardColor
        }
    }
}
