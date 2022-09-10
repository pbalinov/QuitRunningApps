//
//  QuitRunningApps.swift
//  QuitRunningApps
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate
{
    // Close the application after last (only) window is closed
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool
    {
        return true
    }
    
    // Workaround for the window minimize and restore issue
    func applicationWillBecomeActive(_ notification: Notification)
    {
        (notification.object as? NSApplication)?.windows.first?.makeKeyAndOrderFront(self)
    }    
}

@main

struct QuitRunningApps: App
{
    // Apply workarounds via app delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Environment object for app settings, accessible to all views
    @StateObject var settingsModel = SettingsModel()

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
                .frame(minWidth: windowWidth, idealWidth: windowWidth, maxWidth: .infinity, minHeight: windowHeight, idealHeight: windowHeight, maxHeight: .infinity, alignment: .center)
                .environmentObject(settingsModel)
        }
        .commands
        {
            CommandGroup(replacing: .newItem)
            {
                // Disable new window menu
            }
            CommandGroup(replacing: .systemServices)
            {
                // Disable system services menu
            }
            CommandGroup(replacing: .pasteboard)
            {
                // Disable items in Edit menu
            }
            CommandGroup(replacing: .undoRedo)
            {
                // Disable items in Edit menu
            }
            CommandGroup(replacing: .help)
            {
                Button(action:
                {
                    openURL(userGuideURL)
                })
                {
                    Text("help-user-guide")
                }
                
                Button(action:
                {
                    openURL(webSiteURL)
                })
                {
                    Text("help-web-page")
                }
            }
            CommandGroup(after: .systemServices)
            {
                Button(action:
                {
                    // ToDo: Check for new version
                })
                {
                    Text("menu-updates")
                }
            }
            
        }
        // macOS 13.0+ Beta
        //.defaultSize(CGSize(width: windowWidth, height: windowHeight))
        
        Settings
        {
            SettingsView()
                .environmentObject(settingsModel)
        }
    }
}
