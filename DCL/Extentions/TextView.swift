//
//  TextField.swift
//  DCL
//
//  Created by Nikita on 2/14/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit


extension UITextView {

    //*****************************************************************
    // MARK: - Count rows
    //*****************************************************************
    
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
    
    //*****************************************************************
    // MARK: - Resize  height
    //*****************************************************************
    
    func requiredHeight() -> CGFloat{
        
        let textView:UITextView = UITextView(frame: CGRect(origin: CGPoint.zero , size: CGSize(width: self.frame.size.width, height: CGFloat(MAXFLOAT))))
        textView.sizeToFit()
        textView.layoutIfNeeded()
        let height = textView.sizeThatFits(CGSize(width:self.frame.size.width, height:CGFloat(MAXFLOAT))).height
        
        return height 
    }
}

