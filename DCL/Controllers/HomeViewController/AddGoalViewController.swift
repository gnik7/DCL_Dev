//
//  AddGoalViewController.swift
//  DCL
//
//  Created by Nikita on 2/14/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit


class AddGoalViewController: BaseMainViewController {
    
    @IBOutlet weak var typesView        : UIView!
    @IBOutlet weak var ballonImageView  : UIImageView!
    @IBOutlet weak var textView         : UITextView!
    @IBOutlet var labels                : [UILabel]!
    @IBOutlet var typeViews             : [UIView]!
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var typesViewBottomConstarint: NSLayoutConstraint!
    
    var selectedTitleGoal: String?
    var selectedCoverGoal: UIImage?

    var userId: Int!
    fileprivate let goalItems = AddGoalModel()
    fileprivate var viewModel = AddGoalViewModel()
    fileprivate let rowInTextViewMax = 7
    fileprivate let maxCharacters = 80
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        setupTexView()
        subscribeForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        updateUI()        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        beginHeght = typesView.frame
        refreshMessageTextView()
    }
    
    private func subscribeForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func setupTexView() {
        textView.textContainer.maximumNumberOfLines = rowInTextViewMax
        textView.textContainer.lineBreakMode = NSLineBreakMode.byClipping
        textView.delegate = self
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        super.keyboardWillShow(notification)
        UIView.animate(withDuration: 0.5, animations: {
            self.typesView.transform = CGAffineTransform.init(translationX: 0, y: -self.keyboardHeight)
        }, completion: { (_) in
        })
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        super.keyboardWillHide(notification)
        UIView.animate(withDuration: 0.1, animations: {
            self.typesView.transform = CGAffineTransform.init(translationX: 0, y: 0)
        }, completion: { (_) in
        })
        refreshMessageTextView()
    }
    
    //*****************************************************************
    // MARK: - Update UI
    //*****************************************************************
    
    private func updateUI(){
        if textView.text == DefaultText.StartNewDream {
           textView.text = selectedTitleGoal ?? DefaultText.StartNewDream
        }       
        
        let indexOfSelected = goalItems.items?.index(where: {$0.state == true})
        for (index, label) in labels.enumerated() {
            label.textColor = goalItems.items?[index].color
            if index == indexOfSelected {
                label.textColor = UIColor.white
                ballonImageView.image = goalItems.items?[index].image
            }
        }
        for (index, view) in typeViews.enumerated() {
            view.backgroundColor = UIColor.white
            if index == indexOfSelected {
                view.backgroundColor = goalItems.items?[index].color
            }
        }
    }
   
    fileprivate func refreshMessageTextView() {
        let sizeThatFitsTextView: CGSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat(MAXFLOAT)))
        self.textViewHeightConstraint.constant = sizeThatFitsTextView.height
        self.textView.isScrollEnabled = false
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        router.popViewController()
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        saveGoal()
    }
    
    @IBAction func typeButtonPressed(_ sender: UIButton) {
        let index = sender.tag - 1
        goalItems.updateModel(index)
        updateUI()
    }
    
    //*****************************************************************
    // MARK: - API Call
    //*****************************************************************
    
    fileprivate func saveGoal(){
        guard let text = textView.text else { return }
        if text.isEmpty || text == DefaultText.ideaDefaultText {return}
        guard let index = goalItems.items?.index(where: {$0.state == true}) else {return}
        guard let choosenItem = goalItems.items?[index] else {return}
        choosenItem.text = text
        choosenItem.id = userId
        viewModel.addGoalAction(item: choosenItem)
    }
    
    func titleSaved(_ goalId: Int) {
        router.popViewController()
//        if selectedCoverGoal != nil {
//           viewModel.saveCoverGoalItemAction(selectedCoverGoal!, goalId)
//        } else {
//          router.popViewController()
//        }
    }
    
    func coverSaved(){
        router.popViewController()
    }
}

extension AddGoalViewController: UITextViewDelegate {
    
    //*****************************************************************
    // MARK: - UITextViewDelegate
    //*****************************************************************
    
    func textViewDidBeginEditing(_ textView: UITextView){
        textView.contentSize.height = textView.requiredHeight()
        self.textViewHeightConstraint.constant = textView.requiredHeight()
        refreshMessageTextView()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {

        if textView.text == DefaultText.ideaDefaultText {
            textView.text = ""
        }        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range.location < maxCharacters && (text != "\n" ) {
            refreshMessageTextView()
            return true
        }  else {
            if (text == "\n" ) {
                if textView.text.isEmpty {
                    textView.text = DefaultText.ideaDefaultText
                }
                textView.resignFirstResponder()
                saveGoal()
            }
        }
       return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
    }
}

extension AddGoalViewController: ViewModelDelegate {
    
    func viewModelDidStartUpdate(){
    }
    
    func viewModelDidEndUpdate(){
    }
}
