//
//  ApplicationViewModel.swift
//  QuitRunningApps
//

import Foundation
import Cocoa

class ApplicationViewModel: ObservableObject {
    
    // Main list of running applications
    @Published var applications: [Application]
    // Selected items in the list
    @Published var selection: Set<Application>
    // Observers for changes in running applications
    private var observers: [NSKeyValueObservation]
    // Settings
    private var closeOurApp: Bool
    private var closeFinderApp: Bool
    // Is closing process running
    private var isClosingRunning: Bool
    // Is refresh process running
    private var isRefreshRunning: Bool
    // How many apps we closed
    private var appsBeingClosed: Int
    private var appsFailedToClose: Int
    private var appsToClose: Int
    // Filter per app bundle identifier
    private var bundleAppsToFilter: Set<String>
    // Apps to never quit
    private var firstAppToNeverQuitBundle: String
    private var secondAppToNeverQuitBundle: String
    private var thirdAppToNeverQuitBundle: String
    
    init() {
        self.applications = []
        self.selection = []
        self.observers = []
        self.closeOurApp = false
        self.closeFinderApp = false
        self.isClosingRunning = false
        self.isRefreshRunning = false
        self.appsBeingClosed = 0
        self.appsFailedToClose = 0
        self.appsToClose = 0
#if DEBUG
        bundleAppsToFilter = [Constants.Bundles.ourApp, Constants.Bundles.xcodeApp]
#else
        bundleAppsToFilter = [Constants.Bundles.ourApp]
#endif
        self.firstAppToNeverQuitBundle = ""
        self.secondAppToNeverQuitBundle = ""
        self.thirdAppToNeverQuitBundle = ""
    }
        
    private func allowAppInList(_ app: NSRunningApplication) -> Bool {
        
        // The application is an ordinary app that appears
        // in the Dock and may have a user interface.
        // The application does not belong to the list of
        // apps to be filtered.
        // The application has a valid properies.
        
        if(app.activationPolicy != .regular) {
            // The app is not an ordinary app
            return false
        }
        
        if(!validateString(app.localizedName)) {
            // The app name is empty
            // Do not allow the app in list
            return false
        }
        
        if(!validateString(app.bundleIdentifier)) {
            // App bundle Id is empty
            // Do not allow the app in list
            return false
        }
        
        // Check if the application belong to the list of apps to be filtered
        // Filter per app bundle identifier
        let foundInFilter = bundleAppsToFilter.contains(app.bundleIdentifier!)

        // Allow in list if not found in filter
        return !foundInFilter
    }
    
    private func validateObserverNotification(_ change: NSKeyValueObservedChange<[NSRunningApplication]>) -> Bool {
        
        // Filter only apps that are valid for the list
                
        if(self.isClosingRunning || self.isRefreshRunning) {
            // Refresh applications only when the closing
            // or refresh is not running
            return false
        }
        
        // Check for valid new or old value.
        // Observer is subscribed for old and new value changes.
        let runningAppNew: NSRunningApplication? = change.newValue?.first
        let runningAppOld: NSRunningApplication? = change.oldValue?.first
        
        if(runningAppNew != nil) {
            // Handle changes for regular apps only
            if(runningAppNew?.activationPolicy == .regular) {
#if DEBUG
                print("Changes! Inform model to reload applications...")
#endif
                return true
            }
        } else if (runningAppOld != nil) {
            // Handle changes for regular apps only
            if(runningAppOld?.activationPolicy == .regular) {
#if DEBUG
                print("Changes! Inform model to reload applications...")
#endif
                return true
            }
        }
        
        return false
    }
    
    func registerObservers() {
        
        // Monitor for changes in the running applications
        
        self.observers =
        [
            // New values handle launched apps and old values closed
            NSWorkspace.shared.observe(\.runningApplications, options: [.new, .old]) {
                (model, change) in if(self.validateObserverNotification(change)) {
                    // Change is valid - reload the applications
                    self.applications = self.loadRunningApplications()
                }
            }
        ]
    }
    
    private func filterAppsToCloseBySelection(_ sourceListOfApps: [Application], _ filter: Set<Application>) -> [Application] {
        
        // Selected apps from the list will not be closed
        
        var filteredApps: [Application] = []
                
        if(filter.count == 0) {
            // Nothing to filter
            // Return the original list
            filteredApps = sourceListOfApps
            return filteredApps
        }
                
        for app in sourceListOfApps {
            if(!filter.contains(app)) {
                // The app is not selected
                // Add the app in the list for closing
                filteredApps.append(app)
            }
        }
        
        return filteredApps
    }
    
    func closeRunningApplications() {
        
        // Close all running applications that are not selected
        // and do not belong to the "never quit" set of apps
        
        isClosingRunning = true
        
        // Create a local copy of the list to process
        // Filter the list and remove the selected items from the list
        let allAppsToClose = filterAppsToCloseBySelection(self.applications, self.selection)
        
        // How many apps we informed to close
        appsBeingClosed = 0
        appsFailedToClose = 0
        appsToClose = allAppsToClose.count;
                
        // Close the list of running applications
        for appFromList in allAppsToClose {
            guard let appToClose = NSRunningApplication.init(processIdentifier: appFromList.id) else {
                // App has no valid process ID
                // Proceed with the next in list
                continue;
            }
            
            // App has a valid process ID
            // Close the application
            if(appToClose.terminate()) {
                // Success
                appsBeingClosed += 1
#if DEBUG
                print("Inform \(appFromList.appName) to close was successful.")
#endif
            } else {
                // Failed to close the app
                appsFailedToClose += 1
#if DEBUG
                print("Inform \(appFromList.appName) to close failed.")
#endif
            }
            
            // Close our app here without waiting for the others
            checkAndCloseOurApp()
        }
        
#if DEBUG
        if(appsToClose > 0) {
            print("Informed \(appsBeingClosed) from \(appsToClose) running applications to close.")
        } else {
            print("There were no apps to close.")
        }
#endif
        
        // Finished closing the applications
        isClosingRunning = false
    }
    
    func shouldCloseFinderApp(_ closeFinderApp: Bool) {
        
        if(!closeFinderApp) {
            // Do not close Finder - add it to the filter
            bundleAppsToFilter.update(with: Constants.Bundles.finderApp)
        } else {
            // Close Finder - remove it from the filter
            bundleAppsToFilter.remove(Constants.Bundles.finderApp)
        }
        
        self.closeFinderApp = closeFinderApp
        
#if DEBUG
        print("Closing macOS Finder app setting is set to \(closeFinderApp).")
#endif
    }
    
    func shouldCloseOurApp(_ closeOurApp: Bool) {
        
        self.closeOurApp = closeOurApp
#if DEBUG
        print("Closing our own application setting is set to \(closeOurApp).")
#endif
    }
    
    func checkAndCloseOurApp () {
        
        // Check if enabled and close our app
        
        if(!closeOurApp) {
            // Close our app setting is off
            return
        }
        
        if(appsToClose == 0) {
            // Nothing closed - do not quit
            return
        }
        
        if(appsBeingClosed < appsToClose) {
            // Not all apps are closed - do not quit
            return
        }
        
        // All apps are informed to be closed
        // and we actually closed at least one app
#if DEBUG
        print("Closing our own application also.")
#endif
        NSApplication.shared.terminate(nil)
    }
    
    func loadRunningApplications() -> [Application] {
        
        // Load all running applications that
        // comply with the rules and populate the
        // list on the main screen
        
        // Start with empty list
        var applications: [Application] = []
        
        // Get the list of running applications on the local machine
        let workspace = NSWorkspace.shared
        let allRunningApps = workspace.runningApplications

        for runningApp in allRunningApps {
            if(allowAppInList(runningApp)) {
                applications.append(Application(runningApp))
#if DEBUG
                //print("App name: " + runningApp.localizedName!)
                //print("App bundle: " + runningApp.bundleIdentifier!)
#endif
            }
        }
        
        // Sort the apps by name
        applications.sort { $0.appName < $1.appName }
        
#if DEBUG
        print("Applications are reloaded and sorted.")
#endif
        
        return applications
    }
    
    private func shouldNeverQuitSelectedApp(_ appToNeverQuitBundleNew: String, _ appToNeverQuitBundleOld: String) -> String {
        
        // Update the set of "never quit" apps
        
        // Remove the old value from the filter
        if let index = bundleAppsToFilter.firstIndex(of: appToNeverQuitBundleOld) {
            bundleAppsToFilter.remove(at: index)
        }
        
        if(validateString(appToNeverQuitBundleNew)) {
            // Update the list and add the new value
            bundleAppsToFilter.update(with: appToNeverQuitBundleNew)
#if DEBUG
            print("Do not quit list updated with bundle Id: \(appToNeverQuitBundleNew).")
#endif
        } else {
#if DEBUG
            if(validateString(appToNeverQuitBundleOld)) {
                print("Do not quit list removed bundle Id: \(appToNeverQuitBundleOld).")
            }
#endif
        }
        
        return appToNeverQuitBundleNew
    }
    
    func shouldNeverQuitFirstApp(_ appToNeverQuitBundle: String) {
        
        // First app changed. Update the list of apps to not quit.
        self.firstAppToNeverQuitBundle = shouldNeverQuitSelectedApp(appToNeverQuitBundle, self.firstAppToNeverQuitBundle)
    }
    
    func shouldNeverQuitSecondApp(_ appToNeverQuitBundle: String) {
        
        // Second app changed. Update the list of apps to not quit.
        self.secondAppToNeverQuitBundle = shouldNeverQuitSelectedApp(appToNeverQuitBundle, self.secondAppToNeverQuitBundle)
    }
    
    func shouldNeverQuitThirdApp(_ appToNeverQuitBundle: String) {
        
        // Third app changed. Update the list of apps to not quit.
        self.thirdAppToNeverQuitBundle = shouldNeverQuitSelectedApp(appToNeverQuitBundle, self.thirdAppToNeverQuitBundle)
    }
    
}
