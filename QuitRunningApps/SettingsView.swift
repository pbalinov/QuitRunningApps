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
            // Todo
            Image(systemName: "gearshape")
                .font(.system(size: imageSize))
            
            VStack(alignment: .leading)
            {
                Text("settings-general")
                    .font(.headline)
                
                Toggle(isOn: $settingsModel.closeOurApp)
                {
                    Text("settings-closeapp")
                }
            }
            .padding(.all)
            
        }
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .frame(width: windowWidth)
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
