//
//  GroupDetailTableViewCell.swift
//  DCL
//
//  Created by Nikita on 3/27/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class GroupDetailTableViewCell:  MGSwipeTableCell {
    
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var nameLabel        : UILabel!
    @IBOutlet weak var numberDreams     : UILabel!
    
    var currentItem: DetailGroupFriendItemModel!
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func setupData(_ item: DetailGroupFriendItemModel) {
        currentItem = item
        nameLabel.text = item.name ?? ""
        
        let number = item.goals.count
        if number == 0 {
            numberDreams.text = DefaultText.NoDreamsShared
        } else if number == 1 {
            numberDreams.text = "\(number) " + DefaultText.DreamsShared1
        } else {
            numberDreams.text = "\(number) " + DefaultText.DreamsShared
        }

        if let logo = item.photoUrl  {
            if !logo.isEmpty {
                profileImageView.kf.setImage(with:  URL(string: logo), placeholder: nil, options: [], progressBlock: nil, completionHandler: {[weak self] (image, error, cache, url) in
                    guard let this = self else {return}
                    DispatchQueue.main.async {
                        this.profileImageView.contentMode = UIViewContentMode.scaleAspectFit
                        this.profileImageView.makeRoundView()
                        this.profileImageView.layoutIfNeeded()
                    }
                })
            }
        } else {
            profileImageView.image = #imageLiteral(resourceName: "empty_placeholder_home")
        }
    }
}


