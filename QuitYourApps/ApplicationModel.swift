//
//  ApplicationModel.swift
//  QuitYourApps
//

import Foundation
import SwiftUI
import Cocoa

struct Application: Identifiable {
    let id: Int32           // Process ID
    let appName: String     // Localized App Name
    let appIcon: NSImage    // App Icon
    
    init(application: NSRunningApplication)
    {
        self.id = application.processIdentifier
        self.appName = application.localizedName!
        self.appIcon = application.icon!
    }
}

extension Application {
    static func LoadRunningApplications() async -> [Application] {
        // Get the list of running applications on the local machine
        let ws = NSWorkspace.shared
        let allRunningApps = ws.runningApplications
        var appsWithWindow: [Application] = []

        for currentApp in allRunningApps.enumerated()
        {
            let runningApp = allRunningApps[currentApp.offset]

            if(runningApp.activationPolicy == .regular)
            {
                // The application is an ordinary app that appears
                // in the Dock and may have a user interface.
                appsWithWindow.append(Application(application: runningApp))
            }
        }
        
        return appsWithWindow
    }
}
