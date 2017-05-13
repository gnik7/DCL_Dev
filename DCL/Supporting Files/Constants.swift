//
//  Constants.swift
//  DCL
//
//  Created by Nikita on 1/27/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit

let baseHost = NSDictionary(dictionary: Bundle.main.infoDictionary!).object(forKey: "BaseUrl") as! String
let host = "https://\(baseHost)/api"

let gooleServiceKey = NSDictionary(dictionary: Bundle.main.infoDictionary!).object(forKey: "GMSServicesKey") as? String
let goolePlaceKey = NSDictionary(dictionary: Bundle.main.infoDictionary!).object(forKey: "GMSPlacesClientKey") as? String


let appFallSleepNotification = "AppFallSleepNotification"
let userNotFoundNotification = "UserNotFoundNotification"

enum DefaultGradient {
    //tabbar color
    static let selectedTabBarColor  = UIColor(withRGB: 255, 152, 0, 1.0)
    static let normalTabBarColor    = UIColor(withRGB: 156, 156, 156, 1.0)
    static let separatorTabBarColor = UIColor(withRGB: 156, 156, 156, 0.3)
    
    //home color
    static let searchBarColor = UIColor(withRGB: 245, 245, 245, 1.0)
    static let deleteCellColor = UIColor(withRGB: 233, 30, 99, 1.0)
    
    static let easyColor = UIColor(withRGB: 67, 160, 71, 1.0)
    static let mediumColor = UIColor(withRGB: 25, 118, 210, 1.0)
    static let hardColor = UIColor(withRGB: 233, 30, 99, 1.0)
    
    // sort view color
    static let activeSortLabelColor = UIColor(withRGB: 178, 178, 178, 1.0)
    static let noActiveSortLabelColor = UIColor(withRGB: 66, 66, 66, 1.0)
    
    //edit goal
    static let selectedTabColor = UIColor(withRGB: 245, 245, 245, 1.0)
    static let selectedTextTabColor = UIColor(withRGB: 255, 152, 0, 1.0)
    static let activeDeselectedTextTabColor = UIColor(withRGB: 177, 177, 177, 1.0)
    
    static let checkListTextColor = UIColor(withRGB: 200, 200, 200, 1.0)
    static let inviteFriendsTextColor = UIColor(withRGB: 127, 127, 127, 1.0)
    static let inviteFriendsNameTextColor = UIColor(withRGB: 66, 66, 66, 1.0)
    
    static let deleteButtonBorderColor    = UIColor(withRGB: 158, 158, 158, 1.0)
}

enum IdeaLevel: String {
    case Easy   = "Easy"
    case Medium = "Medium"
    case Hard   = "Hard"
    case None   = "None"
}

enum AlertTitle  {
    
    static let TitleCommon = "DCL"
    static let Error = "Error".localized()
}

enum AlertText {
    static let FieldIsEmpty = " field is empty".localized()
    static let NeedChooseHeaderPhoto = "First you need to choose header photo!".localized()
    static let ValidationChangePassword = "Fields are empty or not equal".localized()
    static let ForbidChangeFromFacebook = "Sorry, You can't change! You have logged from facebook".localized()
    static let InviteWasSent = "Invite has been sent successfully".localized()
    
}

enum DefaultText {
    static let apiConstParam = "additionalUrlPath"
    static let apiInnerConstParam = "innerAdditionalUrlPath"
    static let apiInnerConstParamSecond = "innerAdditionalUrlPathSecond"
    
    static let fieldsInvited = "Friends Invited:".localized()
    static let ideaDefaultText = "Start a new dream".localized()
    
    static let addChecklist = "Add Checklist".localized()
    static let writeReminders = "Write reminder".localized()
    static let tagLocation = "Tag Location".localized()

    static let inviteByEmailButton = ("Invite by email".localized()).uppercased()
    static let inviteToGroupButton = ("Invite to group".localized()).uppercased()
    static let inviteToDreamButton = ("INVITE TO DREAM".localized()).uppercased()
    
    
    static let toBigFile = "To big file".localized()
    
    
    static let NoDreamsShared = "No dreams shared".localized()
    static let DreamsShared = "dreams shared".localized()
    static let DreamsShared1 = "dream shared".localized()
    static let StartNewDream = "Start a new dream".localized()
    
    static let MotivationTitle = "MOTIVATION".localized()
    static let MotivationMessage = "If you fall asleep now, you will dream. If you study now, you will live your dream.".localized()
    static let MotivationButton = "THANK YOU".localized()
    
    static let RestoreGoalTitle = "COMPLETE".localized()
    static let RestoreGoalMessage = "Selected goals were successfully restored".localized()
    static let RestoreGoalButton = "OK".localized()
    static let RegistrFieldEmpty = "Some field is empty".localized()
    static let PasswordRetypeNotEqual = "Password and retype password are not equel".localized()
    static let ConvertYourDreams = "Convert your dreams".localized()
    static let IntoRealLife = "into real-life achievements".localized()
    static let NothingChange = "Nothing to change".localized()
    static let CheckListLimit = "Please use the Reminder field for more text.".localized()
    static let ServerError = "Server error".localized()
   
}

let qualityImage: CGFloat = 0.7
