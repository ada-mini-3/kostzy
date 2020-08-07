//
//  TurnOnNotifView.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 02/08/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit
import UserNotifications


enum Identifiers {
    static let viewAction = "VIEW_IDENTIFIER"
    static let notifCategory = "NOTIF_CATEGORY"
}


class TurnOnNotifView: UIView {

    //----------------------------------------------------------------
    // MARK:- Outlets
    //----------------------------------------------------------------
    @IBOutlet weak var turnOnNotifDescriptionLabel: UILabel!
    @IBOutlet weak var closeButtonOutlet: UIButton!
    
    
    //----------------------------------------------------------------
    // MARK:- Variables
    //----------------------------------------------------------------
    let defaults = UserDefaults.standard
    
    
    //----------------------------------------------------------------
    // MARK:- Action Methods
    //----------------------------------------------------------------
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.heightAnchor.constraint(equalToConstant: 0).isActive = true
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            self.isHidden = true
        }
    }
    
    @IBAction func turnOnNotifButtonAction(_ sender: UIButton) {
        registerForPushNotifications()
    }
    
    
    //----------------------------------------------------------------
    // MARK:- Custom Methods
    //----------------------------------------------------------------
    func registerForPushNotifications() {
      UNUserNotificationCenter.current() // 1
        .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
            granted, error in
            print("Permission granted: \(granted)") // 3
            guard granted else { return }
            
            // 1
            let viewAction = UNNotificationAction(
              identifier: Identifiers.viewAction, title: "View",
              options: [.foreground])

            // 2
            let notifCategory = UNNotificationCategory(
              identifier: Identifiers.notifCategory, actions: [viewAction],
              intentIdentifiers: [], options: [])

            // 3
            UNUserNotificationCenter.current().setNotificationCategories([notifCategory])
            
            self.getNotificationSettings()
            
            if granted == true {
                DispatchQueue.main.async {
                    self.defaults.set(true, forKey: "notifIsAllowed")
                    self.heightAnchor.constraint(equalToConstant: 0).isActive = true
                    UIView.animate(withDuration: 0.3) {
                        self.layoutIfNeeded()
                        self.isHidden = true
                    }
                }
            }
        }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if isDarkMode {
            turnOnNotifDescriptionLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)
            closeButtonOutlet.tintColor = .white
        }
        else {
            turnOnNotifDescriptionLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
            closeButtonOutlet.tintColor = .black
        }
    }
    

}
