//
//  CustomTabBarViewController.swift
//  PresqueIslePark
//
//  Created by Kortez  on 25.07.16.
//  Copyright © 2016 gbksoft. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarViewController: UITabBarController {
    
    var window: UIWindow?
    
    //*****************************************************************
    // MARK: -  Init
    //*****************************************************************
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    
    init(window: UIWindow?) {
        self.window = window
        super.init(nibName: nil, bundle: nil)
    }
        
    override func viewDidLoad() {

        super.viewDidLoad()
        delegate = self
        
        createNavigation()
        setupTabBarSeparators()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //back from openURL method
    func applicationWillEnterForeground() {
          self.selectedIndex = 1
    }
    
    private func createNavigation() {
        var navigation: UINavigationController!
        
        if window != nil {
            guard let navigationCustom = window?.rootViewController as? UINavigationController else {
                return
            }
            navigation = navigationCustom

        } else {
            // get router
            guard let navigationCustom = Router.topViewController() as? UINavigationController else {
                return
            }
            navigation = navigationCustom
        }
        
        let router = Router(navigationController: navigation)
        
        // ideas tab
        let ideasViewController = router.showIdeasViewController()
        let firstTab = UINavigationController(rootViewController: ideasViewController)
        
        // home / open tab
        let homeViewController = router.showHomeViewController()
        let secondTab = UINavigationController(rootViewController: homeViewController)
        
        // achieved tab
        let achievedViewController = router.showAchievedViewController()
        let thirdTab = UINavigationController(rootViewController: achievedViewController)
        
        // group tab
        let groupViewController = router.showGroupViewController()
        let fourthTab = UINavigationController(rootViewController: groupViewController)
        
        
        
        // create tabs icons
        let ideasIcon = UITabBarItem(title: "IDEAS", image: UIImage(named: "ideas_navigation")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "ideas_active_navigation")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        let openIcon = UITabBarItem(title: "OPEN", image: UIImage(named: "open_navigation")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "open_active_navigation")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        let achievedIcon = UITabBarItem(title: "ACHIEVED", image: UIImage(named: "achieved_navigation")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "achieved_active_navigation")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        let groupsIcon = UITabBarItem(title: "GROUPS", image: UIImage(named: "groups_navigation")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "groups_active_navigation")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        
        
        firstTab.tabBarItem = ideasIcon
        firstTab.view.backgroundColor = UIColor.white
        secondTab.tabBarItem = openIcon
        secondTab.view.backgroundColor = UIColor.white
        thirdTab.tabBarItem = achievedIcon
        thirdTab.view.backgroundColor = UIColor.white
        fourthTab.tabBarItem = groupsIcon
        fourthTab.view.backgroundColor = UIColor.white
        
        
        let controllers = [firstTab, secondTab, thirdTab, fourthTab]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
        NotificationCenter.default.addObserver(self, selector: #selector(CustomTabBarViewController.applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        
        self.selectedIndex = 1
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : DefaultGradient.normalTabBarColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : DefaultGradient.selectedTabBarColor], for: .selected)
    }
    
    // create separators in TabBar
    func setupTabBarSeparators() {
        let itemWidth = floor(self.tabBar.frame.size.width / CGFloat(self.tabBar.items!.count))
        
        // this is the separator width.  0.5px matches the line at the top of the tab bar
        let separatorWidth: CGFloat = 1.0
        
        // iterate through the items in the Tab Bar, except the last one
        for i in 0...(self.tabBar.items!.count - 2) {
            // make a new separator at the end of each tab bar item
            let separator = UIView(frame: CGRect(x: itemWidth * CGFloat(i + 1) - CGFloat(separatorWidth / 2), y: 0, width: CGFloat(separatorWidth), height: self.tabBar.frame.size.height))
            
            // set the color to light gray (default line color for tab bar)
            separator.backgroundColor = DefaultGradient.separatorTabBarColor
            
            self.tabBar.addSubview(separator)
        }
    }    
}

extension CustomTabBarViewController: UITabBarControllerDelegate{
    
    //*****************************************************************
    // MARK: -  UITabBarControllerDelegate
    //*****************************************************************
   
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true;
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
                
//        guard tabBarController.viewControllers?.index(of: viewController) == 2 else {
//            return
//        }
    }
}
