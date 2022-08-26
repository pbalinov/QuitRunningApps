//
//  ApplicationModel.swift
//  QuitRunningApps
//

import Foundation
import SwiftUI
import Cocoa

struct Application: Identifiable
{
    let id: Int32           // Process ID
    let appName: String     // Localized App Name
    let appBundle: String   // App Bundle
    let appIcon: NSImage    // App Icon
    
    init(_ app: NSRunningApplication)
    {
        self.id = app.processIdentifier
        self.appName = app.localizedName!
        self.appIcon = app.icon!
        self.appBundle = app.bundleIdentifier!
    }
    
    init(_ app: Application)
    {
        self.id = app.id
        self.appName = app.appName
        self.appIcon = app.appIcon
        self.appBundle = app.appBundle
    }
}

class ApplicationModel: ObservableObject
{
    // Main list of running applications
    @Published var applications: [Application]
    // Observers for changes in running applications
    var observers: [NSKeyValueObservation]
    // Filter per app bundle identifier
    let appsToFilter: [String] = ["com.apple.finder", "com.pbalinov.QuitRunningApps"]
    
    init()
    {
        self.applications = []
        self.observers = []
    }
    
    func loadRunningApplications()
    {
        // Always load from scratch
        applications.removeAll()
        
        // Get the list of running applications on the local machine
        let ws = NSWorkspace.shared
        let allRunningApps = ws.runningApplications
        
        for currentApp in allRunningApps.enumerated()
        {
            let runningApp = allRunningApps[currentApp.offset]

            if(allowAppInList(runningApp))
            {
                applications.append(Application(runningApp))
#if DEBUG
                print("App name: " + runningApp.localizedName!)
#endif
            }
        }
        
        // Sort the apps by name
        applications.sort { $0.appName < $1.appName }
#if DEBUG
        print("Applications are reloaded and sorted.")
#endif
    }
    
    func allowAppInList(_ app: NSRunningApplication) -> Bool
    {
        // The application is an ordinary app that appears
        // in the Dock and may have a user interface.
        // The application does not belong to the list of
        // apps to be filtered.
        // The application has a valid properies.
        
        if(app.activationPolicy != .regular)
        {
            // The app is not an ordinary app
            return false
        }
        
        // Check the app name
        var emptyName = false
        if let appName = app.localizedName
        {
            // String is not nil, check is empty
            emptyName = appName.isEmpty
        }
        else
        {
            // String is nil, missing name
            emptyName = true
        }
        
        // Check the app bundle
        var emptyBundle = false
        if let appBundle = app.bundleIdentifier
        {
            // String is not nil, check is empty
            emptyBundle = appBundle.isEmpty
        }
        else
        {
            // String is nil, missing bundle
            emptyBundle = true
        }
                
        if((emptyName) || (emptyBundle))
        {
            // Any of the properties is empty
            // Do not allow the app in list
            return false
        }
                
        // Check if the application belong to the list of apps to be filtered
        // Filter per app bundle identifier
        let foundInFilter = appsToFilter.contains(app.bundleIdentifier!)

        // Allow in list if not found in filter
        return !foundInFilter
    }
    
    func registerObservers()
    {
        // Monitor for changes in the running applications
        self.observers =
        [
            NSWorkspace.shared.observe(\.runningApplications, options: [.new])
            {
                (model, change) in
                // runningApplications changed - reload the list
#if DEBUG
                print("Changes! Inform model to reload applications...")
#endif
                self.loadRunningApplications()
            }
        ]
    }
}
