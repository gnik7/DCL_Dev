//
//  PurchaseViewCollectionCell.swift
//  DCL
//
//  Created by Nikita on 2/23/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import Kingfisher

class PurchaseViewCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var rightOffsetConstraint    : NSLayoutConstraint!
    @IBOutlet weak var leftOffsetConstraint     : NSLayoutConstraint!
    
    private let defaultSpace: CGFloat = 0.5
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()        
    }

    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    func updateData(indexPath: IndexPath, item: StoresListItemModel){
        if indexPath.row % 2 == 0 {
            rightOffsetConstraint.constant = defaultSpace
        } else {
            leftOffsetConstraint.constant = defaultSpace
        }
        if let logo = item.logoUrl  {
            if !logo.isEmpty {
                mainImageView.kf.setImage(with:  URL(string: logo), placeholder: nil, options: [], progressBlock: nil, completionHandler: { (image, error, cache, url) in
                    
                    self.mainImageView.contentMode = UIViewContentMode.scaleAspectFit
                })
            }
        }
    }
}


