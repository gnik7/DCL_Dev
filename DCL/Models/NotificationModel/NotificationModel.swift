//
//  NotificationModel.swift
//  DCL
//
//  Created by Nikita on 3/16/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import ObjectMapper

class NotificationModel: ResponseSimpleArrayModel, Meta {
    
    var items = [NotificationItemModel]()
    
    
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
            return API_Call.getURL(method: API_Call.user_notifications)
        }
    }
}

enum NotificationType: String {
    case FriendInvitation = "App\\Notifications\\FriendInvitationSent"
    case GoalInvitation = "App\\Notifications\\GoalInvitationSent"
}

class NotificationItemModel: ResponseSimpleModel {
    
    var id : String?
    private var typeApi : String?
    var type: NotificationType?
    var messageInvite: String?
    var isRead: Bool?
    var created = NotificationItemDateModel()
    var data: NotificationItemInvitationModell!
    var data1 = NotificationItemFriendInvitationModel()
    var data2 = NotificationItemGoalInvitationModel()
    
    required convenience init?(map: Map) {
        self.init()
        
        self.id             <- map["id"]
        self.messageInvite  <- map["message"]
        self.created        <- map["created"]
        self.isRead         <- map["is_read"]
        self.typeApi        <- map["type"]
        self.type = NotificationItemModel.converType(self.typeApi!)       
        
        if self.type == NotificationType.FriendInvitation {
            self.data1 <- map["data"]
            self.data = data1
        } else {
            self.data2 <- map["data"]
            self.data = data2
        }
    }
    
    class func converType(_ type: String) -> NotificationType {
        if type == NotificationType.FriendInvitation.rawValue {
            return NotificationType.FriendInvitation
        } else {
            return NotificationType.GoalInvitation
        }
    }
}

class NotificationItemDateModel: ResponseSimpleArrayModel {
    
    var date            : String?
    var timezoneType    : Int?
    var timezone        : String?
    
    required convenience init?(map: Map) {
        self.init()
        
        self.date           <- map["date"]
        self.timezoneType   <- map["timezone_type"]
        self.timezone       <- map["timezone"]
    }
}

protocol NotificationItemInvitationModell {
    
    var id : Int {get set}
    var userId : Int {get set}
    var name : String {get set}
    var photoUrl : String {get set}
}


class NotificationItemFriendInvitationModel: ResponseSimpleModel , NotificationItemInvitationModell {
    
    var id   = 0
    var userId = 0
    var name = ""
    var photoUrl = ""
    
    required convenience init?(map: Map) {
        self.init()
        
        self.id         <- map["id"]
        self.name       <- map["name"]
        self.photoUrl   <- map["photo_url"]
        self.userId     <- map["owner_id"]  // here null always
    }
}

class NotificationItemGoalInvitationModel: ResponseSimpleModel,NotificationItemInvitationModell {
    
    var id   = 0
    var userId = 0
    var name = ""
    var photoUrl = ""
    
    required convenience init?(map: Map) {
        self.init()
        
        self.id         <- map["id"]
        self.userId     <- map["owner_id"]   //TODO: need test
        self.name       <- map["owner_name"]
        self.photoUrl   <- map["owner_photo_url"]
    }
}


