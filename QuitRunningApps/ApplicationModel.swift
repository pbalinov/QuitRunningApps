//
//  ApplicationModel.swift
//  QuitRunningApps
//

import Foundation
import Cocoa

class ApplicationModel: ObservableObject
{
    // Main list of running applications
    @Published var applications: [Application]
    // Selected items in the list
    @Published var selection = Set<Application>()
    // Observers for changes in running applications
    private var observers: [NSKeyValueObservation]
    // Settings
    private var closeOurApp: Bool
    private var closeFinder: Bool
    // Filter per app bundle identifier
    private var appsToFilter: Set<String>
    private let finderBundle: String
    // Is closing process running
    private var isClosingRunning: Bool
    // Is refresh process running
    private var isRefreshRunning: Bool
    // How many apps we closed
    private var appsBeingClosed: Int
    private var appsToClose: Int
    
    init()
    {
        self.applications = []
        self.observers = []
        self.isRefreshRunning = false
        self.isClosingRunning = false
        self.closeOurApp = false
        self.closeFinder = false
#if DEBUG
        appsToFilter = ["com.pbalinov.QuitRunningApps", "com.apple.dt.Xcode"]
#else
        appsToFilter = ["com.pbalinov.QuitRunningApps"]
#endif
        self.finderBundle = "com.apple.finder"
        self.appsBeingClosed = 0
        self.appsToClose = 0
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
                //print("App bundle: " + runningApp.bundleIdentifier!)
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
    
    func filterAppsToClose(_ sourceListOfApps: [Application], _ filter: Set<Application>) -> [Application]
    {
        // Selected apps from the list will not be closed
        
        var filteredApps: [Application] = []
                
        if(filter.count == 0)
        {
            // Nothing to filter
            // Return the original list
            filteredApps = sourceListOfApps
            return filteredApps
        }
                
        for app in sourceListOfApps
        {
            if(!filter.contains(app))
            {
                // The app is not selected
                // Add the app in the list for closing
                filteredApps.append(app)
            }
        }
        
        return filteredApps
    }
    
    func closeRunningApplications()
    {
        // Starting to close the applications
        isClosingRunning = true
        
        // Create a local copy of the list to process
        // Filter the list and remove the selected items from the list
        let allAppsToClose = filterAppsToClose(self.applications, self.selection)
        
        // How many apps we informed to close
        appsBeingClosed = 0
        appsToClose = allAppsToClose.count;
                
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
            
            // ToDo: Close our app here - later check if we can wait
            checkAndCloseOurApp()
        }
        
#if DEBUG
        if(appsToClose > 0)
        {
            print("Informed \(appsBeingClosed) from \(appsToClose) running applications to close.")
        }
        else
        {
            print("There were no apps to close.")
        }
#endif
        
        // Finished closing the applications
        // formatStatusText(statusUpdateTypes.closing, appsBeingClosed)
        isClosingRunning = false
    }
    
    func finderAppClosing(_ close: Bool)
    {
        if(!close)
        {
            // Do not close Finder - add it to the filter
            appsToFilter.update(with: finderBundle)
        }
        else
        {
            // Close Finder - remove it from the filter
            appsToFilter.remove(finderBundle)            
        }
        
        closeFinder = close
#if DEBUG
        print("Closing macOS Finder app setting is updated to \(closeFinder).")
#endif
    }
    
    func ourAppClosing(_ close: Bool)
    {
        closeOurApp = close
#if DEBUG
        print("Closing our own application setting is updated to \(closeOurApp).")
#endif
    }
    
    func checkAndCloseOurApp ()
    {
        if(!closeOurApp)
        {
            // Close our app setting is off
            return
        }
        
        if(appsToClose == 0)
        {
            // Nothing closed - do not quit
            return
        }
        
        if(appsBeingClosed < appsToClose)
        {
            // Not all apps are closed - do not quit
            return
        }
        
        // and all apps are informed to be closed
        // and we actually closed at least one app
#if DEBUG
        print("Closing our own application also.")
#endif
        NSApplication.shared.terminate(nil)
    }
}
