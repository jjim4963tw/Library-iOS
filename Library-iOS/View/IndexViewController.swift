//
//  ViewController.swift
//  Library-iOS
//
//  Created by jim on 2021/9/27.
//

import UIKit

class IndexViewController: BaseViewController {
    private let tableViewCellIdentifier: String = "TableViewCell"

    @IBOutlet weak var myTableView: UITableView!
    
    private var itemList: Array<String> = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemList.append("ImageLoader")
    }
    
    override func initContentView() {
        // 註冊 Cell
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.tableViewCellIdentifier)
        
        self.title = "Library"
    }
}

extension IndexViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = self.itemList[indexPath.row]
        
        switch (title) {
            case "ImageLoader":
                let targetStoryBoard = UIStoryboard(name: "ImagePicker", bundle: nil)
                let viewController = targetStoryBoard.instantiateViewController(withIdentifier: "MediaPickerViewController")
                self.navigationController?.pushViewController(viewController, animated: true)
                break
                
            default:
                break
        }
    }
}

extension IndexViewController: UITableViewDataSource {
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
