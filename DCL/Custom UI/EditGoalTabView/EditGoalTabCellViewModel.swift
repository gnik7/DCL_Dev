//
//  EditGoalTabCellViewModel.swift
//  DCL
//
//  Created by Nikita on 2/15/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

protocol EditGoalTabCellViewModelDelegate: class{
    func cellDidPressed(type: GoalTabCellType)
}

class EditGoalTabCellViewModel {
    
    var items: [EditGoalTabCellView]!
    weak var delegate: EditGoalTabCellViewModelDelegate?
    
    init() {
        self.items = createItems()
    }
    
    private func createItems() -> [EditGoalTabCellView] {
        let note = EditGoalTabCellViewItemModel(state: true, colorLayer: DefaultGradient.selectedTabColor, type: GoalTabCellType.Notes,
                                                isShowSeparator: false,
                                                content: CellContent.init(text: "Notes", activeImage: #imageLiteral(resourceName: "notes_active_edit_goal"), image: #imageLiteral(resourceName: "notes_edit_goal"), width: 18.0, height: 27.0))
        let invate = EditGoalTabCellViewItemModel(state: false, colorLayer: UIColor.white, type: GoalTabCellType.Invate,
                                                isShowSeparator: true,
                                                content: CellContent.init(text: "Invite", activeImage: #imageLiteral(resourceName: "invite_acive_edit_goal"), image: #imageLiteral(resourceName: "invite_edit_goal"), width: 28.0, height: 26.0))
        let purchase = EditGoalTabCellViewItemModel(state: false, colorLayer: UIColor.white, type: GoalTabCellType.Purchase,
                                                isShowSeparator: true,
                                                content: CellContent.init(text: "Purchase", activeImage: #imageLiteral(resourceName: "purchase_active_edit_goal"), image: #imageLiteral(resourceName: "purchase_edit_goal"), width: 29.0, height: 26.0))
        let memorize = EditGoalTabCellViewItemModel(state: false, colorLayer: UIColor.white, type: GoalTabCellType.Memorize,
                                                isShowSeparator: false,
                                                content: CellContent.init(text: "Memorize", activeImage: #imageLiteral(resourceName: "memorize_active_edit_goal"), image: #imageLiteral(resourceName: "memorize_edit_goal"), width: 32.0, height: 26.0))
        
        let noteView = createView(note)
        let invateView = createView(invate)
        let purchaseView = createView(purchase)
        let memorizeView = createView(memorize)
        
        return [noteView, invateView, purchaseView, memorizeView]
    }
    
    private func createView(_ item: EditGoalTabCellViewItemModel) -> EditGoalTabCellView {
        guard let cellView = EditGoalTabCellView.loadFromXib() else {
            return EditGoalTabCellView(coder: NSCoder())
        }
        cellView.currentItem = item
        cellView.delegate = self
        return cellView
    }
    

}

extension EditGoalTabCellViewModel: EditGoalTabCellViewDelegate {
    
    //*****************************************************************
    // MARK: - EditGoalTabCellViewDelegate
    //*****************************************************************
    
    func cellDidPressed(type: GoalTabCellType){
        guard let indexOfSelected = items.index(where: {$0.currentItem.type == type}) else{return}
        for item in self.items {
            item.currentItem.state = false
            self.items[indexOfSelected].currentItem.updateToState()
        }
        self.items[indexOfSelected].currentItem.state = true        
        self.items[indexOfSelected].currentItem.updateToState()
        if indexOfSelected != 0 {
            self.items[indexOfSelected - 1].currentItem.isShowSeparator = false
        }
        guard let delegate = delegate else { return }
        delegate.cellDidPressed(type: type)
    }
}

enum GoalTabCellType {
    case Notes
    case Invate
    case Purchase
    case Memorize
}

struct CellContent {
    
    var text        : String!
    var activeImage : UIImage!
    var image       : UIImage!
    var width       : CGFloat!
    var height      : CGFloat!
    
    init(text: String, activeImage: UIImage, image: UIImage, width : CGFloat, height: CGFloat) {
        self.text = text
        self.activeImage = activeImage
        self.image = image
        self.width = width
        self.height = height
    }
}


class EditGoalTabCellViewItemModel {

    var colorLayer  : UIColor!
    var image       : UIImage!
    var type        : GoalTabCellType!
    var content     : CellContent!
    var textColor   : UIColor!
    var isShowSeparator : Bool!
    //var state   : Bool!
    
    var state   : Bool! {
        didSet {
            self.updateToState()
        }
    }
    
    init(state:Bool , colorLayer  : UIColor, type: GoalTabCellType,  isShowSeparator: Bool, content:CellContent) {
        self.state = state
        self.colorLayer = colorLayer
        self.content = content
        self.isShowSeparator = isShowSeparator
        self.type = type
        updateToState()
   }

    func updateToState() {
        if self.state == true {
            self.image = self.content.activeImage
            self.textColor = DefaultGradient.selectedTextTabColor
            self.colorLayer = DefaultGradient.selectedTabColor
            self.isShowSeparator = false
            
        } else {
            self.image = self.content.image
            self.textColor = DefaultGradient.activeDeselectedTextTabColor
            self.colorLayer = UIColor.white
            
            if self.type == .Memorize  {
                self.isShowSeparator = false
            } else {
                self.isShowSeparator = true
            }
        }
    }
}
