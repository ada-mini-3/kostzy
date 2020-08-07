//
//  NotificationView.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 03/08/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class NotificationView: UIView {
    
    //----------------------------------------------------------------
    // MARK:- Outlets
    //----------------------------------------------------------------
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNotifLabel: UILabel!
    @IBOutlet weak var chevronRightIcon: UIImageView!
    
    
    //----------------------------------------------------------------
    // MARK:- Action Methods
    //----------------------------------------------------------------
    
    
    
    //----------------------------------------------------------------
    // MARK:- Custom Methods
    //----------------------------------------------------------------
    func setupWith(_ notif: Notif) {
        userImageView.image = UIImage(named: notif.userImage)
        userNameLabel.text = notif.userName
        userNotifLabel.text = "\(notif.userComment)  \(notif.time)"
    }
    

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if isDarkMode {
            chevronRightIcon.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
        }
        else {
            chevronRightIcon.tintColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.3)
        }
    }
}
