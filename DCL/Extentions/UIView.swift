//
//  UIView.swift
//  DCL
//
//  Created by Nikita on 1/30/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

extension UIView {
    
    //*****************************************************************
    // MARK: - Corner Radius
    //*****************************************************************
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    //*****************************************************************
    // MARK: - Convert from class to string and Nib - for Cells
    //*****************************************************************
    
    class func classNibFromString(className :AnyClass) -> UINib? {
        
        let classNameString = String(describing: className.self)
        let nibObject = UINib(nibName: classNameString, bundle:nil)
        
        return nibObject
    }
    
    //*****************************************************************
    // MARK: - Rounds View
    //*****************************************************************
    
    func makeRoundView() {
        let rect = self.frame
        self.layer.cornerRadius = rect.size.height / 2
    }
    
    func makeTopCornerRadius()  {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: ViewConstant.kConerRadius, height: ViewConstant.kConerRadius)).cgPath
        self.layer.mask = rectShape
    }
    
    func makeBottomCornerRadius()  {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: ViewConstant.kConerRadius, height: ViewConstant.kConerRadius)).cgPath
        self.layer.mask = rectShape
    }
    
    func removeTopCornerRadius()  {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 0, height: 0)).cgPath
        self.layer.mask = rectShape
    }
    
    //*****************************************************************
    // MARK: - Make Border to  View
    //*****************************************************************
    
    func makeBorderView(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}


struct ViewConstant {
    static let kConerRadius : CGFloat = 5.0
}
