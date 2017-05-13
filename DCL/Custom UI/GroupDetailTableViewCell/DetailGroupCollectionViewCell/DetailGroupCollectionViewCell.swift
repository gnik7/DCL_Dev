//
//  DetailGroupCollectionViewCell.swift
//  DCL
//
//  Created by Nikita on 3/27/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import Kingfisher

class DetailGroupCollectionViewCell:  UICollectionViewCell {
    
    @IBOutlet weak var mainImageView    : UIImageView!
    @IBOutlet weak var titleGoalLabel   : UILabel!
    @IBOutlet weak var locationLabel    : UILabel!
    
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
        mainImageView.makeTopCornerRadius()
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func updateData(item: DetailGroupGoalItemModel) {
        
        if let photo = item.goalCover.urlPhoto {
            if !photo.isEmpty {
                let url = URL(string: photo)
                mainImageView.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: {[weak self](image, erro, cache, url) in
                    guard let this = self else {return}
                    DispatchQueue.main.async {
                        this.mainImageView.makeTopCornerRadius()
                        this.mainImageView.contentMode = UIViewContentMode.scaleAspectFill
                        this.mainImageView.layoutIfNeeded()
                    }
                })
            } else {
                mainImageView.image = nil
            }
        } else {
            mainImageView.image = nil
        }
        
        titleGoalLabel.text = item.title ?? ""
        
        if item.goalType == .Easy {
            titleGoalLabel.textColor = DefaultGradient.easyColor
        } else if item.goalType == .Medium {
            titleGoalLabel.textColor = DefaultGradient.mediumColor
        } else if item.goalType == .Hard {
            titleGoalLabel.textColor = DefaultGradient.hardColor
        }
        
        locationLabel.text = item.location ?? ""
    }
}

