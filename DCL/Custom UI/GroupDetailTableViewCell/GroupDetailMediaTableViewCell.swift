//
//  GroupDetailMediaTableViewCell.swift
//  DCL
//
//  Created by Nikita Gil on 05.04.17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

protocol GroupDetailMediaTableViewCellDelegate {
    func groupDetailMediaTableView(cell: UITableViewCell, didSelectItem:DetailGroupGoalItemModel)
}

class GroupDetailMediaTableViewCell:  UITableViewCell {
    var delegate: GroupDetailMediaTableViewCellDelegate?
    @IBOutlet weak var collectionView   : UICollectionView!
    
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    var dataSourceArray: [DetailGroupGoalItemModel]?
    
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 5.0)
    fileprivate let minimumInteritemSpacing: CGFloat = 0
    fileprivate let heightCollCell = 150
    fileprivate let widthCollCell = UIScreen.main.bounds.size.width * 0.8
   
    
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
        
        guard let cellNib = UIView.classNibFromString(className: DetailGroupCollectionViewCell.self) else {return}
        collectionView.register(cellNib, forCellWithReuseIdentifier: String(describing: DetailGroupCollectionViewCell.self))
        
        dataSourceArray = [DetailGroupGoalItemModel]()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func setupData(_ item: DetailGroupFriendItemModel) {
        
        dataSourceArray = item.goals
        collectionView.reloadData()
    }
}

extension GroupDetailMediaTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //*****************************************************************
    // MARK: - UICollectionViewDataSource
    //*****************************************************************
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailGroupCollectionViewCell.self), for: indexPath) as? DetailGroupCollectionViewCell,
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
        return CGSize(width: Int(widthCollCell), height: heightCollCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = self.delegate, let item = dataSourceArray?[indexPath.row] else {
            return
        }
        delegate.groupDetailMediaTableView(cell: self, didSelectItem: item)
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
        return sectionInsets.right
    }
}

