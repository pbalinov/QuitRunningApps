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
                        .padding(.bottom, Constants.SettingsWindow.padding)
                    
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
                        .padding(.bottom, Constants.SettingsWindow.padding)
                    
                    Toggle(isOn: $settingsModel.checkForUpdates) {
                        Text("settings-weekly-updates")
                    }
                }
                
                Divider()
                    .frame(width: Constants.Divider.width, height: Constants.Divider.height)
                
                VStack(alignment: .leading) {
                    Text("settings-never-close")
                        .font(.headline)
                        .padding(.bottom, Constants.SettingsWindow.padding)
                    
                    HStack {
                        Button {
                            settingsModel.selectFirstApplicationToNeverQuit()
                        } label: {
                            settingsModel.setFileBrowserButtonName(settingsModel.firstAppToNeverQuit)
                        }
                        Text(settingsModel.firstAppToNeverQuit)
                        Spacer()
                    }
                    .padding(.bottom, Constants.SettingsWindow.paddingHStack)
                    
                    
                    HStack {
                        Button {
                            settingsModel.selectSecondApplicationToNeverQuit()
                        } label: {
                            settingsModel.setFileBrowserButtonName(settingsModel.secondAppToNeverQuit)
                        }
                        Text(settingsModel.secondAppToNeverQuit)
                        Spacer()
                    }
                    .padding(.bottom, Constants.SettingsWindow.paddingHStack)
                    
                    HStack {
                        Button {
                            settingsModel.selectThirdApplicationToNeverQuit()
                        } label: {
                            settingsModel.setFileBrowserButtonName(settingsModel.thirdAppToNeverQuit)
                        }
                        Text(settingsModel.thirdAppToNeverQuit)
                        Spacer()
                    }
                    .padding(.bottom, Constants.SettingsWindow.paddingHStack)
                }
            }
            .padding(.leading, Constants.MainWindow.padding)
        }
        .padding(.all)
    }

}

struct SettingsView_Previews: PreviewProvider
{
    static var previews: some View {
        
        SettingsView()
            .environmentObject(SettingsViewModel())            
    }
    
}
