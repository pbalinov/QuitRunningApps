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
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

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
                    openURL(helpURL)
                })
                {
                    Text("help-menu")
                }
            }
        }
        // macOS 13.0+ Beta
        //.defaultSize(CGSize(width: ApplicationView.windowWidth, height: ApplicationView.windowHeight))
    }
}
