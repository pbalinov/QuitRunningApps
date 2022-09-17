//
//  ApplicationView.swift
//  QuitRunningApps
//

import SwiftUI

struct ApplicationView: View {
    
    @StateObject private var appViewModel = ApplicationViewModel()
    @EnvironmentObject var appUpdateModel: AppUpdateViewModel
    @EnvironmentObject var settingsModel: SettingsViewModel
    @State private var onInitialLoad = true
    
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
                appViewModel.shouldCloseOurApp(settingsModel.closeOurApp)
                appViewModel.shouldCloseFinderApp(settingsModel.closeFinder)
                appViewModel.shouldNeverQuitFirstApp(settingsModel.firstAppToNeverQuitBundle)
                appViewModel.shouldNeverQuitSecondApp(settingsModel.secondAppToNeverQuitBundle)
                appViewModel.shouldNeverQuitThirdApp(settingsModel.thirdAppToNeverQuitBundle)
                
                appViewModel.registerObservers()
            }
            .onChange(of: settingsModel.closeOurApp) {
                _ in appViewModel.shouldCloseOurApp(settingsModel.closeOurApp)
            }
            .onChange(of: settingsModel.closeFinder) {
                _ in appViewModel.shouldCloseFinderApp(settingsModel.closeFinder)
            }
            .onChange(of: settingsModel.firstAppToNeverQuitBundle) {
                _ in appViewModel.shouldNeverQuitFirstApp(settingsModel.firstAppToNeverQuitBundle)
            }
            .onChange(of: settingsModel.secondAppToNeverQuitBundle) {
                _ in appViewModel.shouldNeverQuitSecondApp(settingsModel.secondAppToNeverQuitBundle)
            }
            .onChange(of: settingsModel.thirdAppToNeverQuitBundle) {
                _ in appViewModel.shouldNeverQuitThirdApp(settingsModel.thirdAppToNeverQuitBundle)
            }
            .task(id: settingsModel.closeFinder) {
                if(!onInitialLoad) {
                    appViewModel.applications = appViewModel.loadRunningApplications()
                }
            }
            .task(id: settingsModel.firstAppToNeverQuitBundle) {
                if(!onInitialLoad) {
                    appViewModel.applications = appViewModel.loadRunningApplications()
                }
            }
            .task(id: settingsModel.secondAppToNeverQuitBundle) {
                if(!onInitialLoad) {
                    appViewModel.applications = appViewModel.loadRunningApplications()
                }
            }
            .task(id: settingsModel.thirdAppToNeverQuitBundle) {
                if(!onInitialLoad) {
                    appViewModel.applications = appViewModel.loadRunningApplications()
                }
            }
            .task {
                appViewModel.applications = appViewModel.loadRunningApplications()
                onInitialLoad = false
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
            if(appUpdateModel.shouldCheckForNewApplicationVersion()) {
                await appUpdateModel.loadVersionDataAndCheckForUpdate()
                settingsModel.setLastUpdateCheckDate(Date.now)
            }
        }
        .onAppear() {
            appUpdateModel.isAppCheckingForUpdates(settingsModel.checkForUpdates, settingsModel.getLastUpdateCheckDate())
        }
        .onChange(of: settingsModel.checkForUpdates) {
            _ in appUpdateModel.isAppCheckingForUpdates(settingsModel.checkForUpdates, settingsModel.getLastUpdateCheckDate())
        }
    }
    
}

struct ApplicationView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ApplicationView()
            .environmentObject(SettingsViewModel())
            .environmentObject(AppUpdateViewModel())
    }
    
}
