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

enum statusUpdateTypes
{
    // Status update types
    case updating, closing
}

class ApplicationModel: ObservableObject
{
    // Main list of running applications
    @Published var applications: [Application] = []
    // Observers for changes in running applications
    private var observers: [NSKeyValueObservation] = []
    // Filter per app bundle identifier
    let appsToFilter: Set<String> = ["com.apple.finder", "com.pbalinov.QuitRunningApps"]
    // Status updates
    @Published var statusUpdates: String = ""
    // Is closing process running
    private var isClosingRunning: Bool = false
    // Is refresh process running
    private var isRefreshRunning: Bool = false
    
    init()
    {
        self.applications = []
        self.observers = []
        self.statusUpdates = ""
        self.isRefreshRunning = false
        self.isClosingRunning = false
    }
    
    func loadRunningApplications()
    {
        isRefreshRunning = true
        
        // Always load from scratch
        applications.removeAll()
        
        // Get the list of running applications on the local machine
        let workspace = NSWorkspace.shared
        let allRunningApps = workspace.runningApplications

        for runningApp in allRunningApps
        {
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
        //formatStatusText(statusUpdateTypes.updating, applications.count)
                
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
        if(!validateString(app.localizedName))
        {
            // Name is empty
            // Do not allow the app in list
            return false
        }
        
        if(!validateString(app.bundleIdentifier))
        {
            // Bundle is empty
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
        
        // Refresh applications only when the closing
        // or refresh is not running
        if(self.isClosingRunning || self.isRefreshRunning)
        {
            return false
        }
        
        // Check for valid new or old value.
        // Observer is subscribed for old and new value changes.
        let runningAppNew: NSRunningApplication? = change.newValue?.first
        let runningAppOld: NSRunningApplication? = change.oldValue?.first
        
        if(runningAppNew != nil)
        {
            // Handle changes for regular apps only
            if(runningAppNew?.activationPolicy == .regular)
            {
#if DEBUG
                print("Changes! Inform model to reload applications...")
#endif
                return true
            }
        }
        else if (runningAppOld != nil)
        {
            // Handle changes for regular apps only
            if(runningAppOld?.activationPolicy == .regular)
            {
#if DEBUG
                print("Changes! Inform model to reload applications...")
#endif
                return true
            }
        }
        
        return false
    }
    
    func registerObservers()
    {
        // Monitor for changes in the running applications
        self.observers =
        [
            // New values handle launched apps and old values closed
            NSWorkspace.shared.observe(\.runningApplications, options: [.new, .old])
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
        
        // How many apps we informed to close
        var appsBeingClosed: Int = 0
        
        // Create a local copy of the list to process
        let allAppsToClose = self.applications
        
        // Close the list of running applications
        for appFromList in allAppsToClose
        {
            guard let appToClose = NSRunningApplication.init(processIdentifier: appFromList.id) else
            {
                // App has no valid process ID
                // Proceed with the next in list
                continue;
            }
            
            // App has a valid process ID
#if DEBUG
            if(appFromList.appName != "Microsoft Word")
            {
                // Close only Word in debug session
                continue
            }
#endif
            // Close the application
            if(appToClose.terminate())
            {
                // Success
                appsBeingClosed += 1
#if DEBUG
                print("Inform \(appFromList.appName) to close was successful.")
#endif

            }
            else
            {
                // Failed to close it
#if DEBUG
                print("Inform \(appFromList.appName) to close failed.")
#endif
            }
        }
        
#if DEBUG
        print("Informed all running applications to close.")
#endif
        
        // Finished closing the applications
        // formatStatusText(statusUpdateTypes.closing, appsBeingClosed)
        isClosingRunning = false
    }
    
    func formatStatusText (_ type: statusUpdateTypes, _ apps: Int)
    {
        switch type
        {
        case .updating:
            switch apps
            {
            case 0:
                statusUpdates = NSLocalizedString("no", comment: "") + " " + NSLocalizedString("running-apps", comment: "")
            case 1:
                statusUpdates = String(apps) + " " + NSLocalizedString("running-app", comment: "")
            default:
                statusUpdates = String(apps) + " " + NSLocalizedString("running-apps", comment: "")
            }
        case .closing:
            switch apps
            {
            case 0:
                statusUpdates = NSLocalizedString("no", comment: "") + " " + NSLocalizedString("closing-apps", comment: "")
            case 1:
                statusUpdates = String(apps) + " " + NSLocalizedString("closing-app", comment: "")
            default:
                statusUpdates = String(apps) + " " + NSLocalizedString("closing-apps", comment: "")
            }
        }
    }
}
