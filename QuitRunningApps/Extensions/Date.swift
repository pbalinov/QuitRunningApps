//
//  Date.swift
//  QuitRunningApps
//

import Foundation

extension Date: RawRepresentable
{
    // Supports date saving in user defaults
    
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
    
}
