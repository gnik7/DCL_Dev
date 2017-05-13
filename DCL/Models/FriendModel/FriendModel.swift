//
//  FriendModel.swift
//  DCL
//
//  Created by Nikita on 3/7/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class AllUsersListModel: ResponseSimpleArrayModel, Meta {
    
    var items = [FriendItemModel]()
    
    required convenience init?(map: Map) {
        self.init()
        
        items   <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.list_all_users)
        }
    }
    
    class func convertToAlphabetic(items: [FriendItemModel]) -> [FriendItemModel] {
        for i in 0..<items.count {
            if i == 0 {
                items[i].isAlphabeticFirst = true
            }
            
            if i + 1 < items.count {
                guard let letter1 = items[i].name?.characters.first,
                      let letter2 = items[i + 1].name?.characters.first
                else {
                    return items
                }
                let str1 = String(describing: letter1).lowercased()
                let str2 = String(describing: letter2).lowercased()
                
                if str1 == str2 && items[i].isAlphabeticFirst == true {
                    items[i + 1].isAlphabeticFirst = false
                } else if str1 == str2 && items[i].isAlphabeticFirst == false {
                    items[i + 1].isAlphabeticFirst = false
                } else if str1 != str2 {
                    items[i + 1].isAlphabeticFirst = true
                }
            }
        }
        return items
    }
}

class FriendItemModel: ResponseSimpleArrayModel {
    
    var id          : Int?
    var name        : String?
    var email       : String?
    var isFriend    : Bool?
    var isInvited   : Bool?
    var photoUrl    : String?
    var facebook    : Bool?
    var isSelected          = false
    var isAlphabeticFirst   = false
    
    required convenience init?(map: Map) {
        self.init()
        
        id         <- map["id"]
        name       <- map["name"]
        email      <- map["email"]
        isFriend   <- map["is_friend"]
        isInvited  <- map["is_invited"]
        photoUrl   <- map["photo_url"]
        facebook   <- map["facebook"]
    }
}

class AllFriendListModel: ResponseSimpleArrayModel, Meta {
    
    var items = [FriendItemModel]()
    
    required convenience init?(map: Map) {
        self.init()
        
        items   <- map["result"]
    }
    
    //*****************************************************************
    // MARK: -  Implementation of Meta protocol
    //*****************************************************************
    
    static func url_get(method: String) -> String {
        
        switch method {
        default:// GET
            return API_Call.getURL(method: API_Call.list_friends_user)
        }
    }
    
}

