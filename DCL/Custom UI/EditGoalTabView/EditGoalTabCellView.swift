//
//  EditGoalTabView.swift
//  DCL
//
//  Created by Nikita on 2/15/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

protocol EditGoalTabCellViewDelegate: class{
    func cellDidPressed(type: GoalTabCellType)
}

class EditGoalTabCellView: UIView {
    
    @IBOutlet weak var layerView            : UIView!
    @IBOutlet weak var mainImage            : UIImageView!
    @IBOutlet weak var titleLabel           : UILabel!
    @IBOutlet weak var rightSeparatorView   : UIView!
    
    
    @IBOutlet weak var layerViewLeftOffset      : NSLayoutConstraint!
    @IBOutlet weak var layerViewRightOffset     : NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint     : NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint    : NSLayoutConstraint!
    
    weak var delegate   : EditGoalTabCellViewDelegate?
    
    var currentItem : EditGoalTabCellViewItemModel!
    let margin: CGFloat = 2.0
    let layerCornerRadius: CGFloat = 5.0
    
    
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
        
        if currentItem.state == true {
            addCornerRadius(layerView)
        }
    }
    
    class func loadFromXib(bundle : Bundle? = nil) -> EditGoalTabCellView? {
        return UINib(
            nibName: String(describing: EditGoalTabCellView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? EditGoalTabCellView
    }
    
    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    fileprivate func updateUIToType(){
        
        layerView.backgroundColor = currentItem.colorLayer
        rightSeparatorView.isHidden = !currentItem.isShowSeparator
        mainImage.image = currentItem.image
        titleLabel.text = currentItem.content.text
        titleLabel.textColor = currentItem.textColor
        imageWidthConstraint.constant = currentItem.content.width
        imageHeightConstraint.constant = currentItem.content.height
        
        if currentItem.state == true {
            addCornerRadius(layerView)
            layerView.setNeedsLayout()
            layerView.layoutIfNeeded()
            
            if currentItem.type == .Notes {
                layerViewLeftOffset.constant = margin
            } else if currentItem.type == .Memorize {
                layerViewRightOffset.constant = margin
            }
        }
    }
    
    private func addCornerRadius(_ thisView: UIView){
        let path = UIBezierPath(roundedRect:thisView.bounds,
                                byRoundingCorners:[.topLeft, .topRight],
                                cornerRadii: CGSize(width: layerCornerRadius, height: layerCornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        thisView.layer.mask = maskLayer
    }
    
    //*****************************************************************
    // MARK: - Show/ Hide
    //*****************************************************************
    
    func show() {
        updateUIToType()
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func cellPressed(_ sender: UIButton) {
        guard let delegate = delegate else { return}
        delegate.cellDidPressed(type: currentItem.type)
        updateUIToType()
    }
}
