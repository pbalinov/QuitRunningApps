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
                .frame(minWidth: ApplicationView.windowWidth, idealWidth: ApplicationView.windowWidth, maxWidth: .infinity, minHeight: ApplicationView.windowHeight, idealHeight: ApplicationView.windowHeight, maxHeight: .infinity, alignment: .center)
        }
        .commands
        {
            CommandGroup(replacing: .newItem)
            {
                // Disable new window menu
            }
            CommandGroup(replacing: .help)
            {
                Button(action: { /* Add help action here */ })
                {
                    Text("help-menu")
                }
            }
        }
        // macOS 13.0+ Beta
        //.defaultSize(CGSize(width: ApplicationView.windowWidth, height: ApplicationView.windowHeight))
    }
}

