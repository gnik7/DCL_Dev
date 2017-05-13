//
//  GroupTableViewCell.swift
//  DCL
//
//  Created by Nikita on 3/20/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import MGSwipeTableCell

protocol GroupTableViewCellDelegate: class {
    func groupNamePressed(_ item: GroupModelItem)
    func groupDetailPressed(_ item: GroupModelItem)
}

class GroupTableViewCell:  MGSwipeTableCell {
    
    @IBOutlet weak var titleGroupLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSourceArray: [FriendItemModel]?
    fileprivate var currentItem: GroupModelItem?
    
    fileprivate let itemsPerRow = 1
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    fileprivate let minimumInteritemSpacing: CGFloat = 0
    fileprivate let heightCollCell = 55
    fileprivate let widthCollCell = 40

    
    weak var delegateGroup: GroupTableViewCellDelegate?
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
       
        setupCollectionView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    private func setupCollectionView() {
        
        guard let cellNib = UIView.classNibFromString(className: GroupCollectionViewCell.self) else {return}
        collectionView.register(cellNib, forCellWithReuseIdentifier: String(describing: GroupCollectionViewCell.self))
        
        dataSourceArray = [FriendItemModel]()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func setupData(_ item: GroupModelItem) {
        
        titleGroupLabel.text = item.name ?? ""
        dataSourceArray = item.friends 
        currentItem = item
        collectionView.reloadData()
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func groupNamePressed(_ sender: UIButton) {
        guard let delegateG = delegateGroup else { return}
        delegateG.groupNamePressed(currentItem!)
    }
}

extension GroupTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //*****************************************************************
    // MARK: - UICollectionViewDataSource
    //*****************************************************************
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GroupCollectionViewCell.self), for: indexPath) as? GroupCollectionViewCell,
            let data = dataSourceArray?[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.updateData(item: data)
        return cell
    }
    
    //*****************************************************************
    // MARK: - UICollectionViewDelegate
    //*****************************************************************
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthCollCell, height: heightCollCell)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let delegateG = delegateGroup else { return}
        delegateG.groupDetailPressed(currentItem!)
    }
    
    //*****************************************************************
    // MARK: - UICollectionViewFlowLayout
    //*****************************************************************
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}



