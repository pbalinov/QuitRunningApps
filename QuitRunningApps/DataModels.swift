//
//  DataModels.swift
//  QuitRunningApps
//

import Foundation
import Cocoa

// Application struct
// Holds list of apps and their properties
// Shown on main screen and syanmically updated by
// ApplicationModel

struct Application: Identifiable, Hashable
{
    let id: Int32           // Process ID
    let appName: String     // Localized App Name
    let appBundle: String   // App Bundle
    let appIcon: NSImage    // App Icon
    
    init(_ app: NSRunningApplication)
    {
        self.id = app.processIdentifier
        self.appName = app.localizedName ?? ""
        self.appIcon = app.icon ?? NSImage(imageLiteralResourceName: "App")
        self.appBundle = app.bundleIdentifier ?? ""
    }
    
    init(_ app: Application)
    {
        self.id = app.id
        self.appName = app.appName
        self.appIcon = app.appIcon
        self.appBundle = app.appBundle
    }
}

// Application Verssion Information
// JSON parser
// See App Updates \ version.json

struct Response: Codable
{
    var results: [Result]
}

struct Result: Codable
{
    var version: Decimal
    var build: Int
    var applicationId: String
    var applicationName: String
}

// Supports date saving in user defaults
// Used in SettingsModel
extension Date: RawRepresentable
{
    public var rawValue: String
    {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String)
    {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}

// Compare dates and return days in between
// Get a day component from dates without stripping out time component
// Used for updates check
extension Calendar
{
    func numberOfDaysBetween(_ from: Date,_ to: Date) -> Int
    {
        let numberOfDays = dateComponents([.day], from: from, to: to)
        return numberOfDays.day!
    }
}

// Get the application version and build
// from the bundle
extension Bundle
{
    var releaseVersionNumber: String?
    {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String?
    {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
