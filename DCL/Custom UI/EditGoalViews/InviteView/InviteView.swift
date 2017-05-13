//
//  InviteView.swift
//  DCL
//
//  Created by Nikita on 2/17/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import MGSwipeTableCell

protocol InviteViewDelegate: class {
    func addAction(_ action: @escaping (([FriendItemModel]?)->()))
    func friendsAddedToGoal(_ message : String)
}


class InviteView: UIView {

    @IBOutlet weak var tableView        : UITableView!
    
    weak var delegate:  InviteViewDelegate?
    
    let viewModel = InviteViewViewModel()
    var currentGoal: HomeIdeasModelItem! 
    var invitedArray: [FriendItemModel]?
    let rowHeight: CGFloat = 47.0
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewModel.delegate = self
        setupTable()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    class func loadFromXib(bundle : Bundle? = nil) -> InviteView? {
        return UINib(
            nibName: String(describing: InviteView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InviteView
    }
    
    private func setupTable() {
        
        invitedArray = [FriendItemModel]()

        registrateCell()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = DefaultGradient.searchBarColor
        let footView = UIView()
        footView.backgroundColor = UIColor.clear
        tableView.tableFooterView = footView
    }
    
    private func registrateCell() {
        guard let cellNib = UIView.classNibFromString(className: InviteTableViewCell.self) else {return}
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: InviteTableViewCell.self))
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        guard let delegate = delegate else {return}
        delegate.addAction { [weak self] (friends) in
            
            guard let this = self, let goalId = this.currentGoal.id else {return}
            if (friends?.count)! > 0 {
                
            }
            var selectedPeople = [Int]()
            for item in friends! {
                selectedPeople.append(item.id!)
            }
            if selectedPeople.count > 0 {
                this.viewModel.sendInviteToGoal(goalId, selectedPeople)
            }
        }
    }
    
    //*****************************************************************
    // MARK: - Data
    //*****************************************************************

    func updateData(){
        invitedArray?.removeAll()
        invitedArray?.append(contentsOf: currentGoal.friends)
        tableView.reloadData()
    }
    
    fileprivate func deleteFriendFromGoal(_ friendId: Int, _ index: Int){
        guard let goalI = currentGoal.id else {return}
        viewModel.deleteFriend(goalI, friendId, index)
    }
    
    func deleteFriend(_ index: Int) {
        invitedArray?.remove(at: index)
        tableView.reloadData()
    }
    
    func friendsAdded(_ message: String){
        guard let delegate = delegate else {return}
        delegate.friendsAddedToGoal(message)
    }
}

extension InviteView: UITableViewDataSource, UITableViewDelegate {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitedArray?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InviteTableViewCell.self), for: indexPath) as? InviteTableViewCell else {
            return UITableViewCell()
        }
        cell.setupData(item: (invitedArray?[indexPath.row])!)
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

extension InviteView: MGSwipeTableCellDelegate{
    
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
        
        guard let friendId = invitedArray?[indexPath.row].id else {return true}
        deleteFriendFromGoal(friendId, index)
        return true
    }
}

extension InviteView: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){}
    
    func viewModelDidEndUpdate(){}
}

