//
//  MainIdeasTableViewCell.swift
//  DCL
//
//  Created by Nikita on 3/29/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit


class MainIdeasTableViewCell:  UITableViewCell {
    
    @IBOutlet weak var mainImageView     : UIImageView!
    @IBOutlet weak var titleLabel        : UILabel!
    @IBOutlet weak var ideasNumberLabel  : UILabel!
    
    private let cornerRadiusImage : CGFloat = 5.0
    
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
    
    func setupData(_ item: IdeaListItemModel) {
        
        titleLabel.text = item.title ?? ""
        let number = item.items ?? 0
        ideasNumberLabel.text = "\(number) ideas"
        
        if let logo = item.coverUrl  {
            if !logo.isEmpty {
                mainImageView.kf.setImage(with:  URL(string: logo), placeholder: nil, options: [], progressBlock: nil, completionHandler: {[weak self] (image, error, cache, url) in
                    guard let this = self else {return}
                    DispatchQueue.main.async {
                        this.mainImageView.contentMode = UIViewContentMode.scaleAspectFill
                        this.mainImageView.layer.cornerRadius = this.cornerRadiusImage
                    }
                })
            }
        } else {
            mainImageView.image = nil
        }
    }
}

