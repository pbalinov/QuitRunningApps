//
//  ApplicationView.swift
//  QuitRunningApps
//

import SwiftUI
import Cocoa

struct ApplicationView: View
{
    // Main windows dimensions
    let windowWidth = CGFloat(400)
    let windowHeight = CGFloat(400)
    
    // List modifiers
    private let listBorderColor = Color(NSColor.separatorColor)
    private let listBorderWidth = CGFloat(1)
    
    // List of running applications
    @State private var applications: [Application] = []
    // Observer for change in running applications
    @State private var observers = [NSKeyValueObservation]()
    
    var body: some View
    {
        VStack
        {
            Text("text-list-running-apps")
                .padding()
            
            List(applications) { application in
                HStack {
                    Image(nsImage: application.appIcon)
                    Text(application.appName)
                }
            }
            .task
            {
                applications = Application.loadRunningApplications()
            }
            .border(listBorderColor, width: listBorderWidth)
            
            HStack
            {
                Spacer()
                Button("button-quit", action: {
                    return;
                })
                .buttonStyle(.borderedProminent)
                .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .bottom]/*@END_MENU_TOKEN@*/)
            }
        }
        .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
        .frame(minWidth: windowWidth, idealWidth: windowWidth, maxWidth: .infinity, minHeight: windowHeight, idealHeight: windowHeight, maxHeight: .infinity, alignment: Alignment.center)
        .onAppear()
        {
            self.observers =
            [
                NSWorkspace.shared.observe(\.runningApplications, options: [.initial])
                {
                    (model, change) in
                    // runningApplications changed and the list is updated
                    applications = Application.loadRunningApplications()
                }
            ]
        }
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
