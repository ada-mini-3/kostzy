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
        
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var commentText: UITextView!
    
    override func awakeFromNib() {
        userimage.layer.cornerRadius = userimage.frame.height / 2
        commentText.textContainerInset = UIEdgeInsets(top: 10, left: 6, bottom: 10, right: 6)
    }
    
    
}
