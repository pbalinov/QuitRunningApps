//
//  QuitRunningApps.swift
//  QuitRunningApps
//

import SwiftUI

@main
struct QuitRunningApps: App
{
    var body: some Scene
    {
        WindowGroup
        {
            ApplicationView()
                .onAppear
                {
                    // Disable tab bar menu
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
        }
        .commands
        {
            CommandGroup(replacing: .newItem)
            {
                // Disable new window menu
            }
        }
    }
}

