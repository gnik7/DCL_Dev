//
//  DetailGroupViewController.swift
//  DCL
//
//  Created by Nikita on 3/27/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class DetailGroupViewController: BaseMainViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLabel: UILabel!
    
    fileprivate var dataSource: [DetailGroupFriendItemModel]?
    fileprivate var model = AddFriendModel()
    
    var groupId: Int?
    private var detailData: DetailGroupModel?
    fileprivate var viewModel = DetailGroupViewModel()
   
    fileprivate let rowHeight: CGFloat = 250.0
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self        
        updateTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        guard let group = groupId else { return}
        updateData(group)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func subscribeForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    private func registrateCell() {
        guard let cellNib = UIView.classNibFromString(className: GroupDetailTableViewCell.self) else {return}
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: GroupDetailTableViewCell.self))
        guard let cellMediaNib = UIView.classNibFromString(className: GroupDetailMediaTableViewCell.self) else {return}
        tableView.register(cellMediaNib, forCellReuseIdentifier: String(describing: GroupDetailMediaTableViewCell.self))
    }
    
    private func updateTableView() {
        dataSource = [DetailGroupFriendItemModel]()
        
        registrateCell()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = DefaultGradient.searchBarColor
        
        tableView.estimatedRowHeight = rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        let footView = UIView()
        footView.backgroundColor = UIColor.clear
        tableView.tableFooterView = footView
    }
    
    private func updateUI() {
        guard let item = detailData else {return}
        groupTitleLabel.text = item.name ?? ""
        dataSource = item.friends
        tableView.reloadData()
    }
    
    //*****************************************************************
    // MARK: - Api Calls
    //*****************************************************************
    
    private func updateData(_ idGroup: Int) {
        viewModel.updateGroupInfoAction(idGroup)
    }
    
    func updateDetailData(_ item: DetailGroupModel) {
        detailData = item
        updateUI()
    }
    
    func deletedUser(_ userId: Int){
        guard let index = dataSource?.index(where: { $0.id == userId }) else{return}
        dataSource?.remove(at: index)
        tableView.reloadData()
        if userId == UserModel.sharedInstance.id {
            router.popViewController()
        }
    }
    
    func addFriendSent(_ message: String ){
        Alert.show(controller: self, title: AlertTitle.TitleCommon, message: message, action: nil)
    }
    
    func openHomeIdea(_ homeIdea: HomeIdeasModelItem) {
        self.router.showAchievedDetailsViewController(String(describing: DetailGroupViewController.self), item: homeIdea)
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    @IBAction func backButtonPressed(_ sender: UIButton) {
        router.popViewController()
    }
    
    @IBAction func addFriendsToGroupPressed(_ sender: UIButton) {
        router.showFindFriendsGroupViewController(goalId: nil, action: {[weak self] (friends) in
            guard let this = self else {return}

            this.model.titleGroup = this.detailData?.name
            this.model.id = this.detailData?.id
            
            var friendsIds = [Int]()
            
            for item in this.dataSource! {
                friendsIds.append(item.id!)
            }
            
            for item in friends {
                friendsIds.append(item.id!)
            }
            this.model.friends = friendsIds
            
            if friendsIds.count > 0 {
                this.viewModel.createNewGroupAction(item: this.model)
            }
        })
    }
}

extension DetailGroupViewController: UITableViewDataSource, UITableViewDelegate {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (dataSource?[section].goals.count)! > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GroupDetailTableViewCell.self), for: indexPath) as? GroupDetailTableViewCell else {
                return UITableViewCell()
            }
            cell.setupData((dataSource?[indexPath.section])!)
            cell.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GroupDetailMediaTableViewCell.self), for: indexPath) as? GroupDetailMediaTableViewCell else {
                return UITableViewCell()
            }
            cell.setupData((dataSource?[indexPath.section])!)
            cell.delegate = self
            return cell
        }
    }
    
    //*****************************************************************
    // MARK: - UITableViewDelegate
    //*****************************************************************
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension DetailGroupViewController: GroupDetailMediaTableViewCellDelegate {
    
    func groupDetailMediaTableView(cell: UITableViewCell, didSelectItem:DetailGroupGoalItemModel) {
        guard let itemID = didSelectItem.id else {
            return;
        }
        self.viewModel.homeIdeaBy(id: itemID)
    }
    
}

extension DetailGroupViewController: MGSwipeTableCellDelegate{
    
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
        guard let userId = (cell as! GroupDetailTableViewCell).currentItem.id, let groupId = self.groupId else {return true}
        viewModel.deleteUserFromGroupAction(groupId, userId)
        return true
    }
}


extension DetailGroupViewController: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){}
    
    func viewModelDidEndUpdate(){}
}

