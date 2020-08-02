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
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var commentCount: UILabel!
    
    @IBOutlet weak var likeCount: UILabel!
    
    @IBOutlet weak var commentTableView: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var commentFormView: UIView!
    
    @IBOutlet weak var commentField: UITextField!
    
    @IBOutlet weak var buttonLocation: UIButton!
    
    var feeds : Feeds?
       
    var comments = FeedComment.initData()
       
    var bottomConstraint : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupCommentTableView()
        setupKeyboardConstraint()
        setupDarkMode()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        tagsCollectionView.dataSource = self
    }
    
    private func setupLocationButton() {
        feedLocation.contentHorizontalAlignment = .left
        feedLocation.imageEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        
        if isDarkMode == true {
            feedLocation.setTitleColor(UIColor.white, for: .normal)
        } else {
            feedLocation.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    private func setupDarkMode() {
        if isDarkMode == true {
            likeButton.tintColor = UIColor.white
            commentButton.tintColor = UIColor.white
            feedLocation.tintColor = UIColor.white
            feedLocation.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    private func setupKeyboardConstraint() {
        bottomConstraint = NSLayoutConstraint(item: commentFormView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
    }
    
    @objc private func handleKeyboardNotification(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardRect.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                
            }
        }
    }
    
    
    private func setupCommentTableView() {
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.tableFooterView = UIView()
    }
    
    private func setupView() {
        userImage.image = feeds?.user.image
        userName.text = feeds?.user.name
        feedLocation.setTitle(feeds?.location, for: .normal)
        feedLocation.contentHorizontalAlignment = .left
        feedText.text = feeds?.feed
        commentCount.text = "\(feeds?.commentCount ?? 0) Comments"
        likeCount.text = "\(feeds?.likeCount ?? 0) Likes"
        
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.clipsToBounds = true
        
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    @IBAction func replyCommentClicked(_ sender: Any) {
        comments.insert(FeedComment(user: User.initUser(), time: Date(), comment: commentField.text ?? "Hello"), at: 0)
        view.endEditing(true)
        commentTableView.reloadData()
    }
    
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        likeButton.tintColor = UIColor.red
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

extension FeedsDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! FeedCommentCell
        
        if isDarkMode == true {
            cell.commentText.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        } else {
            cell.commentText.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        }
        
        cell.userimage.image = comments[indexPath.row].user.image
        cell.userName.text = comments[indexPath.row].user.name
        cell.commentText.text = comments[indexPath.row].comment
        
        return cell
    }
}
