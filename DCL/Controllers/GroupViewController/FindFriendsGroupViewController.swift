//
//  FindFriendsGroupViewController.swift
//  DCL
//
//  Created by Nikita on 3/15/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

fileprivate enum PeopleType {
    case Friends
    case AllUsers
    case Dream
}


class FindFriendsGroupViewController: BaseMainViewController {
    
    @IBOutlet weak var searchBar        : UISearchBar!
    @IBOutlet weak var tableView        : UITableView!
    
    @IBOutlet weak var friendsView      : UIView!
    @IBOutlet weak var inContactView    : UIView!
    
    @IBOutlet weak var friendsLabel     : UILabel!
    @IBOutlet weak var inContactLabel   : UILabel!
    
    @IBOutlet weak var inviteButton     : UIButton!
    
    var complitionHandler   : (([FriendItemModel]) -> ())?
    var goalId              : Int?
    
    var currentGoal                     : HomeIdeasModelItem!
    fileprivate var currentTypeUsers    : PeopleType!
    fileprivate var pagination          : PaginationModel?
    
    fileprivate var dataSource          : [FriendItemModel]?
    fileprivate var selectedDataSource  : [FriendItemModel]?
    
    fileprivate var viewModel = FindFriendsGroupViewViewModel()
    
    fileprivate let rowHeight: CGFloat = 44.0
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if goalId != nil {
            currentTypeUsers = PeopleType.Dream
        } else {
           currentTypeUsers = PeopleType.Friends
        }
        
        viewModel.delegate = self
        updateSearchBar()
        updateTableView()
        subscribeForKeyboardNotifications()
        updateAllFriends(1)
        updateButton(currentTypeUsers)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        changeTabView(friendsView, inContactView, friendsLabel, inContactLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        changeTabView(friendsView, inContactView, friendsLabel, inContactLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bordedViews()
    }
    
    private func subscribeForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        super.keyboardWillShow(notification)
        UIView.animate(withDuration: 0.5, animations: {
            
        }, completion: { (_) in
        })
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        super.keyboardWillHide(notification)
        UIView.animate(withDuration: 0.1, animations: {
            
        }, completion: { (_) in
        })
    }
    
    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    private func bordedViews() {
        inviteButton.makeRoundView()
    }
    
    private func updateButton(_ currentType:PeopleType) {
        if currentType == PeopleType.Friends {
            inviteButton.setTitle(DefaultText.inviteToGroupButton, for: UIControlState.normal)
        } else if currentType == PeopleType.Dream {
            inviteButton.setTitle(DefaultText.inviteToDreamButton, for: UIControlState.normal)
        } else {
            inviteButton.setTitle(DefaultText.inviteByEmailButton, for: UIControlState.normal)
        }
    }
    
    private func registrateCell() {
        guard let cellNib = UIView.classNibFromString(className: InviteFriendsTableViewCell.self) else {return}
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: InviteFriendsTableViewCell.self))
    }
    
    private func updateTableView() {
        dataSource = [FriendItemModel]()
        selectedDataSource = [FriendItemModel]()
        
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
    
    private func updateSearchBar() {
        searchBar.delegate = self
        searchBar.layer.borderColor = DefaultGradient.searchBarColor.cgColor
        searchBar.layer.borderWidth = 1.0
    }
    
    private func changeTabView(_ selectedView: UIView, _ unSelectedView: UIView, _ selectedLabel: UILabel, _ unSelectedLabel: UILabel) {
        selectedView.makeTopCornerRadius()
        selectedView.backgroundColor = DefaultGradient.searchBarColor
        unSelectedView.removeTopCornerRadius()
        unSelectedView.backgroundColor = UIColor.white
        selectedLabel.textColor = DefaultGradient.selectedTabBarColor
        unSelectedLabel.textColor = DefaultGradient.inviteFriendsTextColor
        selectedView.setNeedsDisplay()
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.gestureTap()
        router.popViewController()
    }
    
    @IBAction func friendsButtonPressed(_ sender: UIButton) {
        currentTypeUsers = PeopleType.Friends
        changeTabView(friendsView, inContactView, friendsLabel, inContactLabel)
        updateAllFriends(1)
        updateButton(currentTypeUsers)
        self.gestureTap()
    }
    
    @IBAction func inContactButtonPressed(_ sender: UIButton) {
        currentTypeUsers = PeopleType.AllUsers
        changeTabView(inContactView, friendsView, inContactLabel, friendsLabel)
        updateUsersApi(1)
        updateButton(currentTypeUsers)
        self.gestureTap()
    }
    
    @IBAction func inviteByEmailButtonPressed(_ sender: UIButton) {
        
        if currentTypeUsers == PeopleType.Friends || currentTypeUsers == PeopleType.Dream {
            
            for item in dataSource! {
                if item.isSelected {
                    selectedDataSource?.append(item)
                }
            }
            
            guard  let complition = complitionHandler else { return }
            router.popViewController()
            complition(selectedDataSource!)
            
        } else {
            guard let inviteView = InviteByEmailView.loadFromXib() else { return}
            inviteView.show {[weak self] (email) in
                guard let this = self else {return}
                if email.isEmpty {return}
                this.invateByEmailApi(email)
            }
        }
    }
    
    //*****************************************************************
    // MARK: - API Call
    //*****************************************************************
    
    fileprivate func updateAllFriends(_ page: Int, keyword: String = ""){
        viewModel.updateAllFriends(page: page, keyword:keyword, goalId: goalId)
    }
    
    func updateFriendsData(_ items: [FriendItemModel] , _ paginationApi:PaginationModel) {
        pagination = paginationApi
        let data = AllUsersListModel.convertToAlphabetic(items: items)
        if pagination?.currentPage == 1 {
            dataSource?.removeAll()
            tableView.reloadData()
        }
        dataSource?.append(contentsOf: data)
        tableView.reloadData()
    }
    
    fileprivate func updateUsersApi(_ page: Int, keyword: String = ""){
        viewModel.updateAllExcistingUsersAction(page: page, keyword:keyword)
    }
    
    func updateUsersData(_ items: [FriendItemModel], _ paginationApi:PaginationModel){
        let data = AllUsersListModel.convertToAlphabetic(items: items)
        dataSource?.removeAll()
        dataSource?.append(contentsOf: data)
        tableView.reloadData()
    }
    
    private func invateByEmailApi(_ email: String){
        viewModel.inviteByEmailAction(email)
    }
    
    func invateByEmailSend(){
        Alert.show(controller: self, title: AlertTitle.TitleCommon , message: AlertText.InviteWasSent , action: nil)
    }
    
    fileprivate func inviteToFriend(_ userId: Int) {
        viewModel.addToFriend(userId)
    }
    
    func inviteToFriendSent(_ message: String){
        Alert.show(controller: self, title: AlertTitle.TitleCommon , message: message, action: nil)
    }
}

extension FindFriendsGroupViewController: UISearchBarDelegate {
    
    //*****************************************************************
    // MARK: - UISearchBarDelegate
    //*****************************************************************
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        dataSource?.removeAll()
        tableView.reloadData()
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        dataSource?.removeAll()
        tableView.reloadData()
        pagination?.currentPage = 1
        if currentTypeUsers == .Friends || currentTypeUsers == .Dream  {
            updateAllFriends(1)
        } else if currentTypeUsers == .AllUsers {
            updateUsersApi(1)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0
        {
            print("Has clicked on clear !")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool  {
        
        let result = text.detectBackspacePressed()
        if result {
            if searchBar.text!.characters.count >= 0 {
                let newStr = String(searchBar.text!.characters.dropLast())
                if currentTypeUsers == PeopleType.AllUsers {
                    updateUsersApi(1, keyword: newStr)
                } else if currentTypeUsers == PeopleType.Friends || currentTypeUsers == PeopleType.Dream  {
                    updateAllFriends(1, keyword: newStr)
                }
            }
            return true
        }
        
        if text.characters.isEmpty || (text.trimmingCharacters(in: .whitespaces)).characters.count == 0  {
            return false
        }
        
        let fullString = searchBar.text! + text
        if currentTypeUsers == PeopleType.AllUsers {
            updateUsersApi(1, keyword: fullString)
        } else if currentTypeUsers == PeopleType.Friends || currentTypeUsers == PeopleType.Dream {
            updateAllFriends(1, keyword: fullString)
        }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension FindFriendsGroupViewController: UITableViewDataSource, UITableViewDelegate {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InviteFriendsTableViewCell.self), for: indexPath) as? InviteFriendsTableViewCell else {
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
        
        if currentTypeUsers == PeopleType.Friends || currentTypeUsers == PeopleType.Dream {
            guard let user = dataSource?[indexPath.row] else {return}
            user.isSelected = !user.isSelected
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        } else {
            
            guard let userId = dataSource?[indexPath.row].id,
                let isUserFriend = dataSource?[indexPath.row].isFriend /*,
                 let goalId = currentGoal.id*/ else {
                    return
            }
            
            if isUserFriend {
                
            } else {
                inviteToFriend(userId)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let lastRow = (dataSource?.count)! - 1
        
        if row == lastRow && pagination?.currentPage != pagination?.pages {
            if (pagination?.currentPage)! < (pagination?.pages)! {
                pagination?.currentPage = (self.pagination?.currentPage)! + 1
                if currentTypeUsers == PeopleType.AllUsers {
                    updateUsersApi((pagination?.currentPage)!)
                } else if currentTypeUsers == PeopleType.Friends {
                    updateAllFriends((pagination?.currentPage)!)
                }
            }
        }
    }
}

extension FindFriendsGroupViewController: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){}
    
    func viewModelDidEndUpdate(){}
}
