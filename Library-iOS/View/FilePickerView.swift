//
//  FilePickerView.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/30.
//

import SwiftUI
import LinkPresentation

struct FilePickerView: View {
    @StateObject private var viewModel: FilePickerViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: FilePickerViewModel())
    }
    
    var body: some View {
        VStack {
            Button("Document Picker") {
                self.viewModel.showPicker.toggle()
            }
            .sheet(isPresented: $viewModel.showPicker, content: {
                DocumentPicker(filePathURL: $viewModel.filePathURL)
            })
            .padding()
            .foregroundColor(.blue)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5.0))

            Button("Share Pciker") {
                self.viewModel.showSharePicker.toggle()
            }.sheet(isPresented: $viewModel.showSharePicker, content: {
                SharePicker()
            })
            .padding()
            .foregroundColor(.blue)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
            
            Button("Document Interaction") {
                self.viewModel.showInteractionPicker.toggle()
            }.background(
                DocumentInteractionPicker($viewModel.showInteractionPicker, url: Bundle.main.url(forResource: "config", withExtension: "plist")!)
            )
            .padding()
            .foregroundColor(.blue)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
            
            Spacer()
        }
        .navigationTitle("File Picker")
        
    }
}

struct FilePickerView_Previews: PreviewProvider {
    static var previews: some View {
        FilePickerView()
    }
}

extension FilePickerView {
    @MainActor class FilePickerViewModel: ObservableObject {
        @Published public var filePathURL: URL?
        @Published var showPicker = false
        @Published var showSharePicker = false
        @Published var showInteractionPicker = false
    }
}

