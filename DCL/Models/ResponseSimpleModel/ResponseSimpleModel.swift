//
//  ResponseSimpleModel.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper


class ResultWrapper: Mappable {
    
    var field: String?
    var message = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        field   <- map["field"]
        message <- map["message"]
    }
}

class ResponseSimpleModel: Mappable {
    
    var errors = [ResultWrapper]()
    var code = 0
    var message = ""
    
    // Implementation of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        code    <- map["code"]
        errors  <- map["errors"]
        message <- map["message"]
    }
}




