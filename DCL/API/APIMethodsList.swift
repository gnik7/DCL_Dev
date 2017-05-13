//
//  APIMethodsList.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation

// REST methods
public enum API_Call : String {
    
    // user registration
    case register = "/register"
    // forgot-password
    case forgot_password = "/forgot-password"
    // login
    case login = "/login"
    // facebook login
    case facebook_login = "/fblogin"
    // refresh token
    case refresh_auth = "/refresh-auth"
    
    
    
    // get profile
    case profile = "/profile"
    // get stores
    case stores = "/stores"
    //add goal / list of goals
    case add_goal = "/goals"
    //update title
    case update_goal_title = "/goals/%u/title"
    //update location
    case update_goal_location = "/goals/%u/location"
    //update date
    case update_goal_ends_at = "/goals/%u/ends-at"
    
    //list_of_achieved_goals
    case list_of_achieved_goals = "/goals/achieved"
    
    //save check list item
    case update_goal_check_list_item = "/goals/%u/store-checklist-item" 
    //save reminder item
    case update_goal_reminder_item = "/goals/%u/store-reminder-item"   
    //update get list of checklists
    case update_goal_checklists = "/goals/%u/checklists"
    //update get list of  reminders
    case update_goal_reminders = "/goals/%u/reminders"
    
    //update checklist selected
    case update_goal_checklist_item_selected = "/goals/checklist-item/%u/to-achieve"
    //update reminder selected
    case update_goal_reminder_item_selected = "/goals/reminder-item/%u/to-achieve"
    //update checklist text
    case update_goal_checklist_item_text = "/goals/checklist-item/%u/update"
    //update reminder text
    case update_goal_reminder_item_text = "/goals/reminder-item/%u/update"
    //save cover goal  
    case save_goal_cover = "/goals/%u/cover"
    //save / delete media goal
    case save_goal_media = "/goals/%u/media"

    //delete goal
    case goals_item = "/goals/%u"
    
    //celebrate goal
    case goal_celebrate = "/goals/%u/celebrate"
    //delete friend in goal
    case goal_delete_friend = "/goals/%u/delete-friend"
    
    
    //update password profile
    case update_password = "/profile/password"
    // profile change email
    case profile_change_email = "/profile/email"
    // profile change avatar
    case profile_change_avatar = "/profile/avatar"
    // user logout
    case user_logout = "/logout"
    // profile is notifiable
    case profile_is_notifiable = "/profile/is-notifiable"
    // profile is notifiable
    case profile_recover_goals = "/goals/deleted"
    // profile restore goals
    case profile_restore_goals = "/goals/restore"
    
    // profile time zone
    case profile_time_zone = "/profile/set-timezone"
    
    // profile time zone
    case motivate_me = "/profile/motivate"
    
    // notifications
    case user_notifications = "/profile/notifications"
    // notifications count
    case count_notifications = "/profile/notifications/count-unread"
    // notifications
    case mark_as_read_notifications = "/profile/notifications/mark-as-read"
    // accept invite
    case accept_invite = "/friends/accept-invite"
    // decline invite
    case decline_invite = "/friends/decline-invite"
    // accept invite to goal
    case accept_invite_to_goal = "/goals/%u/accept-invite"
    // decline invite to goal
    case decline_invite_to_goal = "/goals/%u/decline-invite"
    
    
    // list of all users
    case list_all_users = "/friends"
    // list of friends user
    case list_friends_user = "/friends/my-friends"
    // invite friend by email
    case invite_friend_by_email = "/friends/invite-by-email"
    // invite to friend
    case invite_to_friend = "/friends/invite"
    // invite friend to goal
    case invite_friend_to_goal = "/goals/%u/assign"
   
    
    
    
    // list of groups /create new groups
    case list_groups = "/groups"    
    // group detail
    case group_detail = "/groups/%u/show"
    // remove user from group
    case remove_user_from_group = "/groups/%u/remove-assign"
    // share goal to group
    case share_goal_to_group = "/goals/share-goals"
    // remove user from group
    case remove_group = "/groups/%u"
    
    
    
    // list of ideas
    case list_ideas = "/ideas"
    // list of ideas in category
    case list_ideas_in_category = "/ideas/category/%u"
  
    // user search
        
    static func getURL(method api_name: API_Call) -> String {        
        return (host + api_name.rawValue).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    static func getURLClear(method api_name: API_Call) -> String {
        return (host + api_name.rawValue)
    }
}
