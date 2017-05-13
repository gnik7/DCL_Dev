//
//  NotesView.swift
//  DCL
//
//  Created by Nikita on 2/15/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

protocol NotesViewDelegate: class{
    func cellDidPressed(type: GoalTabCellType)
}

protocol NotesViewCheckListDelegate: class{
    func cellDidPressed()
}

class NotesView: UIView {
    
    @IBOutlet weak var motivateButton   : UIButton!
    @IBOutlet weak var tableView        : UITableView!
    
    var checkListArray      : [CheckListIdeasModelItem]!
    var remindersListArray  : [CheckListIdeasModelItem]!
    var itemsArray          : [[CheckListIdeasModelItem]]!
    var goalId              : Int?
   
    weak var delegate   : NotesViewDelegate?
    weak var delegateNotes   : NotesViewCheckListDelegate?
    let viewModel = NotesViewViewModel()
    
    let checkListFirstItem: CheckListIdeasModelItem = {
        let item = CheckListIdeasModelItem()
        item.id = -1
        item.title = DefaultText.addChecklist
        return item
    }()
    
    let reminderFirstItem: CheckListIdeasModelItem = {
        let item = CheckListIdeasModelItem()
        item.id = -1
        item.title = DefaultText.writeReminders
        return item
    }()

    
    let rowHeightView: CGFloat = 50.0
    fileprivate let numberOfSection = 2
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTable()  
        
        NotificationCenter.default.addObserver(self, selector: #selector(activityState(_:)), name: NSNotification.Name(rawValue: LoaderManager.notificationName), object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        motivateButton.layer.cornerRadius = motivateButton.frame.size.height / 2
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    class func loadFromXib(bundle : Bundle? = nil) -> NotesView? {
        return UINib(
            nibName: String(describing: NotesView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? NotesView
    }
    
    private func setupTable() {
        
        viewModel.delegate = self
        
        
        checkListArray = [checkListFirstItem]
        remindersListArray = [reminderFirstItem]
        
        itemsArray = [checkListArray, remindersListArray]
        
        registrateCell()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = DefaultGradient.searchBarColor
        
        tableView.estimatedRowHeight = rowHeightView
        tableView.rowHeight = UITableViewAutomaticDimension
        let footView = UIView()
        footView.backgroundColor = UIColor.clear
        tableView.tableFooterView = footView
    }
    
    private func registrateCell() {
        guard let cellNib = UIView.classNibFromString(className: NotesTableViewCell.self) else {return}
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: NotesTableViewCell.self))
    }
    
    //*****************************************************************
    // MARK: - Notification
    //*****************************************************************
    
    func activityState(_ notification: Notification) {
        if let notif = notification.userInfo?["show"] as? Bool {
            tableView.isUserInteractionEnabled = !notif
        }
    }
    
    //*****************************************************************
    // MARK: - Update Array / Cell
    //*****************************************************************
    
    func updateAllItems(){
        viewModel.updateCheckListAction(id: goalId!, complition: { })
    }
    
    // from Api
    func updateCheckList(result: [CheckListIdeasModelItem]) {
        if result.count == 0 {
            viewModel.updateRemindersAction(id: goalId!)
            return
        }
        checkListArray.removeAll()
        checkListArray = [checkListFirstItem]
        checkListArray.append(contentsOf: result)
        viewModel.updateRemindersAction(id: goalId!)
    }
    
    func updateReminderList(result: [CheckListIdeasModelItem]) {
        if result.count == 0 {
            reloadDataUpdate()
            return
        }
        remindersListArray.removeAll()
        remindersListArray.append(contentsOf: result)
        reloadDataUpdate()
    }
    
    private func reloadDataUpdate(){
        itemsArray.removeAll()
        itemsArray = [checkListArray, remindersListArray]
        self.tableView.reloadData()
    }
    
    func checkListSelectedReloadRow(indexPath:IndexPath, selectedItem:CheckListIdeasModelItem){
        guard let selectedId = selectedItem.id, let selectedState = selectedItem.isChecked  else { return}
        guard let indexOfSelected = checkListArray.index(where: { $0.id == selectedId }) else{return}
        checkListArray[indexOfSelected].isChecked = selectedState
        checkListArray[indexOfSelected].title = selectedItem.title!
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    func reminderSelectedReloadRow(indexPath:IndexPath, selectedItem:CheckListIdeasModelItem){
        guard let selectedId = selectedItem.id, let selectedState = selectedItem.isChecked  else { return}
        guard let indexOfSelected = remindersListArray.index(where: { $0.id == selectedId }) else{return}
        remindersListArray[indexOfSelected].isChecked = selectedState
        remindersListArray[indexOfSelected].title = selectedItem.title!
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func motivateButtonPressed(_ sender: UIButton) {
        guard let motivate = MotivateView.loadFromXib() else {return}
        motivate.showWithApi(DefaultText.MotivationTitle, DefaultText.MotivationButton)
    }
}

extension NotesView: UITableViewDataSource, UITableViewDelegate {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSection
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NotesTableViewCell.self), for: indexPath) as? NotesTableViewCell else {
            return UITableViewCell()
        }
        cell.setupData(item: itemsArray[indexPath.section][indexPath.row], indexPath: indexPath)
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
        print("section \(indexPath.section)  row \(indexPath.row)")
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return rowHeightView
//    }
}

extension NotesView: NotesTableViewCellDelegate{
    
    //*****************************************************************
    // MARK: - NotesTableViewCellDelegate
    //*****************************************************************
    
    func checkListUpdated(_ indexPath: IndexPath, _ text: String) {
        guard let goalIdCurrent = goalId else { return}
        viewModel.checkListItem = (text, indexPath)
        viewModel.saveCheckListItem(title: text, id: goalIdCurrent)
    }
    
    func remindersUpdated(_ indexPath: IndexPath, _ text: String) {
        guard let goalIdCurrent = goalId else { return}
        viewModel.reminderItem = (text, indexPath)
        viewModel.saveReminderItem(title: text, id: goalIdCurrent)
    }
    
    func showCellOnTop(_ indexPath: IndexPath, _ type: CellMotivationType) {
        if let delegate = delegateNotes {
            if type == CellMotivationType.CheckList {
                delegate.cellDidPressed()
            }            
        }
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    func checkActionCheckList(_ indexPath: IndexPath, _ checkId: Int){
        viewModel.checkListItem = ("", indexPath)
        viewModel.updateCheckListSelectedAction(id: checkId)
    }
    
    func checkActionReminder(_ indexPath: IndexPath, _ checkId: Int) {
        viewModel.reminderItem = ("", indexPath)
        viewModel.updateReminderSelectedAction(id: checkId)
    }
    
    func checkListChangeText(_ indexPath: IndexPath, _ text: String, _ checkId: Int) {
        viewModel.checkListItem = ("", indexPath)
        viewModel.changeTextCheckListItem(title: text, id: checkId)
    }
    func remindersChangeText(_ indexPath: IndexPath, _ text: String, _ checkId: Int) {
        viewModel.reminderItem = ("", indexPath)
        viewModel.changeTextReminderItem(title: text, id: checkId)
    }
}

extension NotesView: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){}
    
    func viewModelDidEndUpdate(){}
}


