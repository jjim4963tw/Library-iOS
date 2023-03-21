//
//  ImagePicker.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/31.
//

import Foundation
import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPhotoLibraryAuthorized: Bool
    
    func makeCoordinator() -> PhotoPicker.Coordinator {
        return PhotoPicker.Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> PHPickerViewController {
        context.coordinator.checkPhotoPermission()
        
        var config = PHPickerConfiguration()
        
        // 設定使用者可選取幾張相片
        config.selectionLimit = 0
        
        // 設定顯示的媒體類型
        config.filter = .images
        
        let pickerView = PHPickerViewController.init(configuration: config)
        pickerView.delegate = context.coordinator
        
        return pickerView
    }

    func updateUIViewController(_ uiViewController: PhotoPicker.UIViewControllerType, context: UIViewControllerRepresentableContext<PhotoPicker>) {
        
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate, PHPhotoLibraryChangeObserver {
        var parent: PhotoPicker
        
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        func photoLibraryDidChange(_ changeInstance: PHChange) {
            checkPhotoPermission()
        }

        /**
         * PHPickerViewController Delegate：
         * which will be called whether the user chooses a photo or taps the Cancel button. So you need to dismiss the picker under all circumstances
         */
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true) {
                for result in results {
                    if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                        result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                           if let image = object as? UIImage {
                              DispatchQueue.main.async {
                                  self.parent.image = image
                              }
                           }
                        })
                    }
                }
            }
        }
        
        func checkPhotoPermission() {
            DispatchQueue.main.async {
                switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
                case .notDetermined:
                    PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                        DispatchQueue.main.async {
                            if (status != .authorized && status != .limited) {
                                // 未允許
                                self.parent.isPhotoLibraryAuthorized = false
                            } else {
                                self.parent.isPhotoLibraryAuthorized = true
                            }
                        }
                    }
                case .limited, .authorized:
                    self.parent.isPhotoLibraryAuthorized = true
                default:
                    // 未允許
                    break
                }
            }
        }
    }
}
