//
//  AlertControllerUtility.swift
//  Library-iOS
//
//  Created by jim on 2021/9/28.
//

import Foundation
import UIKit

public class AlertControllerUtility {
    private static var instance : AlertControllerUtility?
    
    private var alert: UIAlertController?
    
    static func shareInstance() -> AlertControllerUtility {
        if instance == nil {
            instance = AlertControllerUtility()
        }
        return instance!
    }
    
    func showAlertController(viewController: UIViewController? = nil, title: String? = nil, message: String? = nil, style: UIAlertController.Style, needSuccessButton: Bool, needCancelButton: Bool, successTitle: String? = nil, successhandler:  ((UIAlertAction) -> Void)? = nil, cancelTitle: String? = nil, cancelhandler:  ((UIAlertAction) -> Void)? = nil) {
        self.alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        if needSuccessButton {
            let successText = successTitle ?? "Confirm"
            let successAction = UIAlertAction(title: successText, style: .default, handler: successhandler)
            self.alert!.addAction(successAction)
        }
        
        if needCancelButton {
            let cancelText = successTitle ?? "Cancel"
            let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: successhandler)
            self.alert!.addAction(cancelAction)
        }

        DispatchQueue.main.async {
            if viewController != nil {
                viewController?.present(self.alert!, animated: true, completion: nil)
            } else {
                var topRootViewController = UIApplication.keyWindow?.rootViewController
                while topRootViewController?.presentedViewController != nil {
                    topRootViewController = topRootViewController?.presentedViewController
                }
                topRootViewController?.present(self.alert!, animated: true, completion: nil)
            }
        }
    }
}
