//
//  ViewController.swift
//  Library-iOS
//
//  Created by jim on 2021/9/27.
//

import UIKit

class BaseViewController: UIViewController {
    private let tableViewCellIdentifier: String = "TableViewCell"

    @IBOutlet weak var myTableView: UITableView!
    
    private var itemList: Array<String> = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initContentView()
        
        itemList.append("ImageLoader")
    }
    
    func initContentView() {
        // 註冊 Cell
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.tableViewCellIdentifier)
        
        self.title = "Library"
    }
}

extension BaseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = self.itemList[indexPath.row]
        
        switch (title) {
            case "ImageLoader":
                let controller = UIStoryboard(name: "ImagePicker", bundle: nil)
                    .instantiateViewController(withIdentifier: "ImagePickerViewController")
                self.navigationController?.pushViewController(controller, animated: true)
                break
                
            default:
                break
        }
    }
}

extension BaseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableViewCellIdentifier)!
        
        if #available(iOS 15.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = self.itemList[indexPath.row]
    //        content.image = UIImage(named: "test.png")
    //        content.secondaryText = "second Text"
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = self.itemList[indexPath.row]
        }
        
        return cell
    }
}
