//
//  UICollectionView.swift
//  DCL
//
//  Created by Nikita on 2/27/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit


extension UICollectionViewCell {
    /// Search up the view hierarchy of the table view cell to find the containing table view
    var masterCollectionView: UICollectionView? {
        get {
            var collection: UIView? = superview
            while !(collection is UICollectionView) && collection != nil {
                collection = collection?.superview
            }
            
            return collection as? UICollectionView
        }
    }
}
