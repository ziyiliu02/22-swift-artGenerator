//
//  Model.swift
//  22-swift-artGenerator
//
//  Created by Liu Ziyi on 7/1/24.
//

import Foundation

enum Constants {
    static let imageSize = "256x256"
    static let n = 1
}

struct GenerationInput: Codable {
    var prompt: String
    var n = Constants.n
    var size = Constants.imageSize
    
    var encodedData: Data? {
        try? JSONEncoder().encode(self)
    }
}
