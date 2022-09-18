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
    @AppStorage("firstAppToNeverQuit") var firstAppToNeverQuit = Constants.File.none
    @AppStorage("firstAppToNeverQuitBundle") var firstAppToNeverQuitBundle = ""
    @AppStorage("secondAppToNeverQuit") var secondAppToNeverQuit = Constants.File.none
    @AppStorage("secondAppToNeverQuitBundle") var secondAppToNeverQuitBundle = ""
    @AppStorage("thirdAppToNeverQuit") var thirdAppToNeverQuit = Constants.File.none
    @AppStorage("thirdAppToNeverQuitBundle") var thirdAppToNeverQuitBundle = ""
    
    func setLastUpdateCheckDate(_ date: Date) {
        lastUpdateCheckDate = date
    }
    
    func getLastUpdateCheckDate() -> Date {
        return lastUpdateCheckDate
    }
    
    func setFileBrowserButtonName(_ currentSelection: String) -> Image {
        
        // Set Browse or Delete button image
        
        if(currentSelection == Constants.File.none) {
            // Browse
            return Image(systemName: "plus.app")
        }
        else {
            // Delete
            return Image(systemName: "xmark.app")
        }
    }
    
    func selectFirstApplicationToNeverQuit() {
        
        let result = selectApplicationToNeverQuit(firstAppToNeverQuit)
        self.firstAppToNeverQuit = result.fileName
        self.firstAppToNeverQuitBundle = result.bundleId        
    }
    
    func selectSecondApplicationToNeverQuit() {
        
        let result = selectApplicationToNeverQuit(secondAppToNeverQuit)
        self.secondAppToNeverQuit = result.fileName
        self.secondAppToNeverQuitBundle = result.bundleId
    }
    
    func selectThirdApplicationToNeverQuit() {
        
        let result = selectApplicationToNeverQuit(thirdAppToNeverQuit)
        self.thirdAppToNeverQuit = result.fileName
        self.thirdAppToNeverQuitBundle = result.bundleId
    }
    
    private func selectApplicationToNeverQuit(_ currentSelection: String) -> (fileName: String, bundleId: String) {
        
        // Browse for application or delete
        // Return the application name and bundle identifier
        
        if(currentSelection != Constants.File.none) {
            // Delete
            return (Constants.File.none, "")
        }
        
        // Browse for application
        let result = FileBrowser().showFileBrowserPanel()
        
        // Check if already selected
        if(validateSelectedApplication(result.fileName)) {
            // Application already selected
            return (Constants.File.none, "")
        }
        
        return result
    }
    
    private func validateSelectedApplication(_ currentSelection: String) -> Bool {
        
        // Check if the application is already selected
        
        if(currentSelection == self.firstAppToNeverQuit) {
            return true
        }
        
        if(currentSelection == self.secondAppToNeverQuit) {
            return true
        }
        
        if(currentSelection == self.thirdAppToNeverQuit) {
            return true
        }
        
        return false
    }
    
}
