//
//  DiscussionCommentCell.swift
//  kostzy
//
//  Created by Rais on 29/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class DiscussionCommentCell: UITableViewCell {

    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var comment: UITextView!
    
    override func awakeFromNib() {
        userImage.layer.cornerRadius = userImage.frame.height / 2
        comment.textContainerInset = UIEdgeInsets(top: 10, left: 6, bottom: 10, right: 6)
    }
    
}
