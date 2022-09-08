//
//  ApplicationView.swift
//  QuitRunningApps
//

import SwiftUI

struct ApplicationView: View
{
    // List modifiers
    private let listBorderColor = Color(NSColor.separatorColor)
    private let listBorderWidth = CGFloat(1)
    
    @StateObject private var appModel = ApplicationModel()
    @StateObject private var appUpdate = AppUpdateModel()
    @EnvironmentObject var settingsModel: SettingsModel
    
    var body: some View
    {
        VStack
        {
            Text("text-list-running-apps")
                .font(.headline)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            List(appModel.applications, id: \.self, selection: $appModel.selection)
            {
                application in
                HStack
                {
                    Image(nsImage: application.appIcon)
                    Text(application.appName)
                    Spacer()
                }
            }
            .border(listBorderColor, width: listBorderWidth)
            .task
            {
                appModel.loadRunningApplications()
            }
            .task
            {
                await appUpdate.loadVersionData()
            }
            .onAppear()
            {
                appModel.ourAppClosing(settingsModel.closeOurApp)
                appModel.finderAppClosing(settingsModel.closeFinder)
                appModel.registerObservers()
            }
            .onChange(of: settingsModel.closeOurApp) { newValue in
                appModel.ourAppClosing(newValue)
            }
            .onChange(of: settingsModel.closeFinder) { newValue in
                appModel.finderAppClosing(newValue)
                appModel.loadRunningApplications()
            }
            
            HStack()
            {
                Text(appUpdate.status)
                Spacer()
                Button("button-quit", action: {
                    appModel.closeRunningApplications()
                })
                .buttonStyle(.borderedProminent)
                .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .bottom]/*@END_MENU_TOKEN@*/)
            }
        }
        .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
    }
}

struct ApplicationView_Previews: PreviewProvider
{
    static var previews: some View
    {
        Group
        {
            ApplicationView()
                .preferredColorScheme(.dark)
                .environment(\.locale, .init(identifier: "en"))
                .environmentObject(SettingsModel())
            
            ApplicationView()
                .preferredColorScheme(.light)
                .environment(\.locale, .init(identifier: "bg"))
                .environmentObject(SettingsModel())
        }
    }
}
