//
//  Bundle.swift
//  QuitRunningApps
//

import Foundation

extension Bundle {
    
    // Get the application version and
    // build number from the bundle
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
}
