//
//  PushManager.swift
//  DCL
//
//  Created by Nikita on 3/28/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class PushManager {
    
    static let sharedInstance = PushManager()
    
    var viewModel = PushManagerViewModel()
    
    init() {
        self.viewModel.delegate = self
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], window: UIWindow?) {

        print(userInfo)
        if application.applicationState == UIApplicationState.active {
            print("Push in Active State")
            let info = convertPushInfo(userInfo: userInfo)
            PushAlertManager.sharedInstance.showView(info, { [weak self] (type) in
                print(type)
                guard let this = self else {return}
                this.sendAction(info, type)
                PushAlertManager.sharedInstance.hideView()
            })


        } else {
            print("Push in Background State")

            guard let window = window else {return}
            let router = Router(navigationController: window.rootViewController as! UINavigationController)
            router.showNotificationsViewController(window)
        }
    }
    
    @available(iOS 10.0, *)
    func application(_ state: Bool, window: UIWindow?, _ content: UNNotificationContent) {
        
        print(content.body)
        print(content.attachments)
        print(content.userInfo)
        if state {
            print("Push in Active State")
            let info = convertPushInfo(userInfo: content.userInfo)
            PushAlertManager.sharedInstance.showView(info, {[weak self] (type) in
                print(type)
                guard let this = self else {return}
                this.sendAction(info, type)
                PushAlertManager.sharedInstance.hideView()
            })
 
        } else {
            print("Push in Background State")

            guard let window = window else {return}
            let router = Router(navigationController: window.rootViewController as! UINavigationController)
            router.showNotificationsViewController(window)
        }
    }
    
    func convertPushInfo(userInfo: [AnyHashable : Any]) -> PushInfo {
        let info = PushInfo()
        if let aps = userInfo["aps"] as! [String: AnyObject]? {
            if let alert = aps["alert"] as? NSDictionary {
                if let body = alert["body"] as? String {
                    info.body = body
                }
                if let title = alert["title"] as? String {
                    info.title = PushInfo.stringToPushType(text: title)
                }
            }
        }
        
        if info.title == PushType.FriendInvite {
            if let data = userInfo["data"] as! [String: AnyObject]? {
                if let userId = data["id"] as? Int {
                    info.userId = userId
                }
                if let name = data["name"] as? String {
                    info.name = name
                }
                if let photoUrl = data["photo_url"] as? String {
                    info.photoUrl = photoUrl
                }
                if let notificationId = data["notification_id"] as? String {
                    info.notificationId = notificationId
                }
            }
        } else if info.title == PushType.GoalInvite {
            if let data = userInfo["data"] as! [String: AnyObject]? {
                if let userId = data["title"] as? Int {
                    info.userId = userId
                }
                if let name = data["owner_name"] as? String {
                    info.name = name
                }
                if let photoUrl = data["owner_photo_url"] as? String {
                    info.photoUrl = photoUrl
                }
                if let notificationId = data["notification_id"] as? String {
                    info.notificationId = notificationId
                }
                if let userId = data["id"] as? Int {
                    info.userId = userId
                }
            }
        }
        
        return info
    }
    
    //*****************************************************************
    // MARK: - API
    //*****************************************************************
    
    private func sendAction(_ data: PushInfo, _ type: PushAlertViewType){
        
        guard  let userGoalId = data.userId, let notifId = data.notificationId else {
            return
        }
        
        if type == PushAlertViewType.Accept {
            if data.title == PushType.FriendInvite {
                viewModel.acceptInviteAction(userGoalId, notifId)
            } else if data.title == PushType.GoalInvite {
                viewModel.acceptInviteToGoalAction(userGoalId, notifId)
            }
        } else if type == PushAlertViewType.Decline {
            if data.title == PushType.FriendInvite {
                viewModel.declineInviteAction(userGoalId, notifId)
            } else if data.title == PushType.GoalInvite {
                viewModel.declineInviteToGoalAction(userGoalId, notifId)
            }
        } else if type == PushAlertViewType.Close {
//            viewModel.markAsReadNotificationsAction(notifId)
        }
    }
    
    func acceptMade(_ message: String){
        updateData(message)
    }
    
    func declineMade(_ message: String){
        updateData(message)
    }
    
    private func updateData(_ message: String) {
        
        PushAlertManager.sharedInstance.hideView()
        PushManager.sharedInstance.updateBudge()
        
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController else {
            print("Error")
            return
        }
        Alert.show(controller: viewController, title: AlertTitle.TitleCommon, message: message, action: nil)
    }
    
    func markRead() {
        PushAlertManager.sharedInstance.hideView()
        PushManager.sharedInstance.updateBudge()
    }
    
    func updateBudge(){
        viewModel.updateNotificationCountAction()
    }
}

extension PushManager: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){}
    
    func viewModelDidEndUpdate(){}
}

enum PushType:String {
    case FriendInvite   = "Friend request"
    case GoalInvite     = "Join to the goal"
}

class PushInfo{
    
    var body            : String?
    var name            : String?
    var photoUrl        : String?
    var userId          : Int?
    var title           : PushType!
    var notificationId  : String?
    
    class func stringToPushType(text: String) -> PushType {
        if text == PushType.FriendInvite.rawValue {
            return PushType.FriendInvite
        } else {
            return PushType.GoalInvite
        }
    }
}



