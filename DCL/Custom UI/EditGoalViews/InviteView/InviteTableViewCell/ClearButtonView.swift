//
//  ClearButtonView.swift
//  DCL
//
//  Created by Nikita on 2/17/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ClearButtonView {
    
    static let defaultBtnWidht: CGFloat = 47
    
    //MARK: - Initialization -
    
    static public func clearButton() -> MGSwipeButton {
        let clearButton = MGSwipeButton(title: "", backgroundColor: UIColor.clear)
        clearButton.buttonWidth = ClearButtonView.defaultBtnWidht
        return clearButton
    }
    
    static public func swipeButton(color: UIColor,title: String, icon: UIImage?, widht: CGFloat = ClearButtonView.defaultBtnWidht, height: CGFloat) -> MGSwipeButton {
        var button = MGSwipeButton(title: "", backgroundColor: UIColor.clear)
        button = updateUI(button: button, title: title, icon: icon, widht: widht, color: color, height: height)
        return button
    }
    
    static func updateUI(button: MGSwipeButton,title: String, icon: UIImage?, widht: CGFloat, color: UIColor, height: CGFloat) -> MGSwipeButton {
        button.buttonWidth = widht
        let frontButton = UIButton(type: .custom)
        frontButton.frame = CGRect(x: 0, y: 0, width: widht, height: height )
        
        frontButton.backgroundColor = DefaultGradient.hardColor
        frontButton.isUserInteractionEnabled = false
        button.addSubview(frontButton)
        
        //add image trash add set size and constraint
        let image = UIImageView(image: #imageLiteral(resourceName: "delete_cell_home"))
        image.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(image)
        
        let horizontalConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.rightMargin, relatedBy: NSLayoutRelation.equal, toItem: button, attribute: NSLayoutAttribute.rightMargin, multiplier: 1, constant: -13)
        let verticalConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: button, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 16)
        let heightConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20)
        
        button.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        return button
    }
}
