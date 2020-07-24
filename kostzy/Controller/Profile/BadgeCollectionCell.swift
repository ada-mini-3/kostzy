//
//  BadgeCollectionCell.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 23/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class BadgeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var likeProgressView: UIProgressView!
    
    @IBOutlet weak var like100DotView: UIView!
    @IBOutlet weak var like200DotView: UIView!
    @IBOutlet weak var like300DotView: UIView!
    @IBOutlet weak var like400DotView: UIView!
    @IBOutlet weak var like500DotView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*
        circleView.layer.cornerRadius = frame.size.width / 2
        circleView.layer.masksToBounds = true
        */
    }
}
