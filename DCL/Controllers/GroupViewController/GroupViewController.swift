//
//  GroupViewController.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class GroupViewController: BaseMainViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var dataSource: [GroupModelItem]?
    fileprivate var viewModel = GroupViewViewModel()
    
    fileprivate let rowHeight: CGFloat = 89.0
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTableView()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        updateAllGroups()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    private func registrateCell() {
        guard let cellNib = UIView.classNibFromString(className: GroupTableViewCell.self) else {return}
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: GroupTableViewCell.self))
    }
    
    private func updateTableView() {
        dataSource = [GroupModelItem]()
        
        registrateCell()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        let footView = UIView()
        footView.backgroundColor = UIColor.clear
        tableView.tableFooterView = footView
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        router.showAddGroupViewController(nil)
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
    // MARK: - API
    //*****************************************************************
    
    private func updateAllGroups(){
        viewModel.updateAllGroupsAction()
    }
    
    func updateAllGroupsData(_ items: [GroupModelItem]){
        dataSource?.removeAll()
        dataSource = items
        tableView.reloadData()
    }
    
    func removeGroup(_ items: [GroupModelItem]){
        dataSource?.removeAll()
        dataSource = items
        tableView.reloadData()
    }
}

extension GroupViewController: UITableViewDataSource, UITableViewDelegate {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GroupTableViewCell.self), for: indexPath) as? GroupTableViewCell else {
            return UITableViewCell()
        }
        cell.setupData((dataSource?[indexPath.row])!)
        cell.delegateGroup = self
        cell.delegate = self
        return cell
    }
    
    //*****************************************************************
    // MARK: - UITableViewDelegate
    //*****************************************************************
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension GroupViewController: MGSwipeTableCellDelegate{
    
    //*****************************************************************
    // MARK: - MGSwipeTableCellDelegate
    //*****************************************************************
    
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        
        if direction == .rightToLeft {
            
            let deleteButton = ClearButtonView.swipeButton(color: DefaultGradient.deleteCellColor  ,title: "", icon: #imageLiteral(resourceName: "delete_cell_home") , height: cell.bounds.size.height)
            return [ deleteButton]
        }
        return nil
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        if direction != .rightToLeft {
            return false
        }
        
        guard let table = tableView, let indexPath = table.indexPath(for: cell)  else {
            return true
        }
        
        guard let idGroup = dataSource?[indexPath.row].id else {
            return false
        }
        viewModel.deleteGroupAction(idGroup)
        
//        dataSource?.remove(at: index)
//        tableView.reloadData()
//     
        return true
    }
}

extension GroupViewController: GroupTableViewCellDelegate{
    
    //*****************************************************************
    // MARK: - GroupTableViewCellDelegate
    //*****************************************************************
    func groupNamePressed(_ item: GroupModelItem) {
        router.showChangeNameGroupViewController(item)
    }
    
    func groupDetailPressed(_ item: GroupModelItem) {
        guard let groupId = item.id else { return }
        router.showDetailGroupViewController(groupId)
    }
}


extension GroupViewController: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){}
    
    func viewModelDidEndUpdate(){}
}
