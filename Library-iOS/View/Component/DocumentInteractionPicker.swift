//
//  DocumentInteractionPicker.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/30.
//

import Foundation
import SwiftUI

struct DocumentInteractionPicker: UIViewControllerRepresentable {
    private var isActive: Binding<Bool>
    private let viewController = UIViewController()
    private let docController: UIDocumentInteractionController

    init(_ isActive: Binding<Bool>, url: URL) {
        self.isActive = isActive
        self.docController = UIDocumentInteractionController(url: url)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentInteractionPicker>) -> UIViewController {
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<DocumentInteractionPicker>) {
        if self.isActive.wrappedValue && docController.delegate == nil { // to not show twice
            docController.delegate = context.coordinator
            self.docController.presentPreview(animated: true)
        }
    }

    func makeCoordinator() -> Coordintor {
        return Coordintor(parent: self)
    }

    final class Coordintor: NSObject, UIDocumentInteractionControllerDelegate { // works as delegate
        let parent: DocumentInteractionPicker
        init(parent: DocumentInteractionPicker) {
            self.parent = parent
        }
        func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
            return parent.viewController
        }

        func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
            controller.delegate = nil // done, so unlink self
            parent.isActive.wrappedValue = false // notify external about done
        }
    }
}
