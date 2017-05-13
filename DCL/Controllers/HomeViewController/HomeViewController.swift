//
//  HomeViewController.swift
//  DCL
//
//  Created by Nikita on 2/9/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Kingfisher


class HomeViewController: BaseMainViewController {

    @IBOutlet weak var searchBar            : UISearchBar!
    @IBOutlet weak var tableView            : UITableView!
    @IBOutlet weak var profileImage         : UIImageView!
    @IBOutlet weak var notificationView     : UIView!
    @IBOutlet weak var notificationLabel    : UILabel!
    
    
    fileprivate var pagination : PaginationModel?
    var currentUser: UserProfileModel?
    fileprivate var currentType: SortViewType = SortViewType.SortByCreationDate
    
    fileprivate var viewModel = HomeViewModel()
    
    var itemsArray: [HomeIdeasModelItem]?
    fileprivate let rowHeight: CGFloat = 44.0
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self        
        updateSearchBar()
        setupTable()
        hideNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        viewModel.updateProfileAction()
        subscribeForKeyboardNotifications()
        itemsArray?.removeAll()
        tableView.reloadData()
        viewModel.updateListGoals(page: 1, sorting: currentType.rawValue)
        viewModel.updateNotificationCountAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        beginHeght = tableView.frame
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bordedViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //*****************************************************************
    // MARK: - Setup UI
    //*****************************************************************
    
    private func hideNotification(){
        notificationLabel.isHidden = true
        notificationView.isHidden = true
    }
    
    private func bordedViews(){
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        notificationView.layer.cornerRadius = notificationView.frame.size.height / 2
    }
    
    private func updateSearchBar() {
        searchBar.delegate = self
        searchBar.layer.borderColor = DefaultGradient.searchBarColor.cgColor
        searchBar.layer.borderWidth = 1.0
    }
    
    private func setupTable() {
        itemsArray = [HomeIdeasModelItem]()
        
        registrateCell()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()        
    }
    
    func updateUI(){
        
        notificationLabel.isHidden = true
        notificationView.isHidden = true
        
        guard let user = currentUser else { return }
        
        if let avatar = user.photoUrl  {
            if !avatar.isEmpty {
                profileImage.kf.setImage(with:  URL(string: avatar), placeholder: nil, options: [], progressBlock: nil, completionHandler: { (image, error, cache, url) in
                })
            }
        }        
    }
    
    private func registrateCell() {
        guard let cellNib = UIView.classNibFromString(className: HomeTableViewCell.self) else {return}
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: HomeTableViewCell.self))
    }
    
    private func subscribeForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        super.keyboardWillShow(notification)
        self.view.removeGestureRecognizer(tapGesture)
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func sortButtonPressed(_ sender: UIButton) {
        let sort = SortView.loadFromXib()
        sort?.show(currentType, action: {[weak self] (type) in
            guard let this = self else {return}
            this.currentType = type
            this.itemsArray?.removeAll()
            this.tableView.reloadData()
            this.viewModel.updateListGoals(page: 1, sorting: type.rawValue)
            print(type)
        })
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        hideKeyboard()
        guard let id = currentUser?.id else {return}
        router.showAddGoalViewController(id, nil, nil)
    }
    
    @IBAction func notificationButtonPressed(_ sender: UIButton) {
        hideKeyboard()
        router.showNotificationsViewController( nil )
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        hideKeyboard()
        guard let user = currentUser else { return }
        router.showSettingViewController(user)
    }
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        hideKeyboard()
        guard let user = currentUser else {return}
        router.showProfileViewController(user)
    }
    
    //*****************************************************************
    // MARK: - Setup Data
    //*****************************************************************

    func setupDataToTable(_ result: [HomeIdeasModelItem], _ paginationApi:PaginationModel ){
        pagination = paginationApi
        if pagination?.currentPage == 1 {
            itemsArray?.removeAll()
            tableView.reloadData()
        }
        itemsArray?.append(contentsOf: result)
        tableView.reloadData()
    }
    func deleteItemInTable(id: Int){
        guard let index = itemsArray?.index(where: { $0.id == id }) else{return}
        itemsArray?.remove(at: index)
        tableView.reloadData()
    }
    
    func updateCountIndicatorNotification(_ count: Int) {
        if count == 0 {
            notificationLabel.isHidden = true
            notificationView.isHidden = true
            notificationLabel.text = "\(count)"
        } else {
            notificationLabel.isHidden = false
            notificationView.isHidden = false
            notificationLabel.text = "\(count)"
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray?.count ?? 0
    }
 
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeTableViewCell.self), for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.setupData(item: (itemsArray?[indexPath.row])!)
        cell.delegate = self
        return cell
    }
    
    //*****************************************************************
    // MARK: - UITableViewDelegate
    //*****************************************************************
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItem = itemsArray?[indexPath.row], indexPath.row < (itemsArray?.count)!  else {
            return
        }
        self.hideKeyboard()
        router.showEditGoalViewController(item: selectedItem)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let lastRow = (itemsArray?.count)! - 1
        
        if row == lastRow && pagination?.currentPage != pagination?.pages {
            if (pagination?.currentPage)! < (pagination?.pages)! {
                pagination?.currentPage = (self.pagination?.currentPage)! + 1
                viewModel.updateListGoals(page: (pagination?.currentPage)!, sorting: currentType.rawValue)
            }
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    //*****************************************************************
    // MARK: - UISearchBarDelegate
    //*****************************************************************
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        tmpView = tableView
        additionalHeigh = 55.0
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        itemsArray?.removeAll()
        tableView.reloadData()
        viewModel.updateListGoals(page: 1)
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
                viewModel.updateListGoals(page: 1, sorting: "", keyword: newStr)
            }
            return true
        }
        
        if text.characters.isEmpty || (text.trimmingCharacters(in: .whitespaces)).characters.count == 0  {
            return false
        }
        let fullString = searchBar.text! + text
        itemsArray?.removeAll()
        tableView.reloadData()
        viewModel.updateListGoals(page: 1, sorting: "", keyword: fullString)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: MGSwipeTableCellDelegate{
    
    //*****************************************************************
    // MARK: - MGSwipeTableCellDelegate
    //*****************************************************************
    
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        
        if direction == .rightToLeft {
            (cell as! HomeTableViewCell).mainView.layer.cornerRadius = 0
            let deleteButton = CellButtonView.swipeButton(color: DefaultGradient.deleteCellColor  ,title: "", icon: #imageLiteral(resourceName: "delete_cell_home") , height: cell.bounds.size.height)
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
        guard let goalId = itemsArray?[indexPath.row].id else {return true}
        viewModel.currentId = goalId
        viewModel.deleteGoalItem(itemId: goalId)
        return true
    }
}

extension HomeViewController: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){
    }
    
    func viewModelDidEndUpdate(){
    }
}

