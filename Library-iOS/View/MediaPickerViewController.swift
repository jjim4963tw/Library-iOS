//
//  MediaPickerViewController.swift
//  Library-iOS
//
//  Created by jim on 2021/9/27.
//

import PhotosUI

/**
 * 1. Access Media Library Permission
 * 2. Get Photo Library Item
 */
class MediaPickerViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkMediaPermissionFunction()
    }
    
    override func initNavigationBar() {
        let createButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.createImageItemsFunction))
        
        self.title = "ImageLoader"
        self.navigationItem.rightBarButtonItems = [createButton]
    }
    
    /**
     * Open Album Items View
     */
    @objc func createImageItemsFunction() {
        var config = PHPickerConfiguration()
        
        // 設定使用者可選取幾張相片
        config.selectionLimit = 0
        
        // 設定顯示的媒體類型
        config.filter = .images
        
        let pickerView = PHPickerViewController.init(configuration: config)
        pickerView.delegate = self
        self.present(pickerView, animated: true, completion: nil)
    }
    
    /**
     * Check Media Library R/W Permission
     * @PHAccessLevel：.readWrite / AddOnly
     */
    func checkMediaPermissionFunction() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch (authorizationStatus) {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    if (status != .authorized && status != .limited) {
                        self.showNotPermissionAlertFunction()
                    }
                }
                break
            case .limited, .authorized:
                break
            default:
                self.showNotPermissionAlertFunction()
                break
        }
    }
    
    func showNotPermissionAlertFunction() {
        AlertControllerUtility.shareInstance().showAlertController(title: NSLocalizedString("alert_not_permission_title", comment: ""),
                                                                   message: NSLocalizedString("alert_not_permission_message", comment: ""), style: .alert,
                                                                   needSuccessButton: true, needCancelButton: false,
                                                                   successTitle: NSLocalizedString("alert_go_setting_button_text", comment: ""), successhandler: { action in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler:nil)
            }
        })
    }
}

extension MediaPickerViewController: PHPickerViewControllerDelegate {
    /**
     * PHPickerViewController Delegate：
     * which will be called whether the user chooses a photo or taps the Cancel button. So you need to dismiss the picker under all circumstances
     */
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) {
            for result in results {
               result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                  if let image = object as? UIImage {
                     DispatchQueue.main.async {
                        // Use UIImage
                        print("Selected image: \(image)")
                     }
                  }
               })
            }
        }
    }
}
