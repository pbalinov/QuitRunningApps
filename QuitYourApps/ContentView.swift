//
//  ContentView.swift
//  QuitYourApps
//

import SwiftUI

struct ContentView: View {
    
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
    
    // On button Quit clicked
    func OnButtonQuitClicked() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
                .environment(\.locale, .init(identifier: "en"))
            ContentView()
                .preferredColorScheme(.light)
                .environment(\.locale, .init(identifier: "bg"))
        }
    }
}
