//
//  PurchaseView.swift
//  DCL
//
//  Created by Nikita on 2/17/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

class PurchaseView: UIView {
   
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSourceArray: [StoresListItemModel]!
    
    let viewModel = PurchaseViewViewModel()
  
    fileprivate let itemsPerRow = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    fileprivate let minimumInteritemSpacing: CGFloat = 0
    fileprivate let heightCollCell = 100
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initCollectionView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    class func loadFromXib(bundle : Bundle? = nil) -> PurchaseView? {
        return UINib(
            nibName: String(describing: PurchaseView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? PurchaseView
    }
    
    private func initCollectionView(){
        setupCollectionView()
        viewModel.delegate = self
    }
    
    func updateDataStore(){
        viewModel.updateStoreListAction()
    }
    
    //*****************************************************************
    // MARK: - Setup UI
    //*****************************************************************

    private func setupCollectionView() {
        
        guard let cellNib = UIView.classNibFromString(className: PurchaseViewCollectionCell.self) else {return}
        collectionView.register(cellNib, forCellWithReuseIdentifier: String(describing: PurchaseViewCollectionCell.self))
        
        dataSourceArray = [StoresListItemModel]()
        
        collectionView.delegate = self
        collectionView.dataSource = self
       
        collectionView.reloadData()
    }
    
    func updateData(result: StoresListModel?){
        guard let resultApi = result else {
            return
        }
        dataSourceArray = resultApi.items
        collectionView.reloadData()
    }
}

extension PurchaseView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    //*****************************************************************
    // MARK: - UICollectionViewDataSource
    //*****************************************************************
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PurchaseViewCollectionCell.self), for: indexPath) as! PurchaseViewCollectionCell
        cell.updateData(indexPath: indexPath, item: dataSourceArray[indexPath.row])
        return cell
    }
    
    //*****************************************************************
    // MARK: - UICollectionViewDelegate
    //*****************************************************************

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(itemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(itemsPerRow))
        
        return CGSize(width: size, height: heightCollCell)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = dataSourceArray[indexPath.row].url else {return}
        
        if let URL = NSURL.init(string: url) {
            guard UIApplication.shared.canOpenURL(URL as URL) else { return }
            UIApplication.shared.openURL(URL as URL)
        }
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

extension PurchaseView: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){}
    
    func viewModelDidEndUpdate(){}
}



