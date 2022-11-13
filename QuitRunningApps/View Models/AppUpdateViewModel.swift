//
//  AppUpdateViewModel.swift
//  QuitRunningApps
//

import Foundation

@MainActor
class AppUpdateViewModel: ObservableObject {
    
    // Status text on main screen
    @Published var status: String
    // Setting for update checks
    private var checkForUpdate: Bool
    private var lastUpdateCheckDate: Date
    // Application version information data
    private var versions: [Version]
    
    init() {
        self.status = ""
        self.checkForUpdate = false
        self.lastUpdateCheckDate = Date.distantPast
        self.versions = [Version]()
    }
    
    func shouldCheckForNewApplicationVersion() -> Bool {
        
        // Check if the update settings are enabled
        // and compare last checked date with the current date
        
        // Check is globaly enabled
        if(!checkForUpdate) {
            return false
        }
        
        // Compare current date against last checked date
        let cal = Calendar.current
#if DEBUG
        // Always check in debug by adding 14 days in the past
        // to last update check date
        /*
        var dayComponent = DateComponents()
        dayComponent.day = { -2 * Constants.Update.periodBetweenChecks }()
        lastUpdateCheckDate = cal.date(byAdding: dayComponent, to: lastUpdateCheckDate)!
        */
#endif
        let daysBetween = cal.numberOfDaysBetween(lastUpdateCheckDate, Date.now)
        
        // Check the period between last check and now
        if(daysBetween <= Constants.Update.periodBetweenChecks) {
            return false
        }
        
        // Perform the update check
        return true
    }
    
    func loadVersionDataAndCheckForUpdate() async {
        
        // Status after checks
        var checkResult = ""
        
        do {
            // Connect to web site and load the JSON
            versions = try await WebService().loadVersionDataFromWeb(Constants.URLs.appVersion)
        } catch {
            // Failed to get the version info
            checkResult = NSLocalizedString("update-version-failed", comment: "")
#if DEBUG
            print("Update check failed. Error:")
            print(error)
#endif
        }
        
        // Compare results against current app version
        if(compareVersionData(versions)) {
            // Update is available
            let updateAvailable = NSLocalizedString("update-new-version", comment: "")
            checkResult = "[\(updateAvailable)](\(Constants.URLs.downloadsPage))"
        } else {
            // No new version
            checkResult = NSLocalizedString("update-no-new-version", comment: "")
        }
        
        // Update the main screen
        status = checkResult
    }
    
    func isAppCheckingForUpdates(_ checkForUpdate: Bool, _ lastUpdateCheckDate: Date) {
        
        // Application settings
        self.checkForUpdate = checkForUpdate
        self.lastUpdateCheckDate = lastUpdateCheckDate
        
#if DEBUG
        print("Automatic weekly check for updates is set to \(checkForUpdate).")
#endif
    }
    
    private func compareVersionData(_ versions: [Version]) -> Bool {
        
        // Compare app bundle version and build against
        // the version information
        
        if(versions.count == 0) {
            // No data in JSON
            return false
        }
        
        guard let appVersionFromBundle = Bundle.main.releaseVersionNumber else {
            // Failed to get the version
            return false
        }
        
        guard let appBuildFromBundle = Bundle.main.buildVersionNumber else {
            // Failed to get the build version
            return false
        }
        
        guard let appVersion = Decimal(string: appVersionFromBundle) else {
            // Failed to get the version
            return false
        }
        
        guard let appBuild = Int(appBuildFromBundle) else {
            // Failed to get the build version
            return false
        }
        
        // Check the first available record in results array
        if(appVersion < versions[0].version) {
            // Current app version is lower
            // Update available
            return true
        }

        if(appBuild < versions[0].build) {
            // Current app build is lower
            // Update available
            return true
        }
        
        return false
    }
    
}
