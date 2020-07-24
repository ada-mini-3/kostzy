//
//  FeedsDetailVC.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class FeedsDetailVC: UIViewController {
            
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var feedLocation: UIButton!
    
    @IBOutlet weak var feedText: UITextView!
    
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    @IBOutlet weak var commentCount: UILabel!
    
    @IBOutlet weak var likeCount: UILabel!
    
    var feeds : Feeds?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        tagsCollectionView.dataSource = self
    }
    
    private func setupView() {
        userImage.image = feeds?.user.image
        userName.text = feeds?.user.name
        feedLocation.setTitle(feeds?.location, for: .normal)
        feedLocation.contentHorizontalAlignment = .left
        feedText.text = feeds?.feed
        commentCount.text = "\(feeds?.commentCount ?? 0) Comments"
        likeCount.text = "\(feeds?.likeCount ?? 0) Likes"
        
        feedLocation.contentHorizontalAlignment = .left
        feedLocation.imageEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.clipsToBounds = true
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    

}

extension FeedsDetailVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        feeds?.tags.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagsCollectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! FeedTagsCell
        cell.tagName.text = feeds?.tags[indexPath.row].name
        cell.configureTagColor(index: indexPath.row)
        return cell
    }
    
}
