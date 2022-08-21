//
//  ApplicationModel.swift
//  QuitYourApps
//

import Foundation
import Cocoa

var applications: [Application] = LoadRunningApplications()

func LoadRunningApplications() -> [Application] {    
    let ws = NSWorkspace.shared
    let allRunningApps = ws.runningApplications
    var appsWithWindow: [Application] = []

    for currentApp in allRunningApps.enumerated()
    {
        let runningApp = allRunningApps[currentApp.offset]

        if(runningApp.activationPolicy == .regular)
        {
            appsWithWindow.append(Application(application: runningApp))
        }
    }
    
    return appsWithWindow
}
