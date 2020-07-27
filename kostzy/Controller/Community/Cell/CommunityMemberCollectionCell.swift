//
//  CommunityMemberCollectionCell.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 26/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class CommunityMemberCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberRoleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*
        memberImageView.layer.cornerRadius = frame.size.width / 2
        memberImageView.layer.masksToBounds = true
        */
    }
}
