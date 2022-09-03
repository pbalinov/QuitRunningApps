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
    @AppStorage("closeApp") var closeApp = false
}
