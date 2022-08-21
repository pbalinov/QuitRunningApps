//
//  Application.swift
//  QuitYourApps
//

import Foundation
import SwiftUI
import Cocoa

struct Application: Identifiable {
    let id: Int32           // Process ID
    let appName: String     // Localized App Name
    let appIcon: NSImage    // App Icon
    
    init(application: NSRunningApplication)
    {
        self.id = application.processIdentifier
        self.appName = application.localizedName!
        self.appIcon = application.icon!
    }
}
