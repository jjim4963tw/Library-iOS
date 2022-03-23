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
        self.navigationBar.setNavigationBarTheme()
    }
}
