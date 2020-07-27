//
//  CommunityAlbumCollectionCell.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 26/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class CommunityAlbumCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        albumImageView.clipsToBounds = true
        albumImageView.layer.cornerRadius = 8
    }
}
