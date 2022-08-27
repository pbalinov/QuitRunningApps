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
    private var observers: [NSKeyValueObservation]
    // Filter per app bundle identifier
    let appsToFilter: [String] = ["com.apple.finder", "com.pbalinov.QuitRunningApps"]
    // Status updates
    @Published var statusUpdates: String
    // Is closing process running
    private var isClosingRunning: Bool = false
    // Is refresh process running
    private var isRefreshRunning: Bool = false
    
    init()
    {
        self.applications = []
        self.observers = []
        self.statusUpdates = ""
    }
    
    func loadRunningApplications()
    {
        isRefreshRunning = true
        
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
                //print("App name: " + runningApp.localizedName!)
#endif
            }
        }
        
        // Sort the apps by name
        applications.sort { $0.appName < $1.appName }
        
        // Show status
#if DEBUG
        print("Applications are reloaded and sorted.")
#endif
        statusUpdates = "\(applications.count)" + NSLocalizedString("running-apps", comment: "")
        
        isRefreshRunning = false
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
    
    func validateObserverNotification(_ change: NSKeyValueObservedChange<[NSRunningApplication]>) -> Bool
    {
        // Filter only apps that are valid for the list
        
        let runningApp: NSRunningApplication? = change.newValue?.first
        
        if(runningApp == nil)
        {
            // No running app in the array, nil
            return false
        }
        
        // nil when closing?
        if(runningApp?.activationPolicy != .regular)
        {
            return false
        }
        
        // Refresh applications only when the closing
        // or refresh is not running
        if(self.isClosingRunning || self.isRefreshRunning)
        {
            return false
        }
        else
        {
#if DEBUG
            print("Changes! Inform model to reload applications...")
#endif
            return true
        }
    }
    
    func registerObservers()
    {
        // Monitor for changes in the running applications
        self.observers =
        [
            NSWorkspace.shared.observe(\.runningApplications, options: [.new])
            {
                (model, change) in
                if(self.validateObserverNotification(change))
                {
                    // Change is valid - reload the applications
                    self.loadRunningApplications()
                }
            }
        ]
    }
    
    func closeRunningApplications()
    {
        // Starting to close the applications
        isClosingRunning = true
        
        // Create a local copy of the list to process
        let allAppsToClose = self.applications
        
#if DEBUG
        print("Start closing the runnign applications.")
#endif
        // Close the list of running applications
        for currentApp in allAppsToClose.enumerated()
        {
            let appFromList: Application = allAppsToClose[currentApp.offset]
            if let appToClose = NSRunningApplication.init(processIdentifier: appFromList.id)
            {
                // App has a valid process ID
#if DEBUG
                if(appFromList.appName != "Finder")
                {
                    // Close only Word in debug session
                    continue
                }
#endif
                // Close the application
                let isAppClosed = appToClose.terminate()
                if(isAppClosed)
                {
                    // Success
#if DEBUG
                    print("Closing: \(appFromList.appName) was successful.")
#endif

                }
                else
                {
                    // Failed to close it
#if DEBUG
                    print("Closing: \(appFromList.appName) failed.")
#endif
                }
            }
            else
            {
                // App has no valid process ID
                // Proceed with the next in list
                continue;
            }
        }
        
        // Finished closing the applications
        isClosingRunning = false
#if DEBUG
        print("Closed all running applications.")
#endif
    }
}
