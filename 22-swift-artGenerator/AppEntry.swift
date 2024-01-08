//
//  _2_swift_artGeneratorApp.swift
//  22-swift-artGenerator
//
//  Created by Liu Ziyi on 6/1/24.
//

import SwiftUI

@main
struct AppEntry: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
//                    print(Bundle.main.infoDictionary?["API_KEY"] as? String ?? "")
                    Task {
                        let sample = GenerationInput(prompt: "Man in a rowboat in the ocean in a storm similar to work by Van Gogh")
                        if let data = sample.encodedData {
                            try await APIService().fetchImages(with: data)
                        }
                    }
                }
        }
    }
}
