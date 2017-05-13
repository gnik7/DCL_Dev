//
//  NotesTableViewCell.swift
//  DCL
//
//  Created by Nikita on 2/15/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

enum CellMotivationType: Int {
    case CheckList = 0
    case Reminders = 1
}

protocol NotesTableViewCellDelegate: class {
    func checkListUpdated(_ indexPath: IndexPath, _ text: String)
    func remindersUpdated(_ indexPath: IndexPath, _ text: String)
    func showCellOnTop(_ indexPath: IndexPath, _ type: CellMotivationType)
    func checkActionCheckList(_ indexPath: IndexPath, _ checkId: Int)
    func checkActionReminder(_ indexPath: IndexPath, _ checkId: Int)
    func checkListChangeText(_ indexPath: IndexPath, _ text: String, _ checkId: Int)
    func remindersChangeText(_ indexPath: IndexPath, _ text: String, _ checkId: Int)
}

class NotesTableViewCell:  UITableViewCell {
    
    @IBOutlet weak var mainImage    : UIImageView!
    @IBOutlet weak var textView     : UITextView!
    @IBOutlet weak var checkButton  : UIButton!
    @IBOutlet weak var reminderLabel: UILabel!
    
    @IBOutlet weak var mainViewTopConstraint    : NSLayoutConstraint!
    @IBOutlet weak var mainViewBottomConstraint : NSLayoutConstraint!
    @IBOutlet weak var mainImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewTopConstraint    : NSLayoutConstraint!
    @IBOutlet weak var textViewBottomConstraint : NSLayoutConstraint!
    
    weak var delegate       : NotesTableViewCellDelegate?
    fileprivate var currentitem         : CheckListIdeasModelItem?
    fileprivate var currentCellType     : CellMotivationType!
    fileprivate var currentIndexPath    : IndexPath!
    private var isReminderFilled = false
    
    
    private let firstMarginCell: CGFloat = 8.0
    private let filledMarginCell: CGFloat = 0.5
    private let firstHeightImage: CGFloat = 16.0
    private let filledHeightImage: CGFloat = 16.0
    private let reminderFilledHeight: CGFloat = 16.0
    
    fileprivate let maxCharacters = 40
    
    var textString: String {
        get {
            let str = textView.attributedText ?? NSAttributedString(string: "")
            return str.string
        }
        set {
            if let textView = textView {
                textView.attributedText = newValue.normalText()
                
//                textViewDidChange(textView)
            }
        }
    }
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = DefaultGradient.searchBarColor
        self.selectionStyle = .none
        
        setupTextView()
    }
    
    private func setupTextView() {
        textView.delegate = self
        textView.isScrollEnabled = false
        if #available(iOS 10.0, *) {
            textView?.adjustsFontForContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func setupData(item :CheckListIdeasModelItem, indexPath: IndexPath){
        
        currentCellType = CellMotivationType(rawValue: indexPath.section)
        currentIndexPath = indexPath
        currentitem = item
        
        textString = (item.title != nil) ? "\(item.title!)" : ""
        
        reminderLabel.isHidden = true
        
        if textString == DefaultText.addChecklist || textString == DefaultText.writeReminders {
            mainImage.image = #imageLiteral(resourceName: "add_note_edit_goal")
            mainImage.isHidden = false
            checkButton.isEnabled = false
            textView.isUserInteractionEnabled = true
            textView.textColor = DefaultGradient.checkListTextColor
            
            mainViewTopConstraint.constant = firstMarginCell
            mainViewBottomConstraint.constant = firstMarginCell
            mainImageHeightConstraint.constant = firstHeightImage            
        } else {
            
            if currentCellType == CellMotivationType.CheckList {
                mainViewTopConstraint.constant = filledMarginCell
                mainViewBottomConstraint.constant = filledMarginCell
                mainImageHeightConstraint.constant = filledHeightImage
                textViewTopConstraint.constant = 0.0
                textViewBottomConstraint.constant = 0.0
                
                checkButton.isEnabled = true
                mainImage.isHidden = false
                
                if item.isChecked == true {
                    textView.attributedText = textString.strikeThroughText()
                    textView.isUserInteractionEnabled = false
                    mainImage.image = #imageLiteral(resourceName: "filled_check_edit_goal")
                    mainImage.isHidden = false
                } else {
                    textView.attributedText = NSMutableAttributedString(string: "")
                    textView.isUserInteractionEnabled = true
                    textString = (item.title != nil) ? "\(item.title!)" : ""
                    mainImage.image = #imageLiteral(resourceName: "empty_check_edit_goal")
                    mainImage.isHidden = false
                    textView.textColor = DefaultGradient.noActiveSortLabelColor
                }
            } else if currentCellType == CellMotivationType.Reminders  {
                if item.title != nil {
                    mainViewBottomConstraint.constant = reminderFilledHeight
                    mainViewTopConstraint.constant = reminderFilledHeight
                    textViewTopConstraint.constant = 4.0
                    textViewBottomConstraint.constant = 0.0
//                    self.contentView.setNeedsDisplay()
//                    self.contentView.layoutIfNeeded()
                    if let thisIndexPath = tableView?.indexPath(for: self) {
                        tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
                    }
      
                    
                    isReminderFilled = true
                } else {
                    isReminderFilled = false
                    mainViewBottomConstraint.constant = firstMarginCell
                    mainViewTopConstraint.constant = firstMarginCell
                    textViewTopConstraint.constant = 0.0
                    textViewBottomConstraint.constant = 0.0
                }
                
                checkButton.isEnabled = false
                reminderLabel.isHidden = false
                mainImage.isHidden = true
                textView.isUserInteractionEnabled = true
                textView.textColor = DefaultGradient.noActiveSortLabelColor                
            }
        }
//        textView.delegate = self
    }
    
    //*****************************************************************
    // MARK: - Check TextView for empty
    //*****************************************************************
    
    fileprivate func checkTextView(){
        if textView.text.isEmpty {
            if currentCellType == .CheckList {
                textView.text = DefaultText.addChecklist
                mainImage.isHidden = false
            } else if currentCellType == .Reminders {
                textView.text = DefaultText.writeReminders
                mainImage.isHidden = false
            }
        }
    }
    
    //*****************************************************************
    // MARK: - Update Delegate
    //*****************************************************************

    fileprivate func updateDelegate(){
        
        if textView.text.isEmpty { return }
        
        guard let item = currentitem, let id = item.id else {
            return
        }
        
        guard let delegate = delegate,
              let text = textView.text else { return }
        
        if text == DefaultText.addChecklist ||
           text == DefaultText.writeReminders  {
            return
        }
        
        if currentCellType == .CheckList {
            if currentCellType == .CheckList &&
               currentIndexPath.row == 0 &&
               currentIndexPath.section == CellMotivationType.CheckList.rawValue {
               delegate.checkListUpdated(currentIndexPath, text)
            } else {
                //if currentCellType != .CheckList {return}
                delegate.checkListChangeText(currentIndexPath, text, id)
            }
        } else if currentCellType == .Reminders {
            if currentCellType == .Reminders  &&
                currentIndexPath.row == 0 &&
                currentIndexPath.section == CellMotivationType.Reminders.rawValue &&
                !isReminderFilled  {
                delegate.remindersUpdated(currentIndexPath, text)
            } else {
                //if currentCellType != .Reminders {return}
                delegate.remindersChangeText(currentIndexPath, text, id)
            }
        }
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func checkedButtonPressed(_ sender: UIButton) {
        guard let delegate = delegate else { return}
        guard let item = currentitem, let id = item.id else {
            return
        }
        
        if currentCellType == .CheckList {
            if item.isChecked == true {return}
            delegate.checkActionCheckList(currentIndexPath, id)
        } else if currentCellType == .Reminders {
            delegate.checkActionReminder(currentIndexPath, id)
        }        
    }
}

extension NotesTableViewCell: UITextViewDelegate {
    
    //*****************************************************************
    // MARK: - UITextViewDelegate
    //*****************************************************************
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        
        if self.textView.text! == DefaultText.addChecklist || self.textView.text! == DefaultText.writeReminders  {
            self.textView.text = ""
        }
        guard let delegate = delegate else { return true}
        delegate.showCellOnTop(currentIndexPath, currentCellType)
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range.location < maxCharacters && (text != "\n" ) && currentCellType == CellMotivationType.CheckList {
            
            return true
        } else if range.location == maxCharacters && (text != "\n" ) && currentCellType == CellMotivationType.CheckList {
            guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
                return false
            }
            Alert.show(controller: viewController, title: AlertTitle.TitleCommon, message: DefaultText.CheckListLimit , action: nil)
            return false
        } else {
            if (text == "\n" ) {
                print(textView.text)
                textView.resignFirstResponder()
                updateDelegate()
            }
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        checkTextView()
    }
    
    func textViewDidChange(_ textView: UITextView) {

        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        
        // Resize the cell only when cell's size is changed
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            self.contentView.layoutIfNeeded()
            
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            
            if let thisIndexPath = tableView?.indexPath(for: self) {
                tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
}

extension UITableViewCell {
    /// Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            
            return table as? UITableView
        }
    }
}

