//
//  BaseViewController.swift
//  Library-iOS
//
//  Created by jim on 2021/9/28.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initContentView()
        self.initNavigationBar()
    }

    func initContentView() {
        
    }
    
    func initNavigationBar() {
        
    }
    
    func goPageFunction(storyboardName: String, storyboardID: String) {
        let targetStoryBoard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = targetStoryBoard.instantiateViewController(withIdentifier: storyboardID)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
