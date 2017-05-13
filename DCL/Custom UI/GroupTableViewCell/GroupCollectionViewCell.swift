//
//  GroupCollectionViewCell.swift
//  DCL
//
//  Created by Nikita on 3/20/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import Kingfisher

class GroupCollectionViewCell:  UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.makeRoundView()
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func updateData(item: FriendItemModel) {
        
        if let photo = item.photoUrl {
            if !photo.isEmpty {
                let url = URL(string: photo)
                profileImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "profile_profile") , options: nil, progressBlock: nil, completionHandler: {[weak self](image, erro, cache, url) in
                    guard let this = self else {return}
                    DispatchQueue.main.async {
                        this.profileImageView.makeRoundView()
                        this.profileImageView.layoutIfNeeded()
                        this.profileImageView.setNeedsLayout()
                    }
                })
            } else {
                profileImageView.image = #imageLiteral(resourceName: "profile_profile")
            }
        } else {
            profileImageView.image = #imageLiteral(resourceName: "profile_profile")
        }
    }    
}
