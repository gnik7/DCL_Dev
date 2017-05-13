//
//  ProfileViewController.swift
//  DCL
//
//  Created by Nikita on 2/28/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import AssetsLibrary
import MobileCoreServices

class ProfileViewController: BaseMainViewController {
    

    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var checkImageView   : UIImageView!
    @IBOutlet weak var emailLabel       : UILabel!
    
    @IBOutlet weak var recoverGoalButton: UIButton!
    @IBOutlet weak var logoutButton     : UIButton!
    @IBOutlet weak var activityIndicatot: UIActivityIndicatorView!
    
    var user: UserProfileModel?
    var isFacebook = false
    
    fileprivate var viewModel = ProfileViewModel()
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        subscribeForKeyboardNotifications()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //beginHeght = typesView.frame
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bordedViews()
    }
    
    private func subscribeForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    private func updateUI(){
        activityIndicatot.isHidden = true
        guard let user = user else { return }
        
        if let avatar = user.photoUrl  {
            if !avatar.isEmpty {
                activityIndicatot.isHidden = false
                activityIndicatot.startAnimating()
                profileImageView.kf.setImage(with:  URL(string: avatar), placeholder: nil, options: [], progressBlock: nil, completionHandler: {[weak self] (image, error, cache, url) in
                    guard let this = self  else {return}
                    this.profileImageView.makeRoundView()
                    this.activityIndicatot.isHidden = true
                    this.activityIndicatot.stopAnimating()
                })
            }
        }
        emailLabel.text = user.email ?? ""
        isFacebook = user.isFacebook ?? false
        notificationState(user.isNotifiable!)
    }
    
    private func bordedViews() {
        recoverGoalButton.makeRoundView()
        logoutButton.makeRoundView()
        profileImageView.makeRoundView()
    }
    
    private func notificationState(_ state: Bool){
        if state {
            UIView.animate(withDuration: 0.5, animations: {
                self.checkImageView.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.checkImageView.alpha = 0.0
            })
        }
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        router.popViewController()
    }
    
    @IBAction func changePhotoButtonPressed(_ sender: UIButton) {
        Alert.showPhotoAlert(controller: self, actionPhoto: {
            self.showImagePickerController(type: UIImagePickerControllerSourceType.camera, delegate: self)
        }, actionGallery: {
            self.showImagePickerController(type: UIImagePickerControllerSourceType.photoLibrary, delegate: self)
        })
    }
    
    @IBAction func changeEmailButtonPressed(_ sender: UIButton) {
        if isFacebook {
            Alert.show(controller: self, title: AlertTitle.TitleCommon, message: AlertText.ForbidChangeFromFacebook, action: nil)
            return
        }
        showChangeEmail()
    }
    
    @IBAction func changePasswordButtonPressed(_ sender: UIButton) {
        if isFacebook {
            Alert.show(controller: self, title: AlertTitle.TitleCommon, message: AlertText.ForbidChangeFromFacebook, action: nil)
            return
        }
        router.showChangePasswordViewController()
    }
    
    @IBAction func notifyButtonPressed(_ sender: UIButton) {
        guard let user = self.user else { return }
        user.isNotifiable = !user.isNotifiable!
        viewModel.notifiableAction(user.isNotifiable!)
    }
    
    @IBAction func recoverButtonPressed(_ sender: UIButton) {
        router.showRecoverGoalViewController()
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {       
        UserDefaultsManager.cleanTokenInKeychain(UserDefaultsManager.kEmailTokenKey)
        UserDefaultsManager.cleanTokenInKeychain(UserDefaultsManager.kFBTokenKey)
        router.showLogoutViewController()
        viewModel.logoutAction()
    }

    //*****************************************************************
    // MARK: - Show custom Views
    //*****************************************************************
    
    private func showChangeEmail(){
        guard let emailView = EmailChangeView.loadFromXib() else { return}
        guard let oldEmail = user?.email else  { return}
        emailView.show(email: oldEmail, action: {[weak self] (newEmail) in
            guard let this = self else {return}
            this.viewModel.resetEmailAction(newEmail)
        })        
    }
    
    //*****************************************************************
    // MARK: - API Call
    //*****************************************************************

    func updateChangedEmail(_ email: String) {
        user?.email = email
        emailLabel.text = email
    }
    
    func updateChangedAvatar(_ url: String, _ image: UIImage) {
        user?.photoUrl = url
        self.profileImageView.image = image
        self.profileImageView.contentMode = UIViewContentMode.scaleAspectFit
        self.profileImageView.makeRoundView()
    }
    
    func updateNotifications(_ user: UserProfileModel){
        guard let user = self.user else { return }
        self.user = user
        notificationState(user.isNotifiable!)
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //*****************************************************************
    // MARK: - UIImagePickerControllerDelegate
    //*****************************************************************
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            viewModel.resetAvatarAction(pickedImage)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){
    }
    
    func viewModelDidEndUpdate(){
    }
}

