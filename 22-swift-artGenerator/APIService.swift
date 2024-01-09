//
//  APIService.swift
//  22-swift-artGenerator
//
//  Created by Liu Ziyi on 7/1/24.
//

import SwiftUI

class APIService {
    let baseURL = "https://api.openai.com/v1/images/"
    let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
    
    func fetchImages(with data: Data) async throws -> ResponseModel {
        guard let apiKey else {
            fatalError("Could not get APIKey")
        }
        guard let url = URL(string: baseURL + "generations") else {
            fatalError("Error: Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse) != nil else {
            fatalError("Error: Data Request error")
        }
//        print(String(decoding: data, as: UTF8.self))
        do {
            return try JSONDecoder().decode(ResponseModel.self, from: data)
        } catch {
            throw error 
        }
    }
    
    func loadImage(at url: URL) async -> UIImage? {
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse) != nil else {
                fatalError("Error: Data Request error")
            }
            return UIImage(data: data)
        } catch {
            print(error.localizedDescription)
            return nil 
        }
    }
}
