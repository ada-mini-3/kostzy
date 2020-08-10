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
    @IBOutlet weak var commentIndicator: UIActivityIndicatorView!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    
    var discussion: Discussion?
    var bottomConstraint: NSLayoutConstraint?
    var apiManager = BaseAPIManager()
    var defaults = UserDefaults.standard
    var commentData: [DiscussionComment] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupUserImage()
        setupKeyboardConstraint()
        setupButtonDarkMode()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        setupDiscussionComment()
    }
    
    private func setupDiscussionComment() {
        guard let token = defaults.dictionary(forKey: "userToken") else { return }
        guard let discussion = discussion else { return }
        let theToken = "Token \(token["token"]!)"
        apiManager.performGenericFetchRequest(urlString: "\(apiManager.baseUrl)discussion-comment/?discussion=\(discussion.id)", token: theToken, errorMsg: {
            print("Error Bro")
        }) { (comments: [DiscussionComment]) in
            DispatchQueue.main.async {
                self.commentIndicator.stopAnimating()
                self.commentData = comments
                self.commentTV.tableFooterView = UIView()
                self.commentTV.delegate = self
                self.commentTV.dataSource = self
                self.commentTV.reloadData()
            }
        }
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
    
    private func postDiscussionReplyApi() {
        guard let token = defaults.dictionary(forKey: "userToken") else { return }
        guard let discussion = discussion else { return }
        
        let theToken = "Token \(token["token"]!)"
        let payload = ["comment": commentField.text ?? "", "discussion": discussion.id] as [String : Any]
        
        apiManager.performPostRequest(payload: payload, url: "\(apiManager.baseUrl)discussion-comment/", token: theToken) { (data, response, error) in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                        self.setupAlert(title: "Success!" ,msg: "Success Post Reply")
                        self.view.endEditing(true)
                    default:
                        print(response.statusCode)
                        self.setupAlert(msg: "Please Fill The Comment Field")
                    }
                } else if let error = error {
                    self.setupAlert(msg: error.localizedDescription)
                }
            }
        }
    }
    
    private func setupAlert(title: String = "Whoops!", msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
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
        guard let discussion = discussion else { return }
        if let userImageUrl = discussion.user.image {
            userImage.loadImageFromUrl(url: URL(string: userImageUrl)!)
        }
        commentField.delegate = self
        replyButton.isEnabled = false
        replyButton.setTitleColor(UIColor.lightGray, for: .normal)
        userName.text = discussion.user.name
        discussionText.text = discussion.text
        commentCount.text = "\(discussion.commentCount) Comments"
        likesCount.text = "\(discussion.likeCount) Likes"
    }
    
    private func setupUserImage() {
        userImage.layer.cornerRadius = userImage.frame.height / 2
        commentFormImage.layer.cornerRadius = commentFormImage.frame.height / 2
    }
    
    
    @IBAction func replyButtonClicked(_ sender: UIButton) {
        postDiscussionReplyApi()
        view.endEditing(true)
    }
    
}

extension DetailDiscussionVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if textField.text?.isEmpty == true {
            replyButton.isEnabled = false
            replyButton.setTitleColor(UIColor.lightGray, for: .normal)
         } else {
            replyButton.isEnabled = true
            replyButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FFB700"), for: .normal)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            replyButton.isEnabled = false
            replyButton.setTitleColor(UIColor.lightGray, for: .normal)
        } else {
            replyButton.isEnabled = true
            replyButton.setTitleColor(UIColor.hexStringToUIColor(hex: "#FFB700"), for: .normal)
        }
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
        return commentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dissCommentCell", for: indexPath) as! DiscussionCommentCell
        let comment = commentData[indexPath.row]
        
        if isDarkMode == true {
            cell.comment.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        } else {
            cell.comment.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        }
        
        if let image = comment.user.image {
            cell.userImage.loadImageFromUrl(url: URL(string: image)!)
        } else {
            cell.userImage.image = #imageLiteral(resourceName: "Empty Profile Picture")
        }
        cell.userName.text = comment.user.name
        cell.comment.text = comment.comment
        return cell
    }
    
}
