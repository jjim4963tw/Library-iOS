//
//  SwitchGridorListViewController.swift
//  Library-iOS
//
//  Created by jim on 2021/11/18.
//

import UIKit

struct ListType {
    static let Type_List = 0
    static let Type_Grid = 1
}

class SwitchGridorListViewController: BaseViewController {
    private let listViewIdentifier = "ListViewIdentifier"
    private let gridViewIdentifier = "GridViewIdentifier"

    @IBOutlet weak var myCollectionView: UICollectionView!
    
    private var dataList = [String]()
    private var nowListType = ListType.Type_List
    private var isFinishingOrCancellingTransition = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 1...1000 {
            self.dataList.append("\(index)")
        }
        
        self.myCollectionView.reloadData()
    }
    
    override func initContentView() {
        super.initContentView()
        
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
        self.myCollectionView.alwaysBounceVertical = true;
        self.myCollectionView.register(UINib.init(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: listViewIdentifier)
        self.myCollectionView.register(UINib.init(nibName: "GridCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: gridViewIdentifier)
        self.myCollectionView.register(UINib.init(nibName: "HeaderCollectionViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
    }
    
    /**
        切換格狀顯示的按鈕
     */
    @objc func switchGridorListFunction() {
        if self.isFinishingOrCancellingTransition {
            return
        }
        
        self.isFinishingOrCancellingTransition = true
        self.nowListType = (self.nowListType == ListType.Type_List) ? ListType.Type_Grid : ListType.Type_List
        
        self.myCollectionView.startInteractiveTransition(to: self.getCollectionViewGridOrListTypeLayout()) { completed, finished in
            self.isFinishingOrCancellingTransition = false
            self.myCollectionView.setContentOffset(CGPoint.zero, animated: true)
        }
        self.myCollectionView.finishInteractiveTransition()
        self.myCollectionView.reloadData()
    }
    
    /**
        CollectionView：取得切換Grid或List 的Layout
     */
    func getCollectionViewGridOrListTypeLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        layout.scrollDirection = .vertical
        
        if self.nowListType == ListType.Type_List {
            layout.itemSize = CGSize(width: self.view.frame.size.width, height: 64)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        } else {
            layout.itemSize = CGSize(width: (self.view.frame.size.width - 80) / 2, height: (self.view.frame.size.height * 0.16))
            layout.minimumInteritemSpacing = 20
            layout.minimumLineSpacing = 20
        }
        
        return layout
    }
}

extension SwitchGridorListViewController: UICollectionViewDataSource {
    /**
     * Header / Footer UI
     */
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            // header
            var headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderCollectionViewCell
            if headerView == nil {
                headerView = HeaderCollectionViewCell()
            }
            
            headerView!.labelHeader.text = "header text"
            headerView!.switchButton.addTarget(self, action: #selector(self.switchGridorListFunction), for: .touchDown)
            
            return headerView!
        } else if kind == UICollectionView.elementKindSectionFooter {
            // footer
            return UICollectionReusableView()
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.nowListType == ListType.Type_List {
            var cell = self.myCollectionView.dequeueReusableCell(withReuseIdentifier: self.listViewIdentifier, for: indexPath) as? ListCollectionViewCell
            if cell == nil {
                cell = ListCollectionViewCell()
            }
            
            cell!.labelText.text = self.dataList[indexPath.row]
            
            return cell!
        } else {
            var cell = self.myCollectionView.dequeueReusableCell(withReuseIdentifier: self.gridViewIdentifier, for: indexPath) as? GridCollectionViewCell
            if cell == nil {
                cell = GridCollectionViewCell()
            }
            
            cell!.labelText.text = self.dataList[indexPath.row]
            
            return cell!
        }
    }
}

extension SwitchGridorListViewController: UICollectionViewDelegateFlowLayout {
    /**
     * Cell 的寬高
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let orientation = UIDevice.current.orientation
        
        if self.nowListType == ListType.Type_List {
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                return CGSize(width: self.view.safeAreaLayoutGuide.layoutFrame.size.width, height: 64)
            } else {
                return CGSize(width: self.view.frame.size.width, height: 64)
            }
        } else {
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    return CGSize(width: ((self.view.safeAreaLayoutGuide.layoutFrame.size.width - 50) / 4), height: ((self.view.safeAreaLayoutGuide.layoutFrame.size.width - 50) / 4))
                } else {
                    return CGSize(width: ((self.view.safeAreaLayoutGuide.layoutFrame.size.width - 45) / 3), height: ((self.view.safeAreaLayoutGuide.layoutFrame.size.width - 45) / 3))
                }
            } else {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    return CGSize(width: ((self.view.safeAreaLayoutGuide.layoutFrame.size.width - 40) / 3), height: ((self.view.safeAreaLayoutGuide.layoutFrame.size.width - 40) / 3))
                } else {
                    return CGSize(width: ((self.view.safeAreaLayoutGuide.layoutFrame.size.width - 30) / 2), height: ((self.view.safeAreaLayoutGuide.layoutFrame.size.width - 30) / 2))
                }
            }
        }
    }

    /**
     * Cell 間的最小間距
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if self.nowListType == ListType.Type_List {
            return 0
        } else {
            return 10
        }
    }
    
    /**
     * Cell 間的最小間距
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if self.nowListType == ListType.Type_List {
            return 0
        } else {
            return 10
        }
    }
    
    /**
     * Header 的寬高
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 44)
    }
    
    /**
     * Cell 的 pedding
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if self.nowListType == ListType.Type_List {
            return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
}


extension SwitchGridorListViewController: UICollectionViewDelegate {
    
}
