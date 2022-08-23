//
//  ApplicationModel.swift
//  QuitRunningApps
//

import Foundation
import SwiftUI
import Cocoa

// Filter per app bundle identifier
// let appsToFilter: [String] = ["com.apple.finder", "com.pbalinov.QuitRunningApps"]
let appsToFilter: [String] = ["com.pbalinov.QuitRunningApps"]

struct Application: Identifiable {
    let id: Int32           // Process ID
    let appName: String     // Localized App Name
    let appBundle: String   // App Bundle
    let appIcon: NSImage    // App Icon
    
    init(application: NSRunningApplication)
    {
        self.id = application.processIdentifier
        self.appName = application.localizedName!
        self.appIcon = application.icon!
        self.appBundle = application.bundleIdentifier!
    }
}

extension Application {
    static func loadRunningApplications()  -> [Application] {
        // Get the list of running applications on the local machine
        let ws = NSWorkspace.shared
        let allRunningApps = ws.runningApplications
        var applications: [Application] = []

        for currentApp in allRunningApps.enumerated()
        {
            let runningApp = allRunningApps[currentApp.offset]

            if((runningApp.activationPolicy == .regular) &&
               (!appsToFilter.contains(runningApp.bundleIdentifier!)))
            {
                // The application is an ordinary app that appears
                // in the Dock and may have a user interface.
                // The application does not belong to the list of
                // apps to be filtered.
                applications.append(Application(application: runningApp))
            }
        }
        
        return applications
    }
}
