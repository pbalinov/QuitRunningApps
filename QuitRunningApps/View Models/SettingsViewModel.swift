//
//  SettingsViewModel.swift
//  QuitRunningApps
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    
    // Settings for closing the app after all others are closed
    // Stored in user defaults with closeApp key
    @AppStorage("closeOurApp") var closeOurApp = false
    @AppStorage("closeFinder") var closeFinder = false
    @AppStorage("checkForUpdates") var checkForUpdates = false
    @AppStorage("lastUpdateCheckDate") private var lastUpdateCheckDate: Date = Date.distantPast
    
    func setLastUpdateCheckDate(_ date: Date) {
        lastUpdateCheckDate = date
    }
    
    func getLastUpdateCheckDate() -> Date {
        return lastUpdateCheckDate
    }
    
}
