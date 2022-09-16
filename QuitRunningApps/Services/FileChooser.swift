//
//  FileChooser.swift
//  QuitRunningApps
//

import Foundation
import SwiftUI

class FileChooser {
    
    func showFileChooserPanel() -> String {
        
        // Open file choose dialog
        // Allow only applications to be selected
        // Return application (file) name chosen
        // or "none" in case user pressed Cancel
        
        var fileName: String = Constants.File.none
        
        let panelBrowse = NSOpenPanel()
        panelBrowse.allowedContentTypes = [.application]
        panelBrowse.allowsMultipleSelection = false
        panelBrowse.canChooseDirectories = false
        
        if(panelBrowse.runModal() == .OK) {
            fileName = panelBrowse.url?.lastPathComponent ?? Constants.File.none
        }
        
        return fileName
    }
            
}
