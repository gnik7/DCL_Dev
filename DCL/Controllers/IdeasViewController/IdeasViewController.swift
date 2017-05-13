//
//  IdeasViewController.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

class IdeasViewController: BaseMainViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var viewModel = IdeasViewViewModel()
    
    var dataSource: [IdeaListItemModel]?
    fileprivate let rowHeight: CGFloat = 125.0
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        viewModel.updateIdeasDataAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   
    }
    
    //*****************************************************************
    // MARK: - Setup UI
    //*****************************************************************
    
    private func setupTable() {
        dataSource = [IdeaListItemModel]()
        
        registrateCell()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
    
    private func registrateCell() {
        guard let cellNib = UIView.classNibFromString(className: MainIdeasTableViewCell.self) else {return}
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: MainIdeasTableViewCell.self))
    }

    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
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
    
    func recievedData(items: [IdeaListItemModel]){
        if items.count > 0 {
            dataSource?.removeAll()
            tableView.reloadData()
            dataSource?.append(contentsOf: items)
            tableView.reloadData()
        }
    }
}

extension IdeasViewController: UITableViewDataSource, UITableViewDelegate {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainIdeasTableViewCell.self), for: indexPath) as? MainIdeasTableViewCell else {
            return UITableViewCell()
        }
        cell.setupData((dataSource?[indexPath.row])!)
        return cell
    }
    
    //*****************************************************************
    // MARK: - UITableViewDelegate
    //*****************************************************************
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItem = dataSource?[indexPath.row]  else {
            return
        }
        router.showCategoryIdeasViewController(selectedItem, dataSource!)
    }
}

extension IdeasViewController: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){
    }
    
    func viewModelDidEndUpdate(){
    }
}


