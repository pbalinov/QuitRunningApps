//
//  SettingsView.swift
//  QuitRunningApps
//

import SwiftUI

struct SettingsView: View
{
    @EnvironmentObject var settingsModel: SettingsModel
    
    var body: some View
    {
        VStack(alignment: .leading)
        {
            Text("settings-general")
                .font(.headline)
                .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing]/*@END_MENU_TOKEN@*/)
            
            Toggle(isOn: $settingsModel.closeApp)
            {
                Text("settings-closeapp")
            }
            .padding(.all)
            
            Text("")
        }
        .padding(.all)
    }
}

struct SettingsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SettingsView()
    }
}
