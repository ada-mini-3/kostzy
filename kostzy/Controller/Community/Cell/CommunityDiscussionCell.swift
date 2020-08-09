//
//  CommunityDiscussionCell.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 27/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class CommunityDiscussionCell: UITableViewCell {

    @IBOutlet weak var discussionView: UIView!
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var discussionLabel: UILabel!
    
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        memberImageView.layer.cornerRadius = memberImageView.frame.height / 2
        memberImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
