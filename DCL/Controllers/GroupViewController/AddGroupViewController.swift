//
//  AddGroupViewController.swift
//  DCL
//
//  Created by Nikita on 3/15/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class AddGroupViewController: BaseMainViewController {
    
    @IBOutlet weak var tableView    : UITableView!
    @IBOutlet weak var groupView    : UIView!
    @IBOutlet weak var doneButton   : UIButton!
    
    @IBOutlet weak var addButtonBottomConstraint: NSLayoutConstraint!
    
    fileprivate var dataSource: [FriendItemModel]?
    
    var groupItem: GroupModelItem?
    
    private var groupCustomView : LoginTextFieldView?
    fileprivate var viewModel = AddGroupViewViewModel()
    fileprivate var model = AddFriendModel()
    fileprivate let rowHeight: CGFloat = 60.0
    private var beginHeight: CGFloat = 0.0
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        loadLoginPasswordView()
        subscribeForKeyboardNotifications()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        beginHeight = addButtonBottomConstraint.constant
        self.tabBarController?.tabBar.isHidden = true
        self.view.addGestureRecognizer(tapGesture)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func subscribeForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        super.keyboardWillShow(notification)
        
        addButtonBottomConstraint.constant = beginHeight + keyboardHeight
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        super.keyboardWillHide(notification)
        addButtonBottomConstraint.constant = beginHeight
    }
    
    //*****************************************************************
    // MARK: - Setup UI
    //*****************************************************************
    
    private func setupTable() {
        registrateCell()
        
        dataSource = [FriendItemModel]()
        model.friends = [Int]()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
    
    private func registrateCell() {
        guard let cellNib = UIView.classNibFromString(className: InviteTableViewCell.self) else {return}
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: InviteTableViewCell.self))
    }

    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    private func updateUiEdit(){
        
        guard let item = groupItem else {return}
        
        groupCustomView?.textField.text = item.name ?? ""
        dataSource = item.friends
        tableView.reloadData()
    }
    
    //*****************************************************************
    // MARK: - Load View
    //*****************************************************************
    
    private func loadLoginPasswordView() {
        
        // add email view textfield
        groupCustomView = LoginTextFieldView.loadFromXib()
        groupCustomView?.frame = CGRect(x: 0, y: 0, width: groupView.frame.size.width, height: groupView.frame.size.height)
        groupCustomView?.delegate = self
        groupCustomView?.updateUI(FieldType.GroupName, returnButtonType: UIReturnKeyType.done, keyboardEnable: true)
        groupView.addSubview(groupCustomView!)
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        router.showFindFriendsGroupViewController ( goalId: nil, action: {[weak self] (friends) in
            guard let this = self else {return}
            this.dataSource = friends
            this.tableView.reloadData()          
            
            for item in this.dataSource! {
                this.model.friends?.append(item.id!)
            }
        })
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        router.popViewController()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        let result = model.checkFields()
        if !result {return}
        doneButton.isUserInteractionEnabled = false
        saveGroup()
    }
    
    //*****************************************************************
    // MARK: - API
    //*****************************************************************
    
    private func saveGroup(){        
        viewModel.createNewGroupAction(item: model)
    }
    
    func saved(){
        doneButton.isUserInteractionEnabled = true
        router.popViewController()
    }
}

extension AddGroupViewController: LoginTextFieldViewDelegate {
    
    //*****************************************************************
    // MARK: - LoginTextFieldViewDelegate
    //*****************************************************************
    
    func enteredText(_ text: String, _ type: FieldType){
        model.titleGroup = text
    }
    
    func textFieldShouldReturnPressed(_ type: FieldType){
        if type == FieldType.GroupName {
            self.view.endEditing(true)
        }
    }
}

extension AddGroupViewController: UITableViewDataSource, UITableViewDelegate {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InviteTableViewCell.self), for: indexPath) as? InviteTableViewCell else {
            return UITableViewCell()
        }
        cell.setupData(item: (dataSource?[indexPath.row])!)
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

extension AddGroupViewController: MGSwipeTableCellDelegate{
    
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
        dataSource?.remove(at: indexPath.row)
        tableView.reloadData()
       
        return true
    }
}



extension AddGroupViewController: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){}
    
    func viewModelDidEndUpdate(){}
}
