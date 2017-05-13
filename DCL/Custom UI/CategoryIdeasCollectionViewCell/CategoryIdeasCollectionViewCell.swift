//
//  CategoryIdeasCollectionViewCell.swift
//  DCL
//
//  Created by Nikita on 3/30/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

class CategoryIdeasCollectionViewCell:  UICollectionViewCell {
    
    @IBOutlet weak var backView     : UIView!
    @IBOutlet weak var titleLabel   : UILabel!
    
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
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func updateData(_ currentCategoryItem: IdeaListItemModel, _ categoryItem:IdeaListItemModel) {
        
        titleLabel.text = categoryItem.title ?? ""
        
        if currentCategoryItem.id! == categoryItem.id! {
            backView.backgroundColor = DefaultGradient.selectedTabBarColor
            titleLabel.textColor = UIColor.white
        } else {
            backView.backgroundColor = DefaultGradient.searchBarColor
            titleLabel.textColor = DefaultGradient.deleteButtonBorderColor
        }
    }
}

