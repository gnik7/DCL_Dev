//
//  TimeManager.swift
//  DCL
//
//  Created by Nikita Gil on 05.04.17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation


class TimeManager {
    
    static let sharedInstance = TimeManager()
    
    var viewModel = TimeManagerViewModel()
    
    init() {
        self.viewModel.delegate = self
    }
    
    func updateTime(){
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        let tmp = localTimeZoneAbbreviation.replacingOccurrences(of: "GMT", with: "")
        print(tmp)
        var localTimeZoneName: String { return TimeZone.current.identifier }
        print(localTimeZoneName)
        viewModel.updateTimeAction(tmp, localTimeZoneName)
    }
    
}

extension TimeManager: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){}
    
    func viewModelDidEndUpdate(){}
}
