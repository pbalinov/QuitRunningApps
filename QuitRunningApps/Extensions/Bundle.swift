//
//  Bundle.swift
//  QuitRunningApps
//

import Foundation

// Get the application version and build
// from the bundle
extension Bundle {
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
