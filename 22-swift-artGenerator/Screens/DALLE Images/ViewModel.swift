//
//  ViewModel.swift
//  22-swift-artGenerator
//
//  Created by Liu Ziyi on 9/1/24.
//

import SwiftUI 

@MainActor
class ViewModel: ObservableObject {
    @Published var prompt = ""
    @Published var urls: [URL] = []
    @Published var dallEImages: [DalleImage] = []
    @Published var fetching = false
    @Published var selectedImage: UIImage?
    
    @Published var imageStyle = ImageStyle.none
    @Published var imageMedium = ImageMedium.none
    @Published var artist = Artist.none
    
    var description: String {
        let characteristics = imageStyle.description + imageMedium.description + artist.description
        return prompt + (!characteristics.isEmpty ? "\n- " + characteristics : "")
    }
    
    let apiService = APIService()
    
    func clearProperties() {
        urls = []
        dallEImages.removeAll()
        for _ in 1...Constants.n {
            dallEImages.append(DalleImage())
        }
        selectedImage = nil 
    }
    
    func reset() {
        clearProperties()
        imageStyle = .none
        imageMedium = .none
        artist = .none
    }
    
    init() {
        clearProperties()
    }
    
    func fetchImages() {
        clearProperties()
        withAnimation {
            fetching.toggle()
        }
        let generationInput = GenerationInput(prompt: description)
        Task {
            if let data = generationInput.encodedData {
                do {
                    let response = try await apiService.fetchImages(with: data)
                    for data in response.data {
                        urls.append(data.url)
                    }
                    withAnimation {
                        fetching.toggle()
                    }
                    for (index, url) in urls.enumerated() {
                        dallEImages[index].uiImage = await apiService.loadImage(at: url)
                    }
                } catch {
                    print(error.localizedDescription)
                    fetching.toggle()
                }
            }
        }
    }
    
    func fetchVariations() {
        if let selectedImage {
            fetching.toggle()
            guard let imageData = selectedImage.pngData() else {
                return
            }
            clearProperties()
            Task {
                do {
                    let formdataFields: [String : Any] = ["n": Constants.n, "size": Constants.imageSize]
                    let response = try await apiService.getVariations(formDataField: formdataFields,
                                                                      fieldName: "image",
                                                                      fileName: "Selected Image",
                                                                      fileData: imageData)
                    for data in response.data {
                        urls.append(data.url)
                    }
                    withAnimation {
                        fetching.toggle()
                    }
                    for (index, url) in urls.enumerated() {
                        dallEImages[index].uiImage = await apiService.loadImage(at: url)
                    }
                } catch {
                    print(error.localizedDescription)
                    fetching.toggle()
                }
            }
        }
    }
}
