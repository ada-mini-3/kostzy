//
//  MyCommunityCell.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 22/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class MyCommunityCell: UITableViewCell {

    @IBOutlet weak var myCommunityImage: UIImageView!
    @IBOutlet weak var myCommunityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
