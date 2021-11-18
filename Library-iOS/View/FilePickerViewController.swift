//
//  FilePickerViewController.swift
//  Library-iOS
//
//  Created by jim on 2021/9/28.
//

import Foundation
import UIKit
import LinkPresentation

class FilePickerViewController: BaseViewController {
    
    private var documentInteraction: UIDocumentInteractionController? = nil
    private var documentPicker: UIDocumentPickerViewController? = nil
    private var sharePicker: UIActivityViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initNavigationBar() {
        self.title = "FilePicker"

    }
    
    /**
     * UIDocumentPickerViewController：Open Select Item or Folder Path Picker
     */
    @IBAction func openFilePickerFunction(_ sender: Any) {
        if self.documentPicker == nil {
            self.documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        }
        self.documentPicker!.delegate = self
        self.present(self.documentPicker!, animated: true, completion: nil)
    }
    
    /**
     * UIActivityViewController：Open Share Picker, share data like string images...
     */
    @IBAction func openSharePickerFunction(_ sender: Any) {
        if self.sharePicker == nil {
            self.sharePicker = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        }
        
        self.present(self.sharePicker!, animated: true, completion: nil)
    }
    
    /**
     * UIDocumentInteractionController：Open  File Share View, share document or files like PDF
     */
    @IBAction func openDocumentInteractionFunction(_ sender: Any) {
        self.documentInteraction = UIDocumentInteractionController()
        self.documentInteraction!.url = NSURL.fileURL(withPath: Bundle.main.path(forResource: "Info", ofType: "plist")!)
        self.documentInteraction!.delegate = self
        
        let isOpen = self.documentInteraction!.presentOpenInMenu(from: self.view.bounds, in: self.view, animated: true)
        if !isOpen {
            print("open document error")
        }
    }
}

extension FilePickerViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            let isAccessing = url.startAccessingSecurityScopedResource()
            if isAccessing {
                print(url)
                
                url.stopAccessingSecurityScopedResource()
            }
        }
    }
}

extension FilePickerViewController: UIActivityItemSource {
    
    /**
     * 判斷分享目標的App 類型給予對應的值
     */
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType == .mail || activityType == .message || activityType == UIActivity.ActivityType(rawValue: "jp.naver.line.Share") {
            return "Message"
        }
        
        return "String"
    }
    
    /**
     * 返回的資料類型
     */
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "String"
    }
    
    /**
     * Email 的主旨
     */
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "Email Title"
    }
    
    /**
     * 設定Share Picker 時顯示的Title、SubTitle、Icon
     */
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

extension FilePickerViewController: UIDocumentInteractionControllerDelegate {
}
