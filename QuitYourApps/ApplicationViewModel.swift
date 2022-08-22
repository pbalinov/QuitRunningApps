//
//  ApplicationViewModel.swift
//  QuitYourApps
//

import Foundation

class ApplicationViewModel: ObservableObject {
    @Published var applications: [Application] = Application.LoadRunningApplications()
}
