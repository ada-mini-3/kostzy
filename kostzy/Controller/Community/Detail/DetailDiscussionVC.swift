//
//  DetailDiscussionVC.swift
//  kostzy
//
//  Created by Rais on 29/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class DetailDiscussionVC: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var discussionText: UILabel!
    
    @IBOutlet weak var commentTV: UITableView!
    
    @IBOutlet weak var commentFormImage: UIImageView!
    
    @IBOutlet weak var commentForm: UIView!
    
    @IBOutlet weak var commentField: UITextField!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    var uImage: UIImage?
    
    var uName: String?
    
    var discussion: String?
    
    var comments = FeedComment.initData()
    
    var bottomConstraint: NSLayoutConstraint?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupUserImage()
        setupKeyboardConstraint()
        setupButtonDarkMode()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupButtonDarkMode() {
        if isDarkMode == true {
            commentButton.tintColor = UIColor.white
            likeButton.tintColor = UIColor.white
        }
    }
    
    private func setupKeyboardConstraint() {
        bottomConstraint = NSLayoutConstraint(item: commentForm!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
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
    
    private func setupView() {
        userImage.image = uImage
        userName.text = uName
        discussionText.text = discussion
        
        commentTV.tableFooterView = UIView()
        commentTV.delegate = self
        commentTV.dataSource = self
    }
    
    private func setupUserImage() {
        userImage.layer.cornerRadius = userImage.frame.height / 2
        commentFormImage.layer.cornerRadius = commentFormImage.frame.height / 2
    }
    
    
    @IBAction func replyButtonClicked(_ sender: UIButton) {
        let newComment = FeedComment(user: User.initUser(), time: Date(), comment: commentField.text ?? "Oi")
        comments.insert(newComment, at: 0)
        view.endEditing(true)
        commentTV.reloadData()
    }
    
}

extension DetailDiscussionVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dissCommentCell", for: indexPath) as! DiscussionCommentCell
        let comment = comments[indexPath.row]
        
        if isDarkMode == true {
            cell.comment.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        } else {
            cell.comment.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        }
        
        cell.userImage.image = comment.user.image
        cell.userName.text = comment.user.name
        cell.comment.text = comment.comment
        return cell
    }
    
    
    
    
}
