//
//  EditGoalViewController.swift
//  DCL
//
//  Created by Nikita on 2/15/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import CoreLocation
import AssetsLibrary
import MobileCoreServices
import GooglePlaces


class EditGoalViewController: BaseMainViewController {

    @IBOutlet var tabViewsCollection        : [UIView]!
    @IBOutlet weak var contentView          : UIView!
    @IBOutlet weak var locationTextField    : UITextField!
    @IBOutlet weak var dateLabel            : UILabel!
    @IBOutlet weak var titleTextView        : UITextView!
    
    @IBOutlet weak var locationActivityIndicator        : UIActivityIndicatorView!
    @IBOutlet weak var titleTextViewHeightConstraint    : NSLayoutConstraint!
    
    let tabCellViews    = EditGoalTabCellViewModel()
    let viewModel       = EditGoalViewModel()
    fileprivate var placesView              : PlacesView?
    var currentType                         : GoalTabCellType!
    var currentGoal                         : HomeIdeasModelItem!
    var complitionHandel                    : ((UIImage?, NSURL?, NSURL?)->())?
    fileprivate var contentViewCollection   : [UIView]!
    fileprivate var beginEditingLocationView = false
    fileprivate let maxLinesIdea = 10
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        viewModel.delegate = self
        contentViewCollection = [UIView]()
        subscribeForKeyboardNotifications()
        updateUI()
        setupTextViewsAndTextField()
        currentType = GoalTabCellType.Notes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        setupTabViews()
        loadToContentView(currentType)
        
        titleTextView.isScrollEnabled = true
        DispatchQueue.main.async {
            self.refreshMessageTextView()
            self.titleTextView.setContentOffset(.zero, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
   
    private func updateUI(){
        locationActivityIndicator.isHidden = true
        
        titleTextView.text = (currentGoal.ideas != nil) ? "\(currentGoal.ideas!)" : ""
        let type = (currentGoal.ideasLevel != nil) ? currentGoal.ideasLevel! : IdeaLevel.None
        titleTextView.textColor = AddGoalItemModel.convertTypeToColor(type)
        locationTextField.text = (currentGoal.location != nil) ? "\(currentGoal.location!)" : DefaultText.tagLocation
        dateLabel.text = (currentGoal.endsAt.date != nil) ? "\((currentGoal.endsAt.date!).stringWithDate())" : "Date"
    }
    
    private func setupTabViews(){
        
        tabCellViews.delegate = self
        
        for (index,item) in tabViewsCollection.enumerated() {
            tabCellViews.items[index].frame = CGRect(x: 0, y: 0, width: item.frame.size.width, height: item.frame.size.height)
            item.addSubview(tabCellViews.items[index])
            tabCellViews.items[index].show()
            let type = tabCellViews.items[index].currentItem.type
            createContentView(type!)
        }
    }
    
    private func setupTextViewsAndTextField(){
        
        titleTextView.delegate = self
        titleTextView.textContainer.maximumNumberOfLines = maxLinesIdea
        titleTextView.textContainer.lineBreakMode = NSLineBreakMode.byClipping
        
        locationTextField.delegate = self
    }
    
    fileprivate func refreshMessageTextView() {
        let sizeThatFitsTextView: CGSize = titleTextView.sizeThatFits(CGSize(width: titleTextView.frame.size.width, height: CGFloat(MAXFLOAT)))
        titleTextViewHeightConstraint.constant = sizeThatFitsTextView.height
        titleTextView.isScrollEnabled = false
    }
    
    private func subscribeForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func keyboardWillShow(_ notification: Notification) {
        
        if !beginEditingLocationView {
            keyboardParamsFromView(currentType)
            super.keyboardWillShow(notification)
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        super.keyboardWillHide(notification)
        placesView?.hideView()
        placesView = nil
        beginEditingLocationView = false
    }
    
    //*****************************************************************
    // MARK: - Creation / Load ContentView
    //*****************************************************************
    
    private func createContentView(_ type: GoalTabCellType){
        let contentFrame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        if type == GoalTabCellType.Notes {
            guard let noteView = NotesView.loadFromXib() else {return}
            noteView.frame = contentFrame
            contentViewCollection.append(noteView)
        } else if type == GoalTabCellType.Invate {
            guard let inviteView = InviteView.loadFromXib() else {return}
            inviteView.frame = contentFrame
            inviteView.currentGoal = currentGoal
            contentViewCollection.append(inviteView)
        } else if type == GoalTabCellType.Purchase {
            guard let purchaseView = PurchaseView.loadFromXib() else {return}
            purchaseView.frame = contentFrame
            contentViewCollection.append(purchaseView)
        } else if type == GoalTabCellType.Memorize {
            guard let memorizeView = MemorizeView.loadFromXib() else {return}
            memorizeView.frame = contentFrame
            contentViewCollection.append(memorizeView)
            memorizeView.setDataCurrentItem(currentGoal)
        }
    }
    
    /// Description
    ///
    /// - Parameter type: GoalTabCellType - type of content view according to top cells
    fileprivate func loadToContentView(_ type: GoalTabCellType){
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        let contentFrame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        if type == GoalTabCellType.Notes {
            let noteView = contentViewCollection[0] as! NotesView
            noteView.frame = contentFrame
            contentView.addSubview(noteView)
            noteView.goalId = currentGoal.id
            noteView.updateAllItems()
            noteView.delegateNotes = self
        } else if type == GoalTabCellType.Invate {
            let inviteView = contentViewCollection[1] as! InviteView
            inviteView.frame = contentFrame
            contentView.addSubview(inviteView)
            inviteView.delegate = self
            inviteView.updateData()            
        } else if type == GoalTabCellType.Purchase {
            let purchaseView = contentViewCollection[2] as! PurchaseView
            purchaseView.frame = contentFrame
            contentView.addSubview(purchaseView)
            purchaseView.updateDataStore()
        }else if type == GoalTabCellType.Memorize {
            let memorizeView = contentViewCollection[3] as! MemorizeView
            memorizeView.frame = contentFrame
            memorizeView.delegate = self
            contentView.addSubview(memorizeView)
        }
    }
    
    private func keyboardParamsFromView(_ type: GoalTabCellType){
        
        if type == GoalTabCellType.Notes {
            let noteView = contentViewCollection[0] as! NotesView
            tmpView = noteView.tableView
            beginHeght = noteView.tableView.frame
            additionalHeigh = noteView.rowHeightView * 3
        } else if type == GoalTabCellType.Invate {
           
        } else if type == GoalTabCellType.Purchase {
            
            
        } else if type == GoalTabCellType.Memorize {
           
        }
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        placesView?.hideView()
        placesView = nil
        self.gestureTap()
        router.popViewController()
    }

    @IBAction func locationButtonPressed(_ sender: UIButton) {
        placesView?.hideView()
        placesView = nil
        self.gestureTap()
        updateLocation()
        guard let plView = placesView else {return}
        plView.hideView()
    }
    
    @IBAction func dateButtonPressed(_ sender: UIButton) {
        placesView?.hideView()
        placesView = nil
        self.gestureTap()
        updateDate()
    }
    
    @IBAction func celebrateButtonPressed(_ sender: UIButton) {
        placesView?.hideView()
        placesView = nil
        self.gestureTap()
        let memorizeView = contentViewCollection[3] as! MemorizeView
        if memorizeView.isHeaderChoosen {
            guard let goalId = currentGoal.id else {return}
            viewModel.archiveAction(id: goalId)
        } else {
            Alert.show(controller: self, title: AlertTitle.TitleCommon, message: AlertText.NeedChooseHeaderPhoto, action: nil)
        }      
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        placesView?.hideView()
        placesView = nil
        self.gestureTap()
        guard let goalTitle = currentGoal.ideas else { return}
        var text = goalTitle
        if titleTextView.text != goalTitle {
             text = titleTextView.text
        }
        SharingManager.showSharing(controller: self, shareContent: text, action: nil)
    }
    
    //*****************************************************************
    // MARK: - Location
    //*****************************************************************

    fileprivate func updateLocation(){
        locationTextField.text = ""
        locationActivityIndicator.isHidden = false
        locationActivityIndicator.startAnimating()
        
        LocationManager.sharedInstance.initLocationManager()
        LocationManager.sharedInstance.delegate = self
        LocationManager.sharedInstance.startLocationManager()
        LocationManager.sharedInstance.updateCoordinates { (location) in
            LocationManager.updateCurrentLocationAddress(location: location, completed: { [weak self](address) in
                guard let this = self else {return}
                if address.isEmpty {
                    this.locationTextField.text = DefaultText.tagLocation
                } else  {
                    this.locationTextField.text = address
                    this.viewModel.updateLocationAction(location: address, id: this.currentGoal.id!)
                }
                this.locationActivityIndicator.stopAnimating()
                this.locationActivityIndicator.isHidden = true
                LocationManager.sharedInstance.stopLocationManager()                
            })
        }
    }
    
    //*****************************************************************
    // MARK: - Date
    //*****************************************************************

    private func updateDate(){
        guard let picker = DateView.loadFromXib() else {return}
        picker.show { [weak self] (date , serverDare) in
            guard let this = self, let id = this.currentGoal.id  else {return}
            this.dateLabel.text = date
            this.viewModel.updateDateAction(time: serverDare, id: id)
        }
    }
    
    //*****************************************************************
    // MARK: - API
    //*****************************************************************
    
    func celebrateArchiveUpdate(_ item: HomeIdeasModelItem){
        guard let celebrateView = AchieveAndCelebrateView.loadFromXib() else {return}
        celebrateView.show {[weak self] () in
            guard let this = self else {return}
            this.router.showAchievedDetailsViewController( String(describing: EditGoalViewController.self), item: item)
        }
    }
}

extension EditGoalViewController: EditGoalTabCellViewModelDelegate {
    
    //*****************************************************************
    // MARK: - EditGoalTabCellViewModelDelegate
    //*****************************************************************
    
    func cellDidPressed(type: GoalTabCellType){
        for item in tabCellViews.items {
            item.show()
        }
        currentType = type
        loadToContentView(type)
    }
}

extension EditGoalViewController: NotesViewCheckListDelegate {
    
    //*****************************************************************
    // MARK: - NotesViewDelegate
    //*****************************************************************
    
    func cellDidPressed(){
        beginEditingLocationView = true
    }
}


extension EditGoalViewController: LocationManagerDelegate {

    //*****************************************************************
    // MARK: - LocationManagerDelegate
    //*****************************************************************
    
    func locationManager(_ locationManager: LocationManager, getAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .notDetermined {
            Alert.show(controller: self, title: "DCL doesn't have access to location", message: "You can enable access in Privacy Settings", action: {
//                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
//                if let url = settingsUrl {
//                    UIApplication.shared.openURL(url)
//                }
            })
        }
    }
}

extension EditGoalViewController: UITextViewDelegate {
    
    //*****************************************************************
    // MARK: - UITextViewDelegate
    //*****************************************************************
    
    func textViewDidBeginEditing(_ textView: UITextView){
        placesView?.hideView()
        placesView = nil
        textView.contentSize.height = textView.requiredHeight()
        titleTextViewHeightConstraint.constant = textView.requiredHeight()
        refreshMessageTextView()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let rowsInTextView = textView.numberOfLines()
        print(rowsInTextView)
        if rowsInTextView <= maxLinesIdea {
            refreshMessageTextView()
            if (text == "\n" ) {
                textView.resignFirstResponder()
                if textView.text.isEmpty { return true}
                let fullString = textView.text + text
                viewModel.updateTitleAction(title: fullString, id: currentGoal.id!)
            }
            return true
        }
        return false
    }
}

extension EditGoalViewController: UITextFieldDelegate {
    
    //*****************************************************************
    // MARK: - UITextFieldDelegate
    //****************************************************************
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if locationTextField.text == DefaultText.tagLocation  {
//            updateLocation()
//            return false
//        }
        beginEditingLocationView = true
        textField.text = ""
        guard let plView = PlacesView.loadFromXib() else {return true}
        placesView = plView
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let fullString = textField.text! + string
        
        let result = string.detectBackspacePressed()
        
        if result {
            if textField.text!.characters.count >= 0 {
                let newStr = String(textField.text!.characters.dropLast())
                updatePlaces(place: newStr)
            }
        } else {
            updatePlaces(place: fullString)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        placesView?.hideView()
        placesView = nil
        locationTextField.resignFirstResponder()
        if (locationTextField.text?.isEmpty)! { return true }
        
        guard let address = locationTextField.text, let id = currentGoal.id else {
            return true
        }
        viewModel.updateLocationAction(location: address, id: id)
        beginEditingLocationView = false
        return true
    }
}

extension EditGoalViewController: MemorizeViewDelegate {
    
    //*****************************************************************
    // MARK: - MemorizeViewDelegate
    //*****************************************************************
    
    func choosenArtAction(_ actionType: ArtActionType, action: @escaping ((UIImage?, NSURL?, NSURL?)->())) {
        complitionHandel = action
        let result = self.detectCameraPermissionsAndPresent()
        if result {
            
            if actionType == ArtActionType.Photo {
                self.showImagePickerController(type: UIImagePickerControllerSourceType.camera, delegate: self)
            } else if actionType == ArtActionType.Gallery {
                self.showImagePickerController(type: UIImagePickerControllerSourceType.photoLibrary, delegate: self)
            }  else if actionType == ArtActionType.Video {
                self.showImagePickerController(type: UIImagePickerControllerSourceType.photoLibrary, delegate: self)
            }
        }
    }
    
    func sharedButtonPressed(_ media: String) {
        SharingManager.showSharing(controller: self, shareContent: media, action: nil)
    }
    
    func showVideo(_ media: String?){
        router.showVideoContentViewController(media)
    }
}

extension EditGoalViewController: InviteViewDelegate {
    
    //*****************************************************************
    // MARK: - InviteViewDelegate
    //*****************************************************************
    
    func addAction(_ action: @escaping (([FriendItemModel]?)->())) {
//        router.showFindFriendsViewController(currentGoal)
        
        guard let goalId = currentGoal.id else { return }
        
        router.showFindFriendsGroupViewController( goalId: goalId, action: {(friends) in
            action(friends)
        })
    }
    
    func friendsAddedToGoal(_ message : String) {
        Alert.show(controller: self, title: AlertTitle.TitleCommon, message: message, action: nil)
    }
}

extension EditGoalViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //*****************************************************************
    // MARK: - UIImagePickerControllerDelegate
    //*****************************************************************
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {       
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            var url = NSURL()
            if (info[UIImagePickerControllerReferenceURL] as? NSURL) != nil {
                url = (info[UIImagePickerControllerReferenceURL] as? NSURL)!
            }
            print(url)
            guard let action = complitionHandel else { return }
            action(pickedImage, nil, url)
        }
        
//        if let videoURL = info["UIImagePickerControllerReferenceURL"] as? NSURL {
//            print(videoURL)
//            guard let action = complitionHandel else { return }
//            action(nil, videoURL)
//        }
        
        if let videoURL = info["UIImagePickerControllerMediaURL"] as? NSURL {
            print(videoURL)
            guard let action = complitionHandel else { return }
            action(nil, videoURL, videoURL)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditGoalViewController {
    
    //*****************************************************************
    // MARK: - Google Map Places
    //*****************************************************************
    
    func updatePlaces(place: String){
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        
        GMSPlacesClient.shared().autocompleteQuery(place , bounds: nil , filter: filter) {[weak self] (result:[GMSAutocompletePrediction]?,  error:Error?) in
            
            guard let this = self, let places = result, let plView = this.placesView else {return}
            if places.count > 0 {
                if (plView.isShow) {
                    plView.updateData(places)
                } else {
                    let rect = this.locationTextField.bounds
                    let tfPoint = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height)
                    let point = this.view.superview?.convert(tfPoint, from: this.locationTextField)
                    let size = CGRect(x: (point?.x)!, y: (point?.y)!, width: UIScreen.main.bounds.width, height: rect.size.height * 6)
                    plView.show(size)
                    plView.delegatePlace = this
                    plView.updateData(places)
                }
            } else {
                plView.hideView()
            }
        }
    }
}

extension EditGoalViewController: PlacesViewDelegate {
    
    func addAction(_ placeID: String?, _ namePlace: String?){
        guard let name = namePlace,
              let id = currentGoal.id else { return }
        
        locationTextField.text = name
       
        viewModel.updateLocationAction(location: name, id: id)
        self.gestureTap()
        
        
//        GMSPlacesClient.shared().lookUpPlaceID(plId, callback: { [weak self](place: GMSPlace?, error: Error?) in
//            guard let this = self, let places = place else {return}
//            //TODO: API Call
//            let pl = place
//            print(pl)
//        })
    }
}

extension EditGoalViewController: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){}
    
    func viewModelDidEndUpdate(){}
}
