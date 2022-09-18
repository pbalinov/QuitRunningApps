//
//  FileBrowser.swift
//  QuitRunningApps
//

import Foundation
import SwiftUI

class FileBrowser {
    
    func showFileBrowserPanel() -> (fileName: String, bundleId: String) {
        
        // Open file choose dialog
        // Allow only applications to be selected
        // Return application (file) name chosen
        // or "none" in case user pressed Cancel
        // Get bubdle identifier and return it too
        
        let panelBrowse = NSOpenPanel()
        panelBrowse.allowedContentTypes = [.application]
        panelBrowse.allowsMultipleSelection = false
        panelBrowse.canChooseDirectories = false
        
        if(panelBrowse.runModal() != .OK) {
            // Failed to show the panel
            return (Constants.File.none, "")
        }
        
        let fullPath = panelBrowse.url?.path
        
        if(!validateString(fullPath)) {
            // Failed to obtain full path
            return (Constants.File.none, "")
        }
        
        // Get the bundle Id from the full path
        let bundleId = getBundleIdentifier(fullPath!)
        
        let fileName = panelBrowse.url?.lastPathComponent ?? Constants.File.none
        
        return (fileName, bundleId)
    }

    func getBundleIdentifier(_ fullPath: String) -> String {
        
        // Obtain bundle Id from the full path to the application
        // return empty string if failed
        
        guard let bundle = Bundle(path: fullPath) else {
            // Failed to obtain bundle
            return ""
        }
        
        guard let bundleId = bundle.bundleIdentifier else {
            // Failed to read bundle Id
            return ""
        }
        
        return bundleId
    }
    
}
