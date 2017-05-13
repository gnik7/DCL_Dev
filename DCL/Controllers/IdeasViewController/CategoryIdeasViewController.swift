//
//  CategoryIdeasViewController.swift
//  DCL
//
//  Created by Nikita on 3/29/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit


class CategoryIdeasViewController: BaseMainViewController {
    
    @IBOutlet weak var collectionView   : UICollectionView!
    @IBOutlet weak var tableView        : UITableView!
    
    fileprivate var viewModel = CategoryViewViewModel()
    
    var dataSource      : [CategoryIdeaListItemModel]?
    var currentItem     : IdeaListItemModel?
    var tmpItem         : IdeaListItemModel?
    var itemsCollection : [IdeaListItemModel]?
    
    fileprivate let leftRightMargin = 15
    fileprivate let rowHeight: CGFloat = 225.0
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    fileprivate let minimumInteritemSpacing: CGFloat = 0
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupTable()
        setupCollectionView()
        
//        testData()
        
        if #available(iOS 10.0, *) {
            self.collectionView.isPrefetchingEnabled = false
        }
        viewModel.updateIdeasDataAction((currentItem?.id)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scroolToCenterCollection()
    }
    
    func testData(){
        
        
        let it1 = CategoryIdeaListItemModel()
        it1.id = 1
        it1.title = "Make a gingerbread house"
        it1.coverUrl = "https://develop.dcl.stagesrv.net/media/7/conversions/th_md.png"
        
        
        let it2 = CategoryIdeaListItemModel()
        it2.id = 2
        it2.title = "Pluck and eat fresh berries"
        it2.coverUrl = "https://develop.dcl.stagesrv.net/media/7/conversions/th_md.png"
        
        
        let it3 = CategoryIdeaListItemModel()
        it3.id = 3
        it3.title = "Bake an apple pie"
        it3.coverUrl = "https://develop.dcl.stagesrv.net/media/7/conversions/th_md.png"
        
        
        let it4 = CategoryIdeaListItemModel()
        it4.id = 4
        it4.title = "Make jelly bears"
        it4.coverUrl = "https://develop.dcl.stagesrv.net/media/7/conversions/th_md.png"
        
        
        let it5 = CategoryIdeaListItemModel()
        it5.id = 5
        it5.title = "Brew homemade beer"
        it5.coverUrl = "https://develop.dcl.stagesrv.net/media/7/conversions/th_md.png"
        
        
        let it6 = CategoryIdeaListItemModel()
        it6.id = 6
        it6.title = "Brew homemade beer 2"
        it6.coverUrl = "https://develop.dcl.stagesrv.net/media/7/conversions/th_md.png"
        
        
        dataSource = [it1,it2 , it3 , it4 , it5, it6]
        tableView.reloadData()
    }
    
    //*****************************************************************
    // MARK: - Setup UI
    //*****************************************************************
    
    private func setupTable() {
        dataSource = [CategoryIdeaListItemModel]()
        
        registrateCell()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
    
    private func registrateCell() {
        guard let cellNib = UIView.classNibFromString(className: CategoryIdeasTableViewCell.self) else {return}
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: CategoryIdeasTableViewCell.self))
    }
    
    private func registrateCollectionCell() {
        guard let cellNib = UIView.classNibFromString(className: CategoryIdeasCollectionViewCell.self) else {return}
        collectionView.register(cellNib, forCellWithReuseIdentifier: String(describing: CategoryIdeasCollectionViewCell.self))
    }
    
    private func setupCollectionView() {
        registrateCollectionCell()
   
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
    }
    
    fileprivate func scroolToCenterCollection(){
        guard let indexOfSelected = itemsCollection?.index(where: {($0.id)! == (self.currentItem?.id)!}) else{return}
        let indexPath = IndexPath(row: indexOfSelected, section: 0)
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        router.popViewController()
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        let user = UserProfileModel()
        user.id = UserModel.sharedInstance.id
        user.name = UserModel.sharedInstance.name
        user.photoUrl = UserModel.sharedInstance.photoUrl
        user.isNotifiable = UserModel.sharedInstance.isNotifiable
        router.showSettingViewController(user)
    }
    
    //*****************************************************************
    // MARK: - Setup Data
    //*****************************************************************
    
    func recievedData(items: [CategoryIdeaListItemModel]){
        if tmpItem != nil {
            currentItem = tmpItem
        }        
        if items.count > 0 {
            dataSource?.removeAll()
            tableView.reloadData()
            dataSource?.append(contentsOf: items)
            tableView.reloadData()
        }
        scroolToCenterCollection()
    }
}

extension CategoryIdeasViewController: UITableViewDataSource, UITableViewDelegate {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CategoryIdeasTableViewCell.self), for: indexPath) as? CategoryIdeasTableViewCell else {
            return UITableViewCell()
        }
        cell.setupData((dataSource?[indexPath.row])!)
        cell.delegate = self
        return cell
    }
    
    //*****************************************************************
    // MARK: - UITableViewDelegate
    //*****************************************************************
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}

extension CategoryIdeasViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //*****************************************************************
    // MARK: - UICollectionViewDataSource
    //*****************************************************************
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCollection?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryIdeasCollectionViewCell.self), for: indexPath) as? CategoryIdeasCollectionViewCell,
            let data = itemsCollection?[indexPath.row], let current = currentItem else {
                return UICollectionViewCell()
        }
        cell.updateData(current, data)
        cell.layoutIfNeeded()
        return cell
    }
    
    //*****************************************************************
    // MARK: - UICollectionViewDelegate
    //*****************************************************************
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel()
        label.font = UIFont(name: "SFUIDisplay-Medium", size: 16)
        label.text = itemsCollection?[indexPath.row].title
        label.sizeThatFits(CGSize(width: Int.max, height: Int.max))
        let labelSize: CGSize = label.intrinsicContentSize
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
        flowLayout.sectionInset = sectionInsets
        
        let sizeHeight = Int(collectionView.bounds.height)
        return CGSize(width: Int(labelSize.width * 1.1) + leftRightMargin * 2 , height: sizeHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = itemsCollection?[indexPath.row] else {return}
        tmpItem = item
        viewModel.updateIdeasDataAction(item.id!)
    }
}


extension CategoryIdeasViewController: CategoryIdeasTableViewCellDelegate {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    func addCategory(_ title: String, _ cover: UIImage) {
        guard let userId = UserModel.sharedInstance.id else { return }
        router.showAddGoalViewController(userId, title, cover)
    }
}


extension CategoryIdeasViewController: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){
    }
    
    func viewModelDidEndUpdate(){
    }
}



