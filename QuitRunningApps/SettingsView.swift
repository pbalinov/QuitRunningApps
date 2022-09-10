//
//  SettingsView.swift
//  QuitRunningApps
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settingsModel: SettingsViewModel
    
    var body: some View {
        
        HStack {
            
            Image("Settings")
        
            VStack(alignment: .leading) {
                
                Text("settings-general")
                    .font(.headline)
                                
                Toggle(isOn: $settingsModel.closeOurApp) {
                    Text("settings-closeapp")
                }
                
                Toggle(isOn: $settingsModel.closeFinder) {
                    Text("settings-finder")
                }
                
                Text("")
                
                Text("Updates")
                    .font(.headline)
                
                Toggle(isOn: $settingsModel.checkForUpdates) {
                    Text("Check for updates weekly.")
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
        SettingsView()
            .environmentObject(SettingsViewModel())
    }
}
