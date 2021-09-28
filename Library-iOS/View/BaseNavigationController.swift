//
//  BaseNavigationController.swift
//  Library-iOS
//
//  Created by jim on 2021/9/27.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background color
        self.view.backgroundColor = .white
        self.navigationBar.tintColor = .white
        
        // set root ViewController
        let rootViewController = UIStoryboard(name: "BaseView", bundle: nil)
            .instantiateViewController(withIdentifier: "BaseViewController") as! IndexViewController
        self.setViewControllers([rootViewController], animated: true)
        
        // set NavigationBar Style
        if #available(iOS 15.0, *) {
            let appearence = UINavigationBarAppearance()
            appearence.configureWithOpaqueBackground()
            appearence.backgroundColor = .blue
            appearence.titleTextAttributes = [.foregroundColor: UIColor.white]
            self.navigationBar.standardAppearance = appearence
            self.navigationBar.scrollEdgeAppearance = appearence
        } else {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            self.navigationController?.navigationBar.barTintColor = .blue
        }
    }
}
