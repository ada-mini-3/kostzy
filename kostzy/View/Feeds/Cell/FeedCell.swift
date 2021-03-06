//
//  FeedCell.swift
//  kostzy
//
//  Created by Rais on 21/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell, UICollectionViewDataSource {
    
    //----------------------------------------------------------------
    // MARK:- Constraints Outlets
    //----------------------------------------------------------------
    @IBOutlet weak var userNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var feedTagsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var feedTagsHeightConstraint: NSLayoutConstraint!
    
    
    //----------------------------------------------------------------
    // MARK:- Outlets
    //----------------------------------------------------------------
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var feedTime: UILabel!
    @IBOutlet weak var feedLocation: UIButton!
    @IBOutlet weak var feedLocationChevronImage: UIImageView!
    @IBOutlet weak var feed: UILabel!
    @IBOutlet weak var feedTags: UICollectionView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var userBadge: UIImageView!
    
    //----------------------------------------------------------------
    // MARK:- Variables
    //----------------------------------------------------------------
    var tags = [Tag]()
    var commentTapAction : (()->())?
    var locationTapAction : (()->())?
    var likeTapAction : (()->())?
    var reportTapAction: (()->())?
    
    
    //----------------------------------------------------------------
    // MARK:- View Life Cycle Methods
    //----------------------------------------------------------------
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    
    //----------------------------------------------------------------
    // MARK:- Custom Methods
    //----------------------------------------------------------------
    func configure() {
        feedLocation.contentHorizontalAlignment = .left
        feedLocation.imageEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.clipsToBounds = true
        feedTags.dataSource = self
        feedTags.reloadData()
        
        commentButton.addTarget(self, action: #selector(commentButtonClicked), for: .touchUpInside)
        feedLocation.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        reportButton.addTarget(self, action: #selector(reportButtonClicked), for: .touchUpInside)
    }
    
    @objc func reportButtonClicked() {
        reportTapAction?()
    }
    
    @objc func likeButtonClicked() {
        likeTapAction?()
    }
    
    @objc func commentButtonClicked() {
        commentTapAction?()
    }
    
    @objc func locationButtonClicked() {
        locationTapAction?()
    }
    
    
    //----------------------------------------------------------------
    // MARK:- UIcollectionView
    //----------------------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! FeedTagsCell
        cell.tagName.text = tags[indexPath.row].name
        cell.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: tags[indexPath.row].color)
        return cell
    }
    
}
