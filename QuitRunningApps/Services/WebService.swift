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
        
        // Connect to web site and read version information JSON
        // Parse the JSON and return the result - versions
        
        var versions: [Version] = []
        
        let (data, response) = try await URLSession.shared.data(from: url)

#if DEBUG
        let str = String(decoding: data, as: UTF8.self)
        print(str)
#endif
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
            versions = decodedResponse.versions
        }
        
        return versions
    }
    
}
