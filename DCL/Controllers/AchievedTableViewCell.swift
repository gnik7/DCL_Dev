//
//  AchievedTableViewCell.swift
//  DCL
//
//  Created by Nikita on 16.03.17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

class AchievedTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var sectedImageView: UIImageView!
    var isMultiSelectedType: Bool = false

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        mainView.layer.borderColor = DefaultGradient.selectedTextTabColor.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if isMultiSelectedType {
            sectedImageView.isHidden = !isSelected
            if isSelected {
                mainView.layer.borderWidth = 3
            } else {
                mainView.layer.borderWidth = 0
            }
        }
    }
    

}
