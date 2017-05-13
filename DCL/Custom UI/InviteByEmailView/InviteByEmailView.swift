//
//  InviteByEmailView.swift
//  DCL
//
//  Created by Nikita on 3/14/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import Contacts


class InviteByEmailView: UIView {
    
    @IBOutlet weak var layerViewBack    : UIView!
    @IBOutlet weak var mainView         : UIView!
    @IBOutlet weak var emailTextField   : UITextField!
    @IBOutlet weak var tableView        : UITableView!
    
    
    fileprivate var contacts            : [CNContact]?
    private var complitionHandler   : ((String) -> ())?
    
    lazy var tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureTap(_:)))
    
    fileprivate let rowHeight: CGFloat = 44.0
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emailTextField.delegate = self
        layerViewBack.addGestureRecognizer(tapGesture)
        
        setupTable()
        
        ContactListManager.sharedInstance.requestForAccess {[weak self] (result) in
            if result == true {
                guard let result = ContactListManager.sharedInstance.retrieveContactsWithStore(store: ContactListManager.sharedInstance.contactStore) else {return}
                guard let this = self else {return}
                var filteredResult = [CNContact]()
                for item in result {

                    guard let email = item.emailAddresses.first?.value as String? else {continue}
                    if !email.isEmpty {
                        filteredResult.append(item)
                    }
                }
                this.contacts = filteredResult
                DispatchQueue.main.async {
                    this.tableView.reloadData()
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    class func loadFromXib(bundle : Bundle? = nil) -> InviteByEmailView? {
        return UINib(
            nibName: String(describing: InviteByEmailView.self),
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? InviteByEmailView
    }
    
    func gestureTap(_ recognizer:UIPanGestureRecognizer) {
        let point: CGPoint = recognizer.location(in: self)
        
        if tableView.bounds.contains(point) {
           return
        } else {
            emailTextField.resignFirstResponder()
            hideView()
        }
    }
    
    private func setupTable() {
        contacts = [CNContact]()
        registrateCell()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
    
    private func registrateCell() {
        guard let cellNib = UIView.classNibFromString(className: SharePopupTableViewCell.self) else {return}
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: SharePopupTableViewCell.self))
    }
    
    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    private func bringToFront() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        if let windowView = UIApplication.shared.keyWindow {
            windowView.addSubview(self)
        }
        
        self.superview?.bringSubview(toFront: self)
    }
    
    //*****************************************************************
    // MARK: - Show/ Hide
    //*****************************************************************    
    
    func show( action: ((String) -> ())?) {
        complitionHandler = action
        showViewAnimation()
    }
    
    private func showViewAnimation() {
        
        bringToFront()
        
        self.alpha = 0.0
        self.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: { () -> Void in
            self.alpha = 1.0
        }, completion: nil)
    }
    
    private func hideView() {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.alpha = 0.0
        }, completion: { (Bool) -> Void in
            
            self.isHidden = true
            self.removeFromSuperview()
        })
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        actionOK()
    }
    
    fileprivate func actionOK() {
        emailTextField.resignFirstResponder()
        hideView()
        guard let action = complitionHandler else { return}
        action(emailTextField.text!)
    }
}

extension InviteByEmailView: UITextFieldDelegate {
    
    //*****************************************************************
    // MARK: - UITextFieldDelegate
    //*****************************************************************
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isValidEmail()  {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        actionOK()
        return true
    }
}

extension InviteByEmailView: UITableViewDataSource, UITableViewDelegate {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SharePopupTableViewCell.self), for: indexPath) as? SharePopupTableViewCell else {return UITableViewCell()}
        cell.setupContactData((contacts?[indexPath.row])!)
        return cell
    }
    
    //*****************************************************************
    // MARK: - UITableViewDelegate
    //*****************************************************************
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard  let item = contacts?[indexPath.row] else {
            return
        }
        
        emailTextField.text = (item.emailAddresses.first?.value as String?)
    }
}

extension InviteByEmailView: UIScrollViewDelegate {
    
    //*****************************************************************
    // MARK: - UIScrollViewDelegate
    //*****************************************************************
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        emailTextField.resignFirstResponder()
    }
}





