//
//  Router.swift
//  DCL
//
//  Created by Nikita on 1/27/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit

fileprivate enum StoryboardConstant {
    static let kMain         = "Main"
    static let kLogin        = "Login"
    static let kHome         = "Home"
    static let kIdies        = "Idies"
    static let kGroups       = "Groups"
    static let kAchieved     = "Achieved"
    static let kNotifSetting = "NotifSetting"    
}


class Router: NSObject {
    
    private var navigationController : UINavigationController?
    let animator = AnimatorNavigation()
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    init(navigationController :UINavigationController)  {
        
        self.navigationController = navigationController
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //*****************************************************************
    // MARK: - Top ViewController
    //*****************************************************************
    
    class func topViewController() -> UIViewController? {
        if let root =  UIApplication.shared.keyWindow?.rootViewController {
            return root
        }
        return nil
    }
    
    class func topCurrentViewController() -> UIViewController? {
        
        if let root =  UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
            return root
        }
        return nil
    }
    
    func popToRootViewController() {
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func popViewController() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    
    //*****************************************************************
    // MARK: - Private
    //*****************************************************************
    
    private class func viewControllerWithClass(className: String, storybordName :String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: storybordName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(className))
        return viewController
    }
    
    //*****************************************************************
    // MARK: -  Login
    //*****************************************************************
    
    func setupLoginRootViewController() {
        let mainViewController = Router.viewControllerWithClass(className: String(describing: LoginViewController.self), storybordName: StoryboardConstant.kLogin)
        self.navigationController = UINavigationController(rootViewController: mainViewController)
        self.navigationController?.delegate = self
        UIApplication.shared.delegate?.window??.rootViewController = self.navigationController
    }
    
    func showSignInViewController() {
        let viewController = Router.viewControllerWithClass(className: String(describing: SignInViewController.self), storybordName: StoryboardConstant.kLogin) as! SignInViewController
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showForgotViewController() {
        let viewController = Router.viewControllerWithClass(className: String(describing: ForgotPasswordViewController.self), storybordName: StoryboardConstant.kLogin) as! ForgotPasswordViewController
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSignUpViewController() {
        let viewController = Router.viewControllerWithClass(className: String(describing: SignUpViewController.self), storybordName: StoryboardConstant.kLogin) as! SignUpViewController
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //*****************************************************************
    // MARK: -  Auto Login / Switch from login
    //*****************************************************************
    
    class func startViewController(_ window: UIWindow?){
        guard let navigation = window?.rootViewController as? UINavigationController else {
            return
        }
        let router = Router(navigationController: navigation)
        
        if UserDefaultsManager.updateToken(key: UserDefaultsManager.kEmailTokenKey) {
            router.showHomeAutoLoginViewController(window)
        } else {
            router.setupLoginRootViewController()
        }        
    }
    
    func showFirstTimeHomeViewController() {
        let viewController = CustomTabBarViewController()
        switchRootViewController(rootViewController: viewController, animated: true, completion: nil)
    }
    
    func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                let navigation = UINavigationController(rootViewController: rootViewController)
                window.rootViewController = navigation
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                if (completion != nil) {
                    completion!()
                }
            })
        } else {
            window.rootViewController = rootViewController
        }
    }
    
    //*****************************************************************
    // MARK: -  Home
    //*****************************************************************
    
    func showHomeViewController() -> HomeViewController {
        let viewController = Router.viewControllerWithClass(className: String(describing: HomeViewController.self), storybordName: StoryboardConstant.kHome) as! HomeViewController
        return viewController
    }
    
    func showHomeAutoLoginViewController(_ window: UIWindow?) {
        let viewController = CustomTabBarViewController(window: window)
        self.navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController?.delegate = self
        UIApplication.shared.delegate?.window??.rootViewController = self.navigationController
    }
    
    func showAddGoalViewController(_ id: Int, _ selectedTitleGoal: String?, _ selectedImage: UIImage?) {
        let viewController = Router.viewControllerWithClass(className: String(describing: AddGoalViewController.self), storybordName: StoryboardConstant.kHome) as! AddGoalViewController
        viewController.userId = id
        viewController.selectedTitleGoal = selectedTitleGoal
        viewController.selectedCoverGoal = selectedImage
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func showEditGoalViewController(item: HomeIdeasModelItem) {
        let viewController = Router.viewControllerWithClass(className: String(describing: EditGoalViewController.self), storybordName: StoryboardConstant.kHome) as! EditGoalViewController
        viewController.currentGoal = item
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showProfileViewController(_ user: UserProfileModel) {
        let viewController = Router.viewControllerWithClass(className: String(describing: ProfileViewController.self), storybordName: StoryboardConstant.kHome) as! ProfileViewController
        viewController.user = user
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showChangePasswordViewController() {
        let viewController = Router.viewControllerWithClass(className: String(describing: ChangePasswordViewController.self), storybordName: StoryboardConstant.kHome) as! ChangePasswordViewController
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showRecoverGoalViewController() {
        let viewController = Router.viewControllerWithClass(className: String(describing: RecoverGoalViewController.self), storybordName: StoryboardConstant.kHome) as! RecoverGoalViewController
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showLogoutViewController() {
        let viewController = Router.viewControllerWithClass(className: String(describing: LoginViewController.self), storybordName: StoryboardConstant.kLogin)
        switchRootViewController(rootViewController: viewController, animated: true, completion: nil)
    }
    
    func showVideoContentViewController(_ url: String?) {
        let viewController = Router.viewControllerWithClass(className: String(describing: VideoContentViewController.self), storybordName: StoryboardConstant.kHome) as! VideoContentViewController
        viewController.videoUrl = url
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //*****************************************************************
    // MARK: -  Ideas
    //*****************************************************************
    
    func showIdeasViewController() -> IdeasViewController {
        let viewController = Router.viewControllerWithClass(className: String(describing: IdeasViewController.self), storybordName: StoryboardConstant.kIdies) as! IdeasViewController
        return viewController
    }
    
    func showCategoryIdeasViewController(_ item: IdeaListItemModel, _ items: [IdeaListItemModel]) {
        let viewController = Router.viewControllerWithClass(className: String(describing: CategoryIdeasViewController.self), storybordName: StoryboardConstant.kIdies) as! CategoryIdeasViewController
        viewController.currentItem = item
        viewController.itemsCollection = items
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //*****************************************************************
    // MARK: -  Achieved
    //*****************************************************************
    
    func showAchievedViewController() -> AchievedViewController {
        let viewController = Router.viewControllerWithClass(className: String(describing: AchievedViewController.self), storybordName: StoryboardConstant.kAchieved) as! AchievedViewController
        return viewController
    }
    
    func showAchievedRootViewController() {
       
         let _ = self.navigationController?.popToRootViewController(animated: true)
        guard let root =  UIApplication.shared.keyWindow?.rootViewController else {return}
        let controllers = root.childViewControllers
        (controllers.first as? CustomTabBarViewController)?.selectedIndex = 2
    }
    
    func showAchievedDetailsViewController(_ perentViewController: String, item: HomeIdeasModelItem)  {
        let viewController = Router.viewControllerWithClass(className: String(describing: AchievedDetailsViewController.self), storybordName: StoryboardConstant.kAchieved) as! AchievedDetailsViewController
        viewController.parentVC = perentViewController
        viewController.item = item
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //*****************************************************************
    // MARK: -  Groups
    //*****************************************************************
    
    func showGroupViewController() -> GroupViewController {
        let viewController = Router.viewControllerWithClass(className: String(describing: GroupViewController.self), storybordName: StoryboardConstant.kGroups) as! GroupViewController
        return viewController
    }
    
    func showAddGroupViewController(_ item: GroupModelItem?) {
        let viewController = Router.viewControllerWithClass(className: String(describing: AddGroupViewController.self), storybordName: StoryboardConstant.kGroups) as! AddGroupViewController
        viewController.groupItem = item
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showFindFriendsGroupViewController( goalId: Int? ,action: (([FriendItemModel]) -> ())?) {
        let viewController = Router.viewControllerWithClass(className: String(describing: FindFriendsGroupViewController.self), storybordName: StoryboardConstant.kGroups) as! FindFriendsGroupViewController
        viewController.complitionHandler = action
        viewController.goalId = goalId
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showDetailGroupViewController(_ groupId: Int) {
        let viewController = Router.viewControllerWithClass(className: String(describing: DetailGroupViewController.self), storybordName: StoryboardConstant.kGroups) as! DetailGroupViewController
        viewController.groupId = groupId
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showChangeNameGroupViewController(_ groupItem: GroupModelItem) {
        let viewController = Router.viewControllerWithClass(className: String(describing: ChangeNameGroupViewController.self), storybordName: StoryboardConstant.kGroups) as! ChangeNameGroupViewController
        viewController.groupItem = groupItem
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //*****************************************************************
    // MARK: -  Notification / Setting
    //*****************************************************************

    func showNotificationsViewController(_ window: UIWindow?) {
        let viewController = Router.viewControllerWithClass(className: String(describing: NotificationViewController.self), storybordName: StoryboardConstant.kNotifSetting) as! NotificationViewController
        viewController.window = window
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSettingViewController(_ user: UserProfileModel) {
        let viewController = Router.viewControllerWithClass(className: String(describing: SettingViewController.self), storybordName: StoryboardConstant.kNotifSetting) as! SettingViewController
        viewController.user = user
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}

extension Router: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController,
        to toVC: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == UINavigationControllerOperation.push {
            return self.animator
        }
        if operation == UINavigationControllerOperation.pop {
            return self.animator
        }
        return nil
    }
}

