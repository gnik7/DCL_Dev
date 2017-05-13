//
//  MemorizeViewCollectionCell.swift
//  DCL
//
//  Created by Nikita on 2/27/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import Kingfisher

protocol MemorizeViewCollectionCellDelegate: class {
    
    func addPhotoButtonPressed(_ indexPath: IndexPath)
    func deleteButtonPressed(_ indexPath: IndexPath)
    func sharedButtonPressed(_ media: String)
    func showVideo(_ media: String?)
    func showImage(_ media: String?)
}

class MemorizeViewCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView    : UIImageView!
    @IBOutlet weak var deleteImageView  : UIImageView!
    @IBOutlet weak var shareImageView   : UIImageView!
    @IBOutlet weak var plusImageView    : UIImageView!
    @IBOutlet weak var addLabel         : UILabel!
    
    @IBOutlet weak var addButton        : UIButton!
    @IBOutlet weak var deleteButton     : UIButton!
    @IBOutlet weak var shareButton      : UIButton!
    
    weak var delegate: MemorizeViewCollectionCellDelegate?
    private var currentIndexPath: IndexPath?
    private var currentMediaUrl: String?
        
    private static let itemsPerRow = 2
    private static let itemInFirstRow = 1
    private static let minimumInteritemSpacing: CGFloat = 5
    private static let heightFirstCell = 185
    private static let heightAnotherCell = 138
    private static let sectionInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 5.0, right: 5.0)
    private let videoString = "MOV"
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    func updateData(indexPath: IndexPath, item: MediaGoalItem? ){
        currentIndexPath = indexPath
        
        
        guard let item = item else { setupUI(false) ; return }
        if let logo = item.mediaUrl  {
            if !logo.isEmpty {
                currentMediaUrl = logo
                if !checkVideo(logo) {
                    mainImageView.kf.setImage(with:  URL(string: logo), placeholder: nil, options: [], progressBlock: nil, completionHandler: {[weak self] (image, error, cache, url) in
                        guard let this = self else {return}
                        if this.currentIndexPath?.row == 0 {
                            this.mainImageView.contentMode = UIViewContentMode.scaleAspectFill
                        } else {
                            this.mainImageView.contentMode = UIViewContentMode.scaleAspectFill
//                            this.mainImageView.contentMode = UIViewContentMode.scaleAspectFit
                        }
                    })
                } else {
                    mainImageView.image = #imageLiteral(resourceName: "play_button")
                    mainImageView.contentMode = UIViewContentMode.scaleAspectFill
                }
            setupUI(true)
            }
        } else {
            setupUI(false)
        }
    }
    
    private func setupLabel(_ index: Int, _ state: Bool) {
        if index == 0 {
            if state {
                addLabel.isHidden = true
            } else {
               addLabel.isHidden = false
            }            
        } else {
            addLabel.isHidden = true
        }
    }
    
    private func setupUI(_ state: Bool) {
        // true image is set (image != nil)
        if state {
            setupLabel((currentIndexPath?.row)!, state)
            plusImageView.isHidden = true
            addButton.isEnabled = true
            
            deleteImageView.isHidden = false
            deleteButton.isEnabled = true
            
//            shareImageView.isHidden = false
//            shareButton.isEnabled = true
        } else {
            mainImageView.image = nil
            setupLabel((currentIndexPath?.row)!, state)
            plusImageView.isHidden = false
            addButton.isEnabled = true
            
            deleteImageView.isHidden = true
            deleteButton.isEnabled = false
            
//            shareImageView.isHidden = true
//            shareButton.isEnabled = false
        }
    }
    
    private func checkVideo(_ url: String) -> Bool {
        if url.contains(videoString) {
            return true
        } else {
            return false
        }
    }
    
    //*****************************************************************
    // MARK: - Size Cell
    //*****************************************************************
    
    class func currentCellSize(_ collectionView: UICollectionView ,_ collectionViewLayout: UICollectionViewLayout, _ indexPath: IndexPath, totalCells: Int) -> CGSize {
        
        if indexPath.row == 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
            flowLayout.sectionInset = sectionInsets
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(itemInFirstRow - 1))
            let size = Int(((collectionView.bounds.width) - totalSpace) / CGFloat(itemInFirstRow))
            return CGSize(width: size, height: size)
        } else {
                       
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
           
            flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
            flowLayout.sectionInset = sectionInsets
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(itemsPerRow - 1))
            let size = Int(((collectionView.bounds.width) - totalSpace) / CGFloat(itemsPerRow))
            
            if totalCells % 2 != 0 && (totalCells - 1) == indexPath.row {
                
                flowLayout.sectionInset.right = collectionView.bounds.width * 0.5
                return CGSize(width: size, height: heightAnotherCell)
            } else if totalCells == 1  {
                flowLayout.sectionInset.right = collectionView.bounds.width * 0.5
                return CGSize(width: size, height: heightAnotherCell)
            } else {
                
                return CGSize(width: size, height: heightAnotherCell)
            }
        }
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        if mainImageView.image == nil {
            guard  let delegate = delegate, let indexPath = currentIndexPath else { return }
            delegate.addPhotoButtonPressed(indexPath)
        } else {
            guard  let delegate = delegate, let url = currentMediaUrl else { return }
            if !checkVideo(url) {
                delegate.showImage(url)
            } else {
                delegate.showVideo(url)
            }
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {

        guard let delegate = delegate, let mediaUrl = currentMediaUrl else { return }
        delegate.sharedButtonPressed(mediaUrl)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        guard  let delegate = delegate, let indexPath = currentIndexPath else { return }
        delegate.deleteButtonPressed(indexPath)
    }
}

