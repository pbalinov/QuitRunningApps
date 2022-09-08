//
//  AppUpdateModel.swift
//  QuitRunningApps
//

import Foundation

class AppUpdateModel: ObservableObject
{
    @Published var status: String
    private var results: [Result]
    
    init()
    {
        status = ""
        results = [Result]()
    }
    
    func loadVersionData() async
    {
        guard let url = URL(string: jsonAppVersion) else
        {
            print("Invalid URL")
            return
        }
        
        do
        {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data)
            {
                await MainActor.run {
                    results = decodedResponse.results
                    print(results as Any)
                    status = "Update available."
                }
            }
        }
        catch
        {
            print("Invalid data")
        }
    }
}
