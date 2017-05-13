//
//  ViewModel.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//


import UIKit

class ViewModel {
    
    internal var operationAPI = APIOperationsClass()
    
    /// Handles events that happen within the view model
    weak var delegate: ViewModelDelegate? {
        didSet {
            delegate?.viewModelDidStartUpdate()
        }
    }
    
    init() {
        operationAPI.operationsDelegate = self as? APIOperationsClassDelegate
    }
}
