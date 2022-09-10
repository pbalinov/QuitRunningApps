//
//  SettingsModel.swift
//  QuitRunningApps
//

import Foundation
import SwiftUI

class SettingsModel: ObservableObject
{
    // Settings for closing the app after all others are closed
    // Stored in user defaults with closeApp key
    @AppStorage("closeOurApp") var closeOurApp = false
    @AppStorage("closeFinder") var closeFinder = false
    @AppStorage("checkForUpdates") var checkForUpdates = false
    @AppStorage("lastUpdateCheckDate") var lastUpdateCheckDate: Date = Date.distantPast
    
    func setLastUpdateCheckDate()
    {
        lastUpdateCheckDate = Date.now
    }
    
    func getLastUpdateCheckDate() -> Date
    {
        return lastUpdateCheckDate
    }
}
