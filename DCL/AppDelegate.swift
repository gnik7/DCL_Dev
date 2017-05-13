
//
//  AppDelegate.swift
//  DCL
//
//  Created by Nikita on 1/26/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Kingfisher
import Fabric
import Crashlytics
import UserNotifications
import GoogleMaps
import GooglePlaces
import AlamofireNetworkActivityLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var viewModel = RefreshTokenViewModel()
    private var regModel = RefreshTokenModel()
    private var isNeedUpdate = false
    var orientation: UIInterfaceOrientationMask = [.portrait]
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        Fabric.with([Crashlytics.self])
       
        if  #available(iOS 10, *) {
            registerPushNotificationsForIOS10AndMore(application)
        } else {
            registerForPushNotificationsLatestVerion(application)
        }
        
        UserDefaultsManager.createDateFormate()
        
        initKingFisherManager()
        
        KeychainManager.cleanTokenInKeychain(KeychainManager.kEmailTokenKey)
        KeychainManager.cleanTokenInKeychain(KeychainManager.kFBTokenKey)
        
        Router.startViewController(self.window)
        
        GMSServices.provideAPIKey(gooleServiceKey!)
        GMSPlacesClient.provideAPIKey(goolePlaceKey!)
        #if DEBUG
        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
        #endif

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: appFallSleepNotification), object: nil))
        
        if !(UserDefaultsManager.updateInfoFromKeychain(UserDefaultsManager.kEmailTokenKey)).isEmpty && !(UserDefaultsManager.updateInfoFromKeychain(UserDefaultsManager.kEmailTokenKey)).isEmpty {
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        isNeedUpdate = true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if isNeedUpdate {
            refreshToken()
        }
        
        if !(UserDefaultsManager.updateInfoFromKeychain(UserDefaultsManager.kEmailTokenKey)).isEmpty && !(UserDefaultsManager.updateInfoFromKeychain(UserDefaultsManager.kEmailTokenKey)).isEmpty {
            TimeManager.sharedInstance.updateTime()
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        //FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    func registerPushNotificationsForIOS10AndMore(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted:Bool, error: Error?) in
                if (granted) {
                    application.registerForRemoteNotifications()
                } else {
                    print("Not granded")
                    if let error = error {
                        print(error)
                    }
                }
            })
        }
    }
    
    //*****************************************************************
    // MARK: - Push
    //*****************************************************************
    
    func registerForPushNotificationsLatestVerion(_ application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       
        let deviceTokenString = deviceToken.hexString
        print("APNs device token: \(deviceTokenString)")
        let result = UserDefaultsManager.updateInfoFromKeychain(UserDefaultsManager.kApnTokenKey)
        
        if (result.isEmpty) {
            UserDefaultsManager.recordToken(token: deviceTokenString, key: UserDefaultsManager.kApnTokenKey)
        }        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //assert(false, error.localizedDescription)
        print("didFailToRegisterForRemoteNotificationsWithError error -  \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        PushManager.sharedInstance.application(application, didReceiveRemoteNotification: userInfo, window: self.window)
    }
    
    //*****************************************************************
    // MARK: - Refresh Token
    //*****************************************************************
  
    private func refreshToken(){
        //viewModel.refreshTokenAction()
    }
    
    //*****************************************************************
    // MARK: - KingFisherManager
    //*****************************************************************
    
    private func initKingFisherManager() {
        // Clear memory cache right away.
        KingfisherManager.shared.cache.clearMemoryCache()
        
        // Clear disk cache. This is an async operation.
        KingfisherManager.shared.cache.clearDiskCache()
        
        // Clean expired or size exceeded disk cache. This is an async operation.
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
        
        //SSL serteficate
        ImageDownloader.default.trustedHosts = Set([baseHost])
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return orientation
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        print("\nwillPresent\n\(notification.request.content.body)\n\n")
//         NSLog( @"Handle push from foreground" );
        // custom code to handle push while app is in the foreground
        PushManager.sharedInstance.application(true, window: self.window, notification.request.content)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print("\ndidReceive\n\(response.notification.request.content.userInfo)\n\n")
        
//        NSLog( @"Handle push from background or closed" );
        // if you set a member variable in didReceiveRemoteNotification, you will know if this is from closed or background
        PushManager.sharedInstance.application(false, window: self.window, response.notification.request.content)
    }
    
}


