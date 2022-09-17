//
//  Version.swift
//  QuitRunningApps
//

import Foundation

struct Response: Codable {
    var versions: [Version]
}

struct Version: Codable {
    
    // Application version information
    // Mapped against App Updates \ versions.json
    
    var version: Decimal
    var build: Int
    var applicationId: String
    var applicationName: String
}
