//
//  FilePickerViewController.swift
//  Library-iOS
//
//  Created by jim on 2021/9/28.
//

import Foundation
import UIKit

class FilePickerViewController: BaseViewController {
    
    private var documentPicker: UIDocumentPickerViewController? = nil
    
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
