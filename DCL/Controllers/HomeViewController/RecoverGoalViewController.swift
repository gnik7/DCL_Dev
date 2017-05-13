//
//  RecoverGoalViewController.swift
//  DCL
//
//  Created by Nikita on 3/1/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit


class RecoverGoalViewController: BaseMainViewController {
    
    @IBOutlet weak var tableView        : UITableView!
    @IBOutlet weak var recoverButton    : UIButton!
    
    @IBOutlet weak var tableViewHeightConstrain: NSLayoutConstraint!
    
    fileprivate var pagination : PaginationModel?
    fileprivate var itemsArray: [HomeIdeasModelItem]?
    fileprivate var viewModel = RecoverGoalViewModel()
    fileprivate let rowHeight: CGFloat = 44.0
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        setupTable()
        updateAllDeleteGoals(1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bordedViews()
    }
        
    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    private func bordedViews() {
        recoverButton.makeRoundView()
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

    private func registrateCell() {
        guard let cellNib = UIView.classNibFromString(className: RecoverGoalTableViewCell.self) else {return}
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: RecoverGoalTableViewCell.self))
    }
    
    private func updateTableView(){
        tableView.reloadData()
        tableView.layoutIfNeeded()        
        tableViewHeightConstrain.constant = tableView.contentSize.height
    }
  
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func recoverButtonPressed(_ sender: UIButton) {
        selectedItemsToRestore()
        recoverButton.isUserInteractionEnabled = false
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        router.popViewController()
    }
   
    //*****************************************************************
    // MARK: - API Call
    //*****************************************************************
    
    fileprivate func updateAllDeleteGoals(_ page: Int) {
        viewModel.updateListDeletedGoals(page: page)
    }
    
    func listAllDeleteGoals(_ result: [HomeIdeasModelItem], _ paginationApi:PaginationModel ) {
        pagination = paginationApi
        itemsArray?.append(contentsOf: result)
        tableView.reloadData()
    }
    
    private func selectedItemsToRestore() {
        var selectedArray = [Int]()
        
        for item in itemsArray! {
            if item.stateCell == true {
                selectedArray.append(item.id!)
            }
        }        
        viewModel.restoreGoals(selectedArray)
    }
    
    func listRestoredDeleteGoals(_ result: [HomeIdeasModelItem] ) {
        recoverButton.isUserInteractionEnabled = true
        pagination?.currentPage = 1
        pagination?.offset = 1
        pagination?.pages = 1
        itemsArray?.removeAll()
        itemsArray = result
        tableView.reloadData()
        
        guard let motivView = MotivateView.loadFromXib() else { return }
        motivView.show(DefaultText.RestoreGoalTitle, DefaultText.RestoreGoalMessage, DefaultText.RestoreGoalButton)
    }
}

extension RecoverGoalViewController: UITableViewDataSource, UITableViewDelegate {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecoverGoalTableViewCell.self), for: indexPath) as? RecoverGoalTableViewCell else {
            return UITableViewCell()
        }
        cell.setupData(item: (itemsArray?[indexPath.row])!)
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
        
        selectedItem.stateCell = !selectedItem.stateCell
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let lastRow = (itemsArray?.count)! - 1
        
        if row == lastRow && pagination?.currentPage != pagination?.pages {
            if (pagination?.currentPage)! < (pagination?.pages)! {
                pagination?.currentPage = (self.pagination?.currentPage)! + 1
                viewModel.updateListDeletedGoals(page: (pagination?.currentPage)!)
            }
        }
    }
}


extension RecoverGoalViewController: ViewModelDelegate {
    
    //*****************************************************************
    // MARK: - ViewModelDelegate
    //*****************************************************************
    
    func viewModelDidStartUpdate(){
    }
    
    func viewModelDidEndUpdate(){
    }
}

