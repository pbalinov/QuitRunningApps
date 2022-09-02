//
//  SettingsView.swift
//  QuitRunningApps
//
//  Created by Plamen Balinov on 2.09.22.
//

import SwiftUI

struct SettingsView: View
{
    var body: some View
    {
        VStack
        {
            Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                Text("Quit this app when all others are closed.")
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SettingsView()
    }
}
