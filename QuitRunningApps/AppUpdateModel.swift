//
//  AppUpdateModel.swift
//  QuitRunningApps
//

import Foundation

class AppUpdateModel: ObservableObject
{
    // Status text on main screen
    @Published var status: String
    // Setting for update checks
    private var checkForUpdates: Bool
    private var lastUpdateCheckDate: Date
    // Application version information JSON data
    private var results: [Result]
    
    init()
    {
        self.status = ""
        self.results = [Result]()
        self.checkForUpdates = false
        self.lastUpdateCheckDate = Date.distantPast
    }
    
    // Check if the update settings are enabled
    // and compare last checked date with the current date
    func shouldCheckForNewApplicationVersion() -> Bool
    {
        // Check is globaly enabled
        if(!checkForUpdates)
        {
            return false
        }
        
        // Compare current date against last checked date
        let cal = Calendar.current
#if DEBUG
        // Always check in debug by adding 14 days in the past
        // to last update check date
        /*
        var dayComponent = DateComponents()
        dayComponent.day = { -2 * appUpdatesPeriod }()
        lastUpdateCheckDate = cal.date(byAdding: dayComponent, to: lastUpdateCheckDate)!
        */
#endif
        let daysBetween = cal.numberOfDaysBetween(lastUpdateCheckDate, Date.now)
        
        // Check the period between last check and now
        if(daysBetween <= appUpdatesPeriod)
        {
            return false
        }
        
        // Perform the update check
        return true
    }
    
    func loadVersionDataAndCheckForUpdate() async
    {
        // Location of the version information JSON file
        guard let url = URL(string: appVersionURL) else
        {
            return
        }
        
        // Status after checks
        var checkResult = ""
        
        do
        {
            // Read the version info
            let (data, _) = try await URLSession.shared.data(from: url)

            // Decode the response
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data)
            {
                // Results
                results = decodedResponse.results
                
                // Compare results against current app version
                if(compareVersionData(results))
                {
                    // Update is available
                    checkResult = NSLocalizedString("update-new-version", comment: "")
                }
                else
                {
                    // No new version
                    checkResult = NSLocalizedString("update-no-new-version", comment: "")
                }
                
                
            }
        }
        catch
        {
            // Failed to get the version info
            checkResult = NSLocalizedString("update-version-failed", comment: "")
#if DEBUG
            print("Update check failed. Error:")
            print(error)
#endif
        }
        
        // Status after checks
        let checkStatus = checkResult
        
        await MainActor.run
        {
            // Update the main screen
            status = checkStatus
        }
    }
    
    func isAppCheckingForUpdates(_ check: Bool, _ checkedDate: Date)
    {
        checkForUpdates = check
        lastUpdateCheckDate = checkedDate
    }
    
    // Compare app bundle version and build against
    // the version information in the JSON file
    func compareVersionData(_ results: [Result]) -> Bool
    {
        if(results.count == 0)
        {
            // No data in JSON
            return false
        }
        
        guard let appVersionFromBundle = Bundle.main.releaseVersionNumber else
        {
            // Failed to get the version
            return false
        }
        
        guard let appBuildFromBundle = Bundle.main.buildVersionNumber else
        {
            // Failed to get the build version
            return false
        }
        
        guard let appVersion = Decimal(string: appVersionFromBundle) else
        {
            // Failed to get the version
            return false
        }
        
        guard let appBuild = Int(appBuildFromBundle) else
        {
            // Failed to get the build version
            return false
        }
        
        // Check the first available record in results array
        
        if(appVersion < results[0].version)
        {
            // Current app version is lower
            // Update available
            return true
        }

        if(appBuild < results[0].build)
        {
            // Current app build is lower
            // Update available
            return true
        }
        
        return false
    }
}
