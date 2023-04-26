//
//  Constants.swift
//  QuitRunningApps
//

import Foundation
import SwiftUI

struct Constants {
    
    struct URLs {
        // Web Site address
        static let webSite = URL(string: "https://quitrunningapps.infinityfreeapp.com/")!

        // User Guide
        static let userGuide = URL(string: "https://quitrunningapps.infinityfreeapp.com/user-guide/")!

        // JSON File with the latest app version
        static let appVersion = URL(string: "https://noavis-dev.eu/app-updates/versions.json")!
        
        // Downloads page
        static let downloadsPage = URL(string: "https://quitrunningapps.infinityfreeapp.com/download/")!
    }
    
    struct MainWindow {
        // Application window dimensions
        static let width = CGFloat(400)
        static let height = CGFloat(400)
        static let padding = CGFloat(8)
    }
    
    struct SettingsWindow {
        // Settings window dimensions
        static let width = CGFloat(360)
        static let height = CGFloat(360)
    }
    
    struct List {
        // List view modifiers
        static let borderColor = Color(NSColor.separatorColor)
        static let borderWidth = CGFloat(1)
    }
    
    struct Update {
        // Period between update checks in days
        static let periodBetweenChecks = 7
    }
    
    struct Bundles {
        // Bundle identifiers
        static let ourApp = "com.pbalinov.QuitRunningApps"
        static let finderApp = "com.apple.finder"
        static let xcodeApp = "com.apple.dt.Xcode"
    }
    
    struct Divider {
        // Divider modifiers
        static let width = CGFloat(200)
        static let height = CGFloat(16)
    }
    
    struct File {
        // File chooser
        static let none = NSLocalizedString("file-none", comment: "")
    }
    
}
