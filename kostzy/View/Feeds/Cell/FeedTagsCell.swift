//
//  FeedTagsCell.swift
//  kostzy
//
//  Created by Rais on 22/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class FeedTagsCell: UICollectionViewCell {
    
    var colorArr : [UIColor] = Tag.colorArr
    
    @IBOutlet weak var tagName: UILabel!
    
    @IBOutlet weak var tagCreateName: UILabel!
        
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 10
    }
    
    func configureTagColor(index: Int) {
        self.contentView.backgroundColor = colorArr[index]
    }
    
}
