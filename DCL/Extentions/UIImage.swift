//
//  UIImage.swift
//  DCL
//
//  Created by Nikita on 2/28/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit



extension UIImage {
    
    func checkFileSizeImage() -> Bool {
        
        let maxSize = 24 * 1024 * 1024 // 24MB
        guard let lengthImage = UIImageJPEGRepresentation(self, qualityImage)?.count else {return false}
        
        if maxSize > lengthImage {
            return true
        }
        return false
    }
}
