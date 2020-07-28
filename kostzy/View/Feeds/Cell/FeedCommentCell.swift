//
//  FeedCommentCell.swift
//  kostzy
//
//  Created by Rais on 25/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class FeedCommentCell: UITableViewCell {

    @IBOutlet weak var userimage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var comment: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        userimage.layer.cornerRadius = userimage.frame.height / 2
    }
    
}
