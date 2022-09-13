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
                
                Text("settings-updates")
                    .font(.headline)
                
                Toggle(isOn: $settingsModel.checkForUpdates) {
                    Text("settings-weekly-updates")
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
