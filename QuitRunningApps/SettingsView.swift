//
//  SettingsView.swift
//  QuitRunningApps
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settingsModel: SettingsViewModel
    
    var body: some View {
        
        HStack(alignment: .top) {
            
            Image("Settings")
                .padding(.vertical)
        
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    Text("settings-general")
                        .font(.headline)
                    
                    Toggle(isOn: $settingsModel.closeOurApp) {
                        Text("settings-closeapp")
                    }
                    
                    Toggle(isOn: $settingsModel.closeFinder) {
                        Text("settings-finder")
                    }
                }
                
                Divider()
                    .frame(width: Constants.Divider.width, height: Constants.Divider.height)
                
                VStack(alignment: .leading) {
                    Text("settings-updates")
                        .font(.headline)
                    
                    Toggle(isOn: $settingsModel.checkForUpdates) {
                        Text("settings-weekly-updates")
                    }
                }
                
                Divider()
                    .frame(width: Constants.Divider.width, height: Constants.Divider.height)
                
                VStack(alignment: .leading) {
                    Text("settings-never-close")
                        .font(.headline)
                    
                    HStack {
                        Button("file-select") {
                            settingsModel.firstFileToNeverQuit = FileChooser().showFileChooserPanel()
                        }
                        Text(settingsModel.firstFileToNeverQuit)
                        Spacer()
                    }
                    
                    HStack {
                        Button("file-select") {
                            settingsModel.secondFileToNeverQuit = FileChooser().showFileChooserPanel()
                        }
                        Text(settingsModel.secondFileToNeverQuit)
                        Spacer()
                    }
                    
                    HStack {
                        Button("file-select") {
                            settingsModel.thirdFileToNeverQuit = FileChooser().showFileChooserPanel()
                        }
                        Text(settingsModel.thirdFileToNeverQuit)
                        Spacer()
                    }
                }
            }
            .padding(.all)
        }
        .padding(.all)
    }
}

struct SettingsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        Group {
            SettingsView()
                .preferredColorScheme(.dark)
                .environment(\.locale, .init(identifier: "en"))
                .environmentObject(SettingsViewModel())
            
            SettingsView()
                .preferredColorScheme(.light)
                .environment(\.locale, .init(identifier: "bg"))
                .environmentObject(SettingsViewModel())
            
        }
    }
}
