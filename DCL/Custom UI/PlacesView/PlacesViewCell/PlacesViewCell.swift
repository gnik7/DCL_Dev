//
//  PlacesViewCell.swift
//  DCL
//
//  Created by Nikita on 4/13/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

class PlacesViewCell:  UITableViewCell {
    
    @IBOutlet weak var placeLabel: UILabel!
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
        self.selectionStyle = .none
    }

    //*****************************************************************
    // MARK: - Data
    //*****************************************************************
    
    func setupData(item: NSAttributedString) {
        placeLabel.attributedText = item
    }
}

