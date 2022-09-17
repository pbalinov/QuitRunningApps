//
//  Application.swift
//  QuitRunningApps
//

import Foundation
import Cocoa

struct Application: Identifiable, Hashable {
    
    // Holds list of apps and their properties
    // Shown on main screen and dyanmically updated by
    // ApplicationModel
    
    let id: Int32           // Process ID
    let appName: String     // Localized App Name
    let appBundle: String   // App Bundle
    let appIcon: NSImage    // App Icon
    
    init(_ app: NSRunningApplication) {
        self.id = app.processIdentifier
        self.appName = app.localizedName ?? ""
        self.appIcon = app.icon ?? NSImage(imageLiteralResourceName: "App")
        self.appBundle = app.bundleIdentifier ?? ""
    }
    
}
