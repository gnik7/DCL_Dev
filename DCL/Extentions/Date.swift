//
//  Date.swift
//  DCL
//
//  Created by Nikita on 2/16/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
extension Date {
    
    //*****************************************************************
    // MARK: -
    //*****************************************************************
    
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy' at 'hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    func dateForServerToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func notificationDateToString() -> String {
        let date = NSDate()
        var calendar = NSCalendar.current
       
        let unitFlags = Set<Calendar.Component>([.month, .year, .day])
        calendar.timeZone = TimeZone.current
//        calendar.timeZone = TimeZone(identifier: "UTC")!
        let _ = calendar.dateComponents(unitFlags, from: date as Date)
        let monthNow = calendar.component(.month, from: date as Date)
        let yearNow = calendar.component(.year, from: date as Date)
        let dayNow = calendar.component(.day, from: date as Date)
        
        
        let month = calendar.component(.month, from: self.currentTimeZoneDate())
        let year = calendar.component(.year, from: self.currentTimeZoneDate())
        let day = calendar.component(.day, from: self.currentTimeZoneDate())
        
        var dayString = ""
        if monthNow == month && yearNow == year && dayNow == day {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            let timeString = dateFormatter.string(from: self.currentTimeZoneDate())
            dayString = "Today "
            let fullString = dayString + timeString
            return fullString
        } else {
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            let dayString = dateFormatter1.string(from: self.currentTimeZoneDate())
            let dateFormatter2 = DateFormatter()
            dateFormatter2.timeStyle = .short
            let timeString = dateFormatter2.string(from: self.currentTimeZoneDate())
            let fullString = dayString + " " + timeString
            return fullString
        }
    }
    
    func currentTimeZoneDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let secondsFromGMT = TimeZone.current.secondsFromGMT()
        let gmtTime = self.addingTimeInterval(TimeInterval(secondsFromGMT))       
        
        return gmtTime
    }
    
    static func todayToString() -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: today)
    }
    
    static func todayEuropeToString() -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: today)
    }
    
    static func todayGlobalToString() -> String{
        let result = UserDefaultsManager.updateInfoDateFormat()
        if result {
            return Date.todayToString()
        } else {
            return Date.todayEuropeToString()
        }
    }
    
}
