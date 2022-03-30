//
//  SharePicker.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/30.
//

import Foundation
import SwiftUI
import LinkPresentation

struct SharePicker: UIViewControllerRepresentable {
    
    func makeCoordinator() -> SharePicker.Coordinator {
        return SharePicker.Coordinator(parent: self)
    }

    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SharePicker>) -> UIActivityViewController {
        let picker = UIActivityViewController(activityItems: [context.coordinator], applicationActivities: nil)
        return picker
    }

    func updateUIViewController(_ uiViewController: SharePicker.UIViewControllerType, context: UIViewControllerRepresentableContext<SharePicker>) {
        
    }
    
    class Coordinator: NSObject, UIActivityItemSource {
        var parent: SharePicker
        
        init(parent: SharePicker) {
            self.parent = parent
        }

        func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
            if activityType == .mail || activityType == .message || activityType == UIActivity.ActivityType(rawValue: "jp.naver.line.Share") {
                return "Message"
            }
            
            return "Others"
        }
        
        func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
            return "Others"
        }
        
        func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
            return "Email Title"
        }
        
        func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
            let metaData = LPLinkMetadata()
            metaData.title = "Share Title"
            metaData.originalURL = NSURL.fileURL(withPath: "Share Subtitle")
            
            if let icon = Bundle.main.icon {
                metaData.imageProvider = NSItemProvider(object: icon)
                metaData.iconProvider = NSItemProvider(object: icon)
            }
            
            return metaData
        }
    }
}

