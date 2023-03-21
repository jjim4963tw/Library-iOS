//
//  ImagePickerView.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/31.
//

import SwiftUI

struct ImagePickerView: View {
    @StateObject private var viewModel: ImagePickerViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ImagePickerViewModel())
    }
    
    var body: some View {
        VStack {
            Button("Add Image") {
                self.viewModel.showPicker.toggle()
            }.sheet(isPresented: $viewModel.showPicker) {
                PhotoPicker(image: $viewModel.image, isPhotoLibraryAuthorized: $viewModel.isPhotoLibraryAuthorized)
            }
            
            Image(uiImage: self.viewModel.image ?? UIImage())
                .resizable()
            
            Spacer()
        }
        .navigationTitle("Image Picker")
    }
}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView()
    }
}


extension ImagePickerView {
    @MainActor class ImagePickerViewModel: ObservableObject {
        @Published public var image: UIImage?
        @Published var showPicker = false
        @Published var isPhotoLibraryAuthorized = false
    }
}

