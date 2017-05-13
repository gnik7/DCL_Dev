//
//  UIColor.swift
//  DCL
//
//  Created by Nikita on 1/27/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(withRGB red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha:CGFloat) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
}
