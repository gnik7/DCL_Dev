//
//  InviteFriendsTableViewCell.swift
//  DCL
//
//  Created by Nikita on 3/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit


class InviteFriendsTableViewCell:  UITableViewCell {
    
    @IBOutlet weak var checkedImageView : UIImageView!
    @IBOutlet weak var personeImageView : UIImageView!    
    @IBOutlet weak var titleLabel       : UILabel!
    @IBOutlet weak var alphibyteLabel   : UILabel!
    
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        personeImageView.makeRoundView()
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func setupData(_ item :FriendItemModel){
        
        titleLabel.text = item.name ?? ""
        guard let letter = (item.name)?.characters.first  else { return}
        
        alphibyteLabel.text =  String(describing: letter)
        if item.isAlphabeticFirst {
            alphibyteLabel.isHidden = false
        } else {
            alphibyteLabel.isHidden = true
        }
        
        if item.isFriend == true {
            self.contentView.backgroundColor = UIColor.white
            titleLabel.textColor = DefaultGradient.selectedTextTabColor
        } else {
            if item.isInvited == true {
                titleLabel.textColor = DefaultGradient.activeDeselectedTextTabColor
            } else {
                titleLabel.textColor = DefaultGradient.inviteFriendsNameTextColor
            }
            self.contentView.backgroundColor = DefaultGradient.searchBarColor
        }
        
        if item.isSelected == true {
            checkedImageView.isHidden = false
        } else {
            checkedImageView.isHidden = true
        }
        
        if let logo = item.photoUrl  {
            if !logo.isEmpty {
                personeImageView.kf.setImage(with:  URL(string: logo), placeholder: nil, options: [], progressBlock: nil, completionHandler: {[weak self] (image, error, cache, url) in
                    guard let this = self else {return}
                    DispatchQueue.main.async {
                        this.personeImageView.contentMode = UIViewContentMode.scaleAspectFit
                        this.personeImageView.makeRoundView()
                        this.personeImageView.layoutIfNeeded()
                    }                    
                })
            }
        } else {
            personeImageView.image = #imageLiteral(resourceName: "empty_placeholder_home")
        }
    }
}

