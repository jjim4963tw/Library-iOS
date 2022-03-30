//
//  DocumentPicker.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/30.
//

import Foundation
import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var filePathURL: URL?
    
    func makeCoordinator() -> DocumentPicker.Coordinator {
        return DocumentPicker.Coordinator(parent: self)
    }

    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        picker.delegate = context.coordinator
        
        return picker
    }

    func updateUIViewController(_ uiViewController: DocumentPicker.UIViewControllerType, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.filePathURL = urls[0]
            print(urls[0].absoluteString)
        }
    }
    
}
