//
//  Calendar.swift
//  QuitRunningApps
//

import Foundation


extension Calendar {

    // Compare dates and return days in between
    // Get a day component from dates without stripping out time component
    // Used for updates check
    func numberOfDaysBetween(_ from: Date,_ to: Date) -> Int {
        let numberOfDays = dateComponents([.day], from: from, to: to)
        return numberOfDays.day!
    }
}
