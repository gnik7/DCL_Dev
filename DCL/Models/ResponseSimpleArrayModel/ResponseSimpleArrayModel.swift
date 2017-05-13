//
//  ResponseSimpleArrayModel.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//


import Foundation
import ObjectMapper
import Alamofire


class ResponseSimpleArrayModel:  Mappable {
    
    var errors = [ResultWrapper]()
    var paginate = PaginationModel()
    
    var status = ""
    var code = 0
    var message = ""
    var totalCount: Int?
    
    // Implementation of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        code        <- map["code"]
        errors      <- map["errors"]
        
        status      <- map["status"]
        message     <- map["message"]
        paginate    <- map["paginate"]
    }
}

class PaginationModel:  Mappable {
    
    var currentPage = 0
    var offset      = 0
    var pages       = 0
 
    
    // Implementation of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        currentPage     <- map["current_page"]
        offset          <- map["offset"]
        pages           <- map["pages"]
    }
}

