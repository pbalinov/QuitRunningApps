//
//  WebService.swift
//  QuitRunningApps
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
}

class WebService {
    
    func loadVersionDataFromWeb(_ url: URL) async throws -> [Version] {
        
        var versions: [Version] = []
        
        // Read the version info from the web
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // Decode the response
        if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
            // "versions" from JSON file
            versions = decodedResponse.versions
        }
        
        return versions
    }
    
}
