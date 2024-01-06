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
                    print(Bundle.main.infoDictionary?["API_KEY"] as? String ?? "")
                }
        }
    }
}
