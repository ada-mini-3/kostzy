//
//  AppDelegate.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit
import SafariServices
import UserNotifications

@UIApplicationMain
  class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        
        // Check if launched from notification
        let notificationOption = launchOptions?[.remoteNotification]

        // 1
        if let notification = notificationOption as? [String: AnyObject],
            let aps = notification["aps"] as? [String: AnyObject] {
          
            // 2
            NotifItem.makeNotifItem(aps)
          
            // 3
            let sb = UIStoryboard(name: "Menu", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
            vc.selectedIndex = 2
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
          let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
          let token = tokenParts.joined()
          print("Device Token: \(token)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        NotifItem.makeNotifItem(aps)
    }

}


extension AppDelegate: UNUserNotificationCenterDelegate {
      func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // 1
        let userInfo = response.notification.request.content.userInfo
        
        // 2
        if let aps = userInfo["aps"] as? [String: AnyObject],
            let notifItem = NotifItem.makeNotifItem(aps) {
              
            let sb = UIStoryboard(name: "Menu", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
            vc.selectedIndex = 2
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
            // 3
            if response.actionIdentifier == Identifiers.viewAction,
            let url = URL(string: notifItem.link) {
            let safari = SFSafariViewController(url: url)
            vc.present(safari, animated: true, completion: nil)
            }
        }
        
        // 4
        completionHandler()
    }
}
