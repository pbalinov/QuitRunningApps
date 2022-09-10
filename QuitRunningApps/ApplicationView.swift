//
//  ApplicationView.swift
//  QuitRunningApps
//

import SwiftUI

struct ApplicationView: View {
    
    @StateObject private var appViewModel = ApplicationViewModel()
    @EnvironmentObject var appUpdateModel: AppUpdateViewModel
    @EnvironmentObject var settingsModel: SettingsViewModel
    
    var body: some View {
        
        VStack {
            Text("text-list-running-apps")
                .font(.headline)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            List(appViewModel.applications, id: \.self, selection: $appViewModel.selection) {
                application in HStack {
                    Image(nsImage: application.appIcon)
                    Text(application.appName)
                    Spacer()
                }
            }
            .border(Constants.List.borderColor, width: Constants.List.borderWidth)
            .onAppear() {
                // Load settings
                appViewModel.shouldCloseOurApp(settingsModel.closeOurApp)
                appViewModel.shouldCloseFinderApp(settingsModel.closeFinder)
                
                // Start monitoring for app changes
                appViewModel.registerObservers()
            }
            // Set settings changes in view models
            .onChange(of: settingsModel.closeOurApp) {
                newValue in appViewModel.shouldCloseOurApp(newValue)
            }
            .onChange(of: settingsModel.closeFinder) {
                newValue in appViewModel.shouldCloseFinderApp(newValue)
            }
            .task(id: settingsModel.closeFinder) {
                // Load running applications
                appViewModel.applications = appViewModel.loadRunningApplications()
            }
            
            HStack()
            {
                Text(appUpdateModel.status)
                Spacer()
                Button("button-quit", action: {
                    appViewModel.closeRunningApplications()
                })
                .buttonStyle(.borderedProminent)
                .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .bottom]/*@END_MENU_TOKEN@*/)
            }
        }
        .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
        .task {
            // Check for update
            if(appUpdateModel.shouldCheckForNewApplicationVersion()) {
                await appUpdateModel.loadVersionDataAndCheckForUpdate()
                settingsModel.setLastUpdateCheckDate(Date.now)
            }
        }
        .onAppear() {
            // Load settings
            appUpdateModel.isAppCheckingForUpdates(settingsModel.checkForUpdates, settingsModel.getLastUpdateCheckDate())
        }
        .onChange(of: settingsModel.checkForUpdates) {
            newValue in appUpdateModel.isAppCheckingForUpdates(newValue, settingsModel.getLastUpdateCheckDate())
        }
    }
    
}

struct ApplicationView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            ApplicationView()
                .preferredColorScheme(.dark)
                .environment(\.locale, .init(identifier: "en"))
                .environmentObject(SettingsViewModel())
                .environmentObject(AppUpdateViewModel())
            
            ApplicationView()
                .preferredColorScheme(.light)
                .environment(\.locale, .init(identifier: "bg"))
                .environmentObject(SettingsViewModel())
                .environmentObject(AppUpdateViewModel())
        }
    }
    
}
