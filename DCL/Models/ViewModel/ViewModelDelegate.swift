//
//  ViewModelDelegate.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation


/**
 * Delegate for handling changes to a view model
 */

protocol ViewModelDelegate: class {
    /**
     * Tells the delegate that the view model has been updated
     */
    func viewModelDidStartUpdate()
    func viewModelDidEndUpdate()
    
}
