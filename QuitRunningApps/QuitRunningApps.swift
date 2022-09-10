//
//  QuitRunningApps.swift
//  QuitRunningApps
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    // Close the application after last (only) window is closed
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    // Workaround for the window minimize and restore issue
    func applicationWillBecomeActive(_ notification: Notification) {
        (notification.object as? NSApplication)?.windows.first?.makeKeyAndOrderFront(self)
    }
    
}

@main
struct QuitRunningApps: App {
    
    // Apply workarounds via app delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Environment object for app settings, accessible to other views
    @StateObject var settingsModel = SettingsViewModel()
    
    // Environment object for app updates
    @StateObject var appUpdateModel = AppUpdateViewModel()

    var body: some Scene {
        
        Settings {
            SettingsView()
                .environmentObject(settingsModel)
        }
        
        WindowGroup {
            ApplicationView()
                .onAppear {
                    // Disable tab bar menu
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
                .frame(minWidth: Constants.Window.width, idealWidth: Constants.Window.width, maxWidth: .infinity, minHeight: Constants.Window.height, idealHeight: Constants.Window.height, maxHeight: .infinity, alignment: .center)
                .environmentObject(settingsModel)
                .environmentObject(appUpdateModel)
            
            
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                // Disable new window menu
            }
            CommandGroup(replacing: .systemServices) {
                // Disable system services menu
            }
            CommandGroup(replacing: .pasteboard) {
                // Disable items in Edit menu
            }
            CommandGroup(replacing: .undoRedo) {
                // Disable items in Edit menu
            }
            CommandGroup(replacing: .help) {
                Button(action: {
                    openURL(Constants.URLs.userGuide)
                }) {
                    Text("help-user-guide")
                }
                
                Button(action: {
                    openURL(Constants.URLs.webSite)
                }) {
                    Text("help-web-page")
                }
            }
            CommandGroup(after: .systemServices) {
                Button(action: {
                    // Check for update
                    Task {
                        await appUpdateModel.loadVersionDataAndCheckForUpdate()
                    }
                    settingsModel.setLastUpdateCheckDate(Date.now)
                }) {
                    Text("menu-updates")
                }
            }
        }
    }
    // macOS 13.0+ Beta
    //.defaultSize(CGSize(width: windowWidth, height: windowHeight))
    
}
