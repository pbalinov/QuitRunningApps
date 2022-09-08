//
//  DataModels.swift
//  QuitRunningApps
//

import Foundation
import Cocoa

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
