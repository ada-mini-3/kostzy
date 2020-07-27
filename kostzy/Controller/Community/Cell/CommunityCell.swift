//
//  CommunityCell.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 23/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class CommunityCell: UITableViewCell {

    @IBOutlet weak var communityView: UIView!
    @IBOutlet weak var communityImage: UIImageView!
    @IBOutlet weak var communityNameLabel: UILabel!
    @IBOutlet weak var communityBriefLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
