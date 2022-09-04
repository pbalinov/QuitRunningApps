//
//  SettingsView.swift
//  QuitRunningApps
//

import SwiftUI

struct SettingsView: View
{
    private let imageSize = 32.0
    private let windowWidth = CGFloat(400)
    
    @EnvironmentObject var settingsModel: SettingsModel
    
    var body: some View
    {
        HStack
        {
            Image("Settings")
        
            VStack(alignment: .leading)
            {
                Text("settings-general")
                    .font(.headline)
                                
                Toggle(isOn: $settingsModel.closeOurApp)
                {
                    Text("settings-closeapp")
                }
                
                Toggle(isOn: $settingsModel.closeFinder)
                {
                    Text("settings-finder")
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
            .environmentObject(SettingsModel())
    }
}
