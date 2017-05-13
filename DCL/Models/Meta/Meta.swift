//
//  Meta.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation

@objc protocol Meta {
    
    @objc optional static func url_get(method:String)->String
}
