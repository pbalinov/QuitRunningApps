//
//  Version.swift
//  QuitRunningApps
//

import Foundation

// Application version information
// JSON parser
// See App Updates \ versions.json

struct Response: Codable {
    var versions: [Version]
}

struct Version: Codable {
    var version: Decimal
    var build: Int
    var applicationId: String
    var applicationName: String
}
