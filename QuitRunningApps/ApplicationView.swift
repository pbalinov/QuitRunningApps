//
//  ApplicationView.swift
//  QuitRunningApps
//

import SwiftUI
import Cocoa

struct ApplicationView: View
{
    // ApplicationView dimensions
    static let windowWidth = CGFloat(400)
    static let windowHeight = CGFloat(400)
    // List modifiers
    static let listBorderColor = Color(NSColor.separatorColor)
    static let listBorderWidth = CGFloat(1)
    
    // Аpplications model 
    @StateObject private var appModel = ApplicationModel()
    // Disable quit apps button when closing runs
    @State private var isClosingRunning: Bool = false
    
    var body: some View
    {
        VStack
        {
            Text("text-list-running-apps")
                .padding()
            
            List(appModel.applications)
            {
                application in
                HStack
                {
                    Image(nsImage: application.appIcon)
                    Text(application.appName)
                    Spacer()
                }
            }
            .border(ApplicationView.listBorderColor, width: ApplicationView.listBorderWidth)
            .task
            {
                appModel.loadRunningApplications()
            }
            .onAppear()
            {
                appModel.registerObservers()
            }
            
            HStack()
            {
                Text(appModel.statusUpdates)
                    .padding(/*@START_MENU_TOKEN@*/[.top, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
                Spacer()
                Button("button-quit", action: {
                    isClosingRunning = true
                    appModel.closeRunningApplications()
                    isClosingRunning = false
                })
                .buttonStyle(.borderedProminent)
                .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .bottom]/*@END_MENU_TOKEN@*/)
                .disabled(isClosingRunning)
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
            
            ApplicationView()
                .preferredColorScheme(.light)
                .environment(\.locale, .init(identifier: "bg"))
        }
    }
}
