//
//  CellButtonView.swift
//  DCL
//
//  Created by Nikita on 2/13/17.
//  Copyright © 2017 Nikita. All rights reserved.
//


import UIKit
import MGSwipeTableCell


let defaultButtonWidht: CGFloat = 64
let defaultClearButtonWidht: CGFloat = 7
let cornerRadiusImage: CGFloat = 5

class CellButtonView {
    
    //MARK: - Initialization -
    
    static public func clearButton() -> MGSwipeButton {
        let clearButton = MGSwipeButton(title: "", backgroundColor: UIColor.clear)
        clearButton.buttonWidth = defaultClearButtonWidht
        return clearButton
    }
    
    static public func swipeButton(color: UIColor,title: String, icon: UIImage?, widht: CGFloat = defaultButtonWidht, height: CGFloat) -> MGSwipeButton {
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
    
        // add border white view
        let whiteView = UIView()
        whiteView.frame = CGRect(x: 0, y: 0, width: 7, height: height)
        whiteView.backgroundColor = UIColor.white
        let path = UIBezierPath(roundedRect:whiteView.bounds,
                                byRoundingCorners:[.topRight, .bottomRight],
                                cornerRadii: CGSize(width: cornerRadiusImage, height:  cornerRadiusImage))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        whiteView.layer.mask = maskLayer
        button.addSubview(whiteView)
      
        
        return button
    }
}
