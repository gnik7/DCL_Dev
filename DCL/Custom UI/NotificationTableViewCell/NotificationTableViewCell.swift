//
//  NotificationTableViewCell.swift
//  DCL
//
//  Created by Nikita on 3/16/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

protocol NotificationTableViewCellDelegate: class {
    func acceptPressed(_ item: NotificationItemModel)
    func deletePressed(_ item: NotificationItemModel)
}

class NotificationTableViewCell:  UITableViewCell {
    
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var nameLabel        : UILabel!
    @IBOutlet weak var inviteLabel      : UILabel!
    @IBOutlet weak var dateLabel        : UILabel!
    @IBOutlet weak var acceptButton     : UIButton!
    @IBOutlet weak var deleteButton     : UIButton!
    @IBOutlet weak var separatorView    : UIView!
    
    weak var delegate: NotificationTableViewCellDelegate?
    private var userId: Int?
    private var item :NotificationItemModel?
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.makeRoundView()
        acceptButton.makeRoundView()
        deleteButton.makeRoundView()
        deleteButton.makeBorderView(width: 1.0, color: DefaultGradient.deleteButtonBorderColor)
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func setupData(item :NotificationItemModel){
        
        userId = item.data.id
        self.item = item
        
        inviteLabel.text = item.messageInvite
        nameLabel.text = item.data.name
        
        dateLabel.text = (item.created.date?.stringToDate())?.notificationDateToString()
        
        if !item.data.photoUrl.isEmpty {
            let url = URL(string: item.data.photoUrl)
            profileImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: {(image, erro, cache, url) in
            })
        } else {
            profileImageView.image = #imageLiteral(resourceName: "profile_profile")
        }
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        guard let delegate = delegate, let item = self.item else {
            return
        }
        delegate.acceptPressed(item)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        guard let delegate = delegate, let item = self.item else {
            return
        }
        delegate.deletePressed(item)
    }
}

/*
 
 надо сделать логику после апи
 
 на белом фоне — новые. на сером — те, что уже видел
 если принял приглашение — кнопка исчезает. если нет — она отображается, 
 пока не примешь или пока не удалишь само уведомление
 
 
 
 */


