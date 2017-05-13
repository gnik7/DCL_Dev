//
//  InviteTableViewCell.swift
//  DCL
//
//  Created by Nikita on 2/17/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class InviteTableViewCell:  MGSwipeTableCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
   
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.makeRoundView()
    }    
    
    //*****************************************************************
    // MARK: - Data
    //*****************************************************************
    
    func setupData(item: FriendItemModel) {
        nameLabel.text = item.name ?? ""
        
        if let logo = item.photoUrl  {
            if !logo.isEmpty {
                profileImage.kf.setImage(with:  URL(string: logo), placeholder: nil, options: [], progressBlock: nil, completionHandler: {[weak self] (image, error, cache, url) in
                    guard let this = self else {return}
                    DispatchQueue.main.async {
                        this.profileImage.contentMode = UIViewContentMode.scaleAspectFit
                        this.profileImage.makeRoundView()
                        this.profileImage.layoutIfNeeded()
                    }
                })
            } else {
                profileImage.image = #imageLiteral(resourceName: "profile_profile")
            }
        } else {
            profileImage.image = #imageLiteral(resourceName: "profile_profile")
        }
    }
}
