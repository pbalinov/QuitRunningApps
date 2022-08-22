//
//  ContentView.swift
//  QuitYourApps
//

import SwiftUI

struct ApplicationView: View {
    
    // List of running applications
    @State private var applications: [Application] = []
    
    var body: some View {
        
        VStack {
            
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
                applications = await Application.LoadRunningApplications()
            }
            
            HStack {
                Spacer()
                Button("button-quit", action: {
                    return;
                })
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            
        }
            
        //.frame(minWidth: 400.0, maxWidth: .infinity, minHeight: 400.0, maxHeight: .infinity)
        .frame(width: 400.0, height: 400.0)
        
    }

}

struct ApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ApplicationView()
                .preferredColorScheme(.dark)
                .environment(\.locale, .init(identifier: "en"))
            ApplicationView()
                .preferredColorScheme(.light)
                .environment(\.locale, .init(identifier: "bg"))
        }
    }
}
