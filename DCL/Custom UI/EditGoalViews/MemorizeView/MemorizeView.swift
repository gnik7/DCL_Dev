//
//  MemorizeView.swift
//  DCL
//
//  Created by Nikita on 2/24/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

protocol MemorizeViewDelegate: class {
    func choosenArtAction(_ actionType: ArtActionType, action: @escaping ((UIImage?, NSURL?, NSURL?)->()))
    func sharedButtonPressed(_ media: String)
    func showVideo(_ media: String?)
}

class MemorizeView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSourceArray: [MediaGoalItem]!
    
    fileprivate let viewModel = MemorizeViewViewModel()
    weak var delegate: MemorizeViewDelegate?
    
    var choosenPhoto: UIImage?
    var isHeaderChoosen = false
    
    fileprivate var currentGoalId: Int!
    fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        
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
    
    class func loadFromXib(bundle : Bundle? = nil) -> MemorizeView? {
        return UINib(
            nibName: String(describing: MemorizeView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? MemorizeView
    }
    
    private func initCollectionView(){
        setupCollectionView()
        viewModel.delegate = self
    }
    
    func setDataCurrentItem(_ currentItem: HomeIdeasModelItem) {
        
        currentGoalId = currentItem.id!
        
        dataSourceArray = [MediaGoalItem]()
        if let coverUrl = currentItem.goalCover.mediaUrl {
            if !coverUrl.isEmpty {
                dataSourceArray.append(currentItem.goalCover)
                isHeaderChoosen = true
            }
        } else {
            let cover = MediaGoalItem()
            dataSourceArray.append(cover)
            isHeaderChoosen = false
        }
        
        if currentItem.goalImages.count > 0 {
            dataSourceArray.append(contentsOf: currentItem.goalImages)
        }
    }
    
    //*****************************************************************
    // MARK: - Setup UI
    //*****************************************************************
    
    private func setupCollectionView() {
        
        guard let cellNib = UIView.classNibFromString(className: MemorizeViewCollectionCell.self) else {return}
        collectionView.register(cellNib, forCellWithReuseIdentifier: String(describing: MemorizeViewCollectionCell.self))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
    }
    
    //*****************************************************************
    // MARK: - API Calls
    //*****************************************************************

    func savedCoverGoal(_ result: HomeIdeasModelItem){
        if let coverUrl = result.goalCover.mediaUrl {
            if !coverUrl.isEmpty {
                isHeaderChoosen = true
                if dataSourceArray.count > 0{
                    dataSourceArray[0] = result.goalCover
                } else {
                    dataSourceArray.append(result.goalCover)
                }
            }
        }
        collectionView.reloadData()
    }
    
    func savedMediaGoal(_ result: HomeIdeasModelItem){
        let cover = dataSourceArray[0]
        dataSourceArray.removeAll()
        collectionView.reloadData()
        dataSourceArray.append(cover)
        dataSourceArray.append(contentsOf: result.goalImages)
        collectionView.reloadData()
    }
    
    func updateMediaGoal(_ result: HomeIdeasModelItem){
        dataSourceArray.removeAll()
        collectionView.reloadData()
        
        if let coverUrl = result.goalCover.mediaUrl {
            if !coverUrl.isEmpty {
                isHeaderChoosen = true
                if dataSourceArray.count > 0{
                    dataSourceArray[0] = result.goalCover
                } else {
                    dataSourceArray.append(result.goalCover)
                }
            }
        } else {
            isHeaderChoosen = false
            let cover = MediaGoalItem()
            dataSourceArray.append(cover)
        }
        dataSourceArray.append(contentsOf: result.goalImages)
        collectionView.reloadData()
    }
}

extension MemorizeView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //*****************************************************************
    // MARK: - UICollectionViewDataSource
    //*****************************************************************
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = dataSourceArray else {
            return 1
        }
        return dataSource.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MemorizeViewCollectionCell.self), for: indexPath) as! MemorizeViewCollectionCell
        cell.delegate = self
        
        
        guard let dataSource = dataSourceArray else {
            cell.updateData(indexPath: indexPath, item: nil)
            return cell
        }
        if dataSource.count > 0 && indexPath.row < dataSource.count {
            cell.updateData(indexPath: indexPath, item: dataSource[indexPath.row])
        } else {
            cell.updateData(indexPath: indexPath, item: nil)
        }
        
        return cell
    }
    
    //*****************************************************************
    // MARK: - UICollectionViewDelegate
    //*****************************************************************
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return MemorizeViewCollectionCell.currentCellSize(collectionView, collectionViewLayout, indexPath, totalCells: (dataSourceArray?.count)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension MemorizeView: MemorizeViewCollectionCellDelegate {
    
    //*****************************************************************
    // MARK: - MemorizeViewCollectionCellDelegate
    //*****************************************************************
    
    func addPhotoButtonPressed(_ indexPath: IndexPath) {
        
        let row = indexPath.row
        
        guard let photoChooseView = PhotoChooseView.loadFromXib() else {return}
        photoChooseView.show(takePhotoAction: {
            guard let delegate = self.delegate else {return}
            delegate.choosenArtAction(ArtActionType.Photo, action: { [weak self] (image, url, fileUrl) in
                guard let this = self else {return}
                if let pickedImage = image {
                    if row == 0 {
                        this.viewModel.saveCoverGoalItemAction(pickedImage, this.currentGoalId, fileUrl!)
                    } else {
                        this.viewModel.saveMediaGoalItemAction(pickedImage, this.currentGoalId, fileUrl!)
                    }
                }
                
                if let urlVideo = url {
                    if row == 0 {
                        this.viewModel.saveVideoMediaGoalItemAction(urlVideo as URL, this.currentGoalId, fileUrl!)
                    } else {
                        this.viewModel.saveVideoMediaGoalItemAction(urlVideo as URL, this.currentGoalId, fileUrl!)
                    }
                }

            })
        }, chooseGalleryAction: {
            guard let delegate = self.delegate else {return}
            delegate.choosenArtAction(ArtActionType.Gallery, action: { [weak self] (image, url, fileUrl) in
                guard let this = self else {return}
                if let pickedImage = image {
                    if row == 0 {
                        this.viewModel.saveCoverGoalItemAction(pickedImage, this.currentGoalId, fileUrl!)
                    } else {
                        this.viewModel.saveMediaGoalItemAction(pickedImage, this.currentGoalId, fileUrl!)
                    }
                }
                
                if let urlVideo = url {
                    if row == 0 {
                        this.viewModel.saveVideoMediaGoalItemAction(urlVideo as URL, this.currentGoalId, fileUrl!)
                    } else {
                        this.viewModel.saveVideoMediaGoalItemAction(urlVideo as URL, this.currentGoalId, fileUrl!)
                    }
                }
            })
        }, chooseVideoAction: {
            guard let delegate = self.delegate else {return}
            delegate.choosenArtAction(ArtActionType.Gallery, action: {(image, url, fileUrl) in
            })
        })
    }
    
    func deleteButtonPressed(_ indexPath: IndexPath) {
        guard let dataSourse = dataSourceArray, let itemId = dataSourse[indexPath.row].id else {return}
        viewModel.deleteMediaGoalItemAction( currentGoalId, itemId)
    }
    
    func sharedButtonPressed(_ media: String){
        guard let delegate = delegate else { return }
        delegate.sharedButtonPressed(media)
    }
    
    func showVideo(_ media: String?) {
        guard let delegate = delegate else { return }
        delegate.showVideo(media)
    }
    
    func showImage(_ media: String?) {
        guard let fullImageView = PhotoViewerView.loadFromXib() else {
            return
        }
        fullImageView.show(media!)
    }
}

extension MemorizeView: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){}
    
    func viewModelDidEndUpdate(){}
}

