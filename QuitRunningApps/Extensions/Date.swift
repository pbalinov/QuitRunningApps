//
//  Date.swift
//  QuitRunningApps
//

import Foundation

// Supports date saving in user defaults
// Used in SettingsModel
extension Date: RawRepresentable
{
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}
