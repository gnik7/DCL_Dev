//
//  CategoryIdeasTableViewCell.swift
//  DCL
//
//  Created by Nikita on 3/29/17.
//  Copyright © 2017 Nikita. All rights reserved.
//


import UIKit

protocol CategoryIdeasTableViewCellDelegate: class {
    func addCategory(_ title: String, _ cover: UIImage)
}

class CategoryIdeasTableViewCell:  UITableViewCell {
    
    @IBOutlet weak var mainImageView    : UIImageView!
    @IBOutlet weak var titleLabel       : UILabel!
    @IBOutlet weak var lowView          : UIView!
    
    weak var delegate: CategoryIdeasTableViewCellDelegate?
    private var title: String?
    
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
        lowView.makeBottomCornerRadius()
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func setupData(_ item: CategoryIdeaListItemModel) {
        
        titleLabel.text = item.title ?? ""
        title = item.title
        
        if let logo = item.coverUrl  {
            if !logo.isEmpty {
                mainImageView.kf.setImage(with:  URL(string: logo), placeholder: nil, options: [], progressBlock: nil, completionHandler: {[weak self] (image, error, cache, url) in
                    guard let this = self else {return}
                    DispatchQueue.main.async {
                        this.mainImageView.contentMode = UIViewContentMode.scaleAspectFill
                        this.mainImageView.makeTopCornerRadius()
                    }
                })
            }
        } else {
            mainImageView.image = nil
        }
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        guard  let delegate = delegate,
               let selectedTitle = title,
               let image = mainImageView.image  else { return}
        delegate.addCategory(selectedTitle, image)
    }
}
