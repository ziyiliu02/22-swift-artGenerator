//
//  ContentView.swift
//  22-swift-artGenerator
//
//  Created by Liu Ziyi on 6/1/24.
//

import SwiftUI

struct DALLEImagesView: View {
    @StateObject var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if !vm.urls.isEmpty {
                    HStack {
                        ForEach(vm.dallEImages) { dalleImage in
                            if let uiImage = dalleImage.uiImage {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .onTapGesture {
                                        vm.selectedImage = uiImage 
                                    }
                            } else {
                                ProgressView()
                                    .frame(width: 80, height: 80)
                            }
                        }
                    }
                }
                
                if !vm.fetching {
                    if !vm.urls.isEmpty {
                        Text("Select an image")
                    }
                    if let selectedImage = vm.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 256, height: 256)
                    }
                    if vm.urls.isEmpty {
                        Text("The more descriptive you can be, the better")
                        
                        TextField("Image Description....", text: $vm.prompt, axis: .vertical)
                            .showClearButton($vm.prompt)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                        
                        Form {
                            Picker("Style", selection: $vm.imageStyle) {
                                ForEach(ImageStyle.allCases, id: \.self) { imageStyle in
                                    Text(imageStyle.rawValue)
                                }
                            }
                            Picker("Image Medium", selection: $vm.imageMedium) {
                                ForEach(ImageMedium.allCases, id: \.self) { imageMedium in
                                    Text(imageMedium.rawValue)
                                }
                            }
                            Picker("Artist", selection: $vm.artist) {
                                ForEach(Artist.allCases, id: \.self) { artist in
                                    Text(artist.rawValue)
                                }
                            }
                            HStack {
                                Spacer()
                                Button("Fetch") {
                                    vm.fetchImages()
                                }
                                .disabled(vm.prompt.isEmpty)
                                .buttonStyle(.borderedProminent)
                            }
                            HStack {
                                Spacer()
                                if vm.urls.isEmpty || vm.selectedImage == nil {
                                    Image("Artist")
                                }
                                Spacer()
                            }
                        }
                    } else {
                        Text(vm.description)
                            .padding()
                        HStack {
                            if vm.selectedImage != nil {
                                Button("Get Variation") {
                                    vm.fetchVariations()
                                }
                            }
                            Button("Try another") {
                                vm.reset()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    Spacer()
                    FetchingView()
                    Spacer()
                }
                if vm.selectedImage == nil && !vm.urls.isEmpty {
                    Image("Artist")
                }
                Spacer()
            }
            .navigationTitle("Art Generator")
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
                if let selectedImage = vm.selectedImage {
                    ToolbarItem {
                        ShareLink(item: Image(uiImage: selectedImage),
                                  subject: Text("Generated Image"),
                                  message: Text(vm.description),
                                  preview: SharePreview(Text("Generated Image"), image: Image(uiImage: selectedImage)))
                    }
                }
            }
        }
    }
}

struct DALLEImagesView_Previews: PreviewProvider {
    static var previews: some View {
        DALLEImagesView()
    }
}
