//
//  PlacesView.swift
//  DCL
//
//  Created by Nikita on 4/13/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import GooglePlaces

protocol PlacesViewDelegate: class {
    func addAction(_ placeID: String?, _ namePlace: String?)
}

class PlacesView: UIView {
    
    @IBOutlet weak var tableView : UITableView!
    var invitedArray: [GMSAutocompletePrediction]?
    
    weak var delegatePlace: PlacesViewDelegate?
    var isShow = false
    private var viewRect: CGRect = CGRect.zero
    let rowHeight: CGFloat = 47.0
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTable()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    class func loadFromXib(bundle : Bundle? = nil) -> PlacesView? {
        return UINib(
            nibName: String(describing: PlacesView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? PlacesView
    }
    
    private func setupTable() {
        
        invitedArray = [GMSAutocompletePrediction]()
        
        registrateCell()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.backgroundColor = DefaultGradient.searchBarColor
        let footView = UIView()
        footView.backgroundColor = UIColor.clear
        tableView.tableFooterView = footView
    }
    
    private func registrateCell() {
        guard let cellNib = UIView.classNibFromString(className: PlacesViewCell.self) else {return}
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: PlacesViewCell.self))
    }
    
    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    private func bringToFront() {
        self.frame = CGRect(x: 0, y: viewRect.origin.y, width: viewRect.size.width, height: viewRect.size.height)
        if let windowView = UIApplication.shared.keyWindow {
            windowView.addSubview(self)
        }
       
        self.superview?.bringSubview(toFront: self)
    }
    
    //*****************************************************************
    // MARK: - Show/ Hide
    //*****************************************************************
    
    func show(_ size: CGRect) {
        viewRect = size
        showViewAnimation()
        isShow = true
    }
    
    private func showViewAnimation() {
        
        bringToFront()
        
        self.alpha = 0.0
        self.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: { () -> Void in
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func hideView() {
        isShow = false
        UIView.animate(withDuration: 0.7, animations: { () -> Void in
            self.alpha = 0.0
        }, completion: { (Bool) -> Void in
            
            self.isHidden = true
            self.removeFromSuperview()
        })
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************

    func updateData(_ data: [GMSAutocompletePrediction]) {
        invitedArray?.removeAll()
        tableView.reloadData()
        invitedArray?.append(contentsOf: data)
        tableView.reloadData()
    }
}

extension PlacesView: UITableViewDataSource, UITableViewDelegate {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitedArray?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlacesViewCell.self), for: indexPath) as? PlacesViewCell else {
            return UITableViewCell()
        }
        cell.setupData(item: (invitedArray?[indexPath.row].attributedFullText)!)
//        cell.delegate = self
        return cell
    }
    
    //*****************************************************************
    // MARK: - UITableViewDelegate
    //*****************************************************************
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegatePlace, let placeName = invitedArray?[indexPath.row].attributedFullText else {
            return
        }
        print(placeName)
        let stringName = placeName.string
        delegate.addAction(nil, stringName)
        hideView()
    }
}




