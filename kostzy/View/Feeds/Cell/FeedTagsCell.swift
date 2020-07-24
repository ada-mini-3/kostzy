//
//  FeedTagsCell.swift
//  kostzy
//
//  Created by Rais on 22/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class FeedTagsCell: UICollectionViewCell {
    
    let colorArr : [UIColor] = [UIColor(red: 42/255, green: 139/255, blue: 211/255, alpha: 1),
                                UIColor(red: 243/255, green: 77/255, blue: 114/255, alpha: 1)]
    
    @IBOutlet weak var tagName: UILabel!
    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 10
    }
    
    func configureTagColor(index: Int) {
        self.contentView.backgroundColor = colorArr[index]
    }
    
}
