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
        var result = (file: "", bundle: "")
        result = selectApplicationToNeverQuit(firstAppToNeverQuit)
        self.firstAppToNeverQuit = result.file
        self.firstAppToNeverQuitBundle = result.bundle
    }
    
    func selectSecondApplicationToNeverQuit() {
        var result = (file: "", bundle: "")
        result = selectApplicationToNeverQuit(secondAppToNeverQuit)
        self.secondAppToNeverQuit = result.file
        self.secondAppToNeverQuitBundle = result.bundle
    }
    
    func selectThirdApplicationToNeverQuit() {
        var result = (file: "", bundle: "")
        result = selectApplicationToNeverQuit(thirdAppToNeverQuit)
        self.thirdAppToNeverQuit = result.file
        self.thirdAppToNeverQuitBundle = result.bundle
    }
    
    private func selectApplicationToNeverQuit(_ currentSelection: String) -> (String, String) {
        
        // Browse for application or delete
        // Return the application name and bundle identifier
        
        if(currentSelection != Constants.File.none) {
            // Delete
            return (Constants.File.none, "")
        }
        
        var result = (file: "", bundle: "")
        
        // Browse for application
        result = FileBrowser().showFileBrowserPanel()
        
        // Check if already selected
        if(validateSelectedApplication(result.file)) {
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
