//
//  Calendar.swift
//  QuitRunningApps
//

import Foundation

extension Calendar {
    
    func numberOfDaysBetween(_ from: Date,_ to: Date) -> Int {
        
        // Compare dates and return days in between
        // Get a day component from dates without stripping out time component
        
        let numberOfDays = dateComponents([.day], from: from, to: to)
        return numberOfDays.day!
    }
    
}
