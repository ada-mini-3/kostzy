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
    let refreshControl = UIRefreshControl()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupView()
        setupUserImage()
        setupKeyboardConstraint()
        setupButtonDarkMode()
        guard let discussion = discussion else { return }
        setLikeButtonState(button: likeButton, discussion: discussion)
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
        apiManager.performGenericFetchRequest(urlString: "\(apiManager.baseUrl)discussion-comment/?discussion=\(discussion.id)", token: theToken,
            errorMsg: {
            print("Error Bro")
            self.setEmptyMessage("Discussions aren't loading right now")
        })
        { (comments: [DiscussionComment]) in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.commentData = comments
                self.commentTV.tableFooterView = UIView()
                self.commentTV.delegate = self
                self.commentTV.dataSource = self
                self.commentTV.reloadData()
            }
        }
    }
    
    private func setupRefreshControl() {
        if #available(iOS 10.0, *) {
            commentTV.refreshControl = refreshControl
        } else {
            commentTV.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching New Comments ...", attributes: nil)
    }
    
    @objc func refresh(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setupDiscussionComment()
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
        if let image = profileImageCache.object(forKey: "imageProfile") {
            commentFormImage.image = image
        }
        commentFormImage.layer.cornerRadius = commentFormImage.frame.height / 2
    }
    
    func setEmptyMessage(_ message: String) {
         let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))

         messageLabel.text = message
         messageLabel.textColor = .black
         messageLabel.numberOfLines = 0
         messageLabel.textAlignment = .center
         messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
         messageLabel.sizeToFit()
         messageLabel.clipsToBounds = true

         self.commentTV.backgroundView = messageLabel
     }
    
    func restore() {
         self.commentTV.backgroundView = nil
    }
    
    private func setupDiscussionLikeApi(discussionId: Int) {
        guard let token = defaults.dictionary(forKey: "userToken") else { return }
        guard let discussion = discussion else { return }
        let theToken = "Token \(token["token"]!)"
        let payload = ["discussion": discussion.id]
        apiManager.performPostRequest(payload: payload, url: "\(apiManager.baseUrl)discussion-like/", token: theToken) { (data, response, error) in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                        print("Success Like Discussion")
                        break
                    case 400:
                        self.setupAlert(msg: "Something went wrong, please try again later")
                        break
                    default:
                        print(response.statusCode)
                        self.setupAlert(msg: "Error Like Discussion")
                    }
                } else if let error = error {
                    self.setupAlert(msg: error.localizedDescription)
                }
            }
        }
    }
    
    private func setupDiscussionDislikeApi(likeId: Int) {
        guard let token = defaults.dictionary(forKey: "userToken") else { return }
        guard let discussion = discussion else { return }
        guard let likeId = discussion.like else { return }
        let theToken = "Token \(token["token"]!)"
        apiManager.performDeleteRequest(url: "\(apiManager.baseUrl)discussion-like/\(likeId)/", token: theToken) { (response, error) in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                        print("Success Dislike Discussion")
                        break
                    default:
                        self.setupAlert(msg: "Something went wrong, please try again later")
                        break
                    }
                } else if let error = error {
                    self.setupAlert(msg: error.localizedDescription)
                }
            }
        }
    }
    
    private func setLikeButtonState(button: UIButton, discussion: Discussion) {
        if discussion.likeStatus == true {
            button.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            button.tintColor = UIColor.hexStringToUIColor(hex: "#FFB700")
        } else if discussion.likeStatus == false {
            button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            if isDarkMode == true {
                button.tintColor = UIColor.white
            } else {
                button.tintColor = UIColor.black
            }
        }
    }
    
    
    @IBAction func replyButtonClicked(_ sender: UIButton) {
        postDiscussionReplyApi()
        view.endEditing(true)
    }
    
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        guard var discussion = discussion else { return }
        if discussion.likeStatus == false {
            discussion.likeStatus = true
            setupDiscussionLikeApi(discussionId: discussion.id)
            likesCount.text = "\(discussion.likeCount + 1) Likes"
        } else {
            discussion.likeStatus = false
            guard let like = discussion.like else { return }
            setupDiscussionDislikeApi(likeId: like.id)
            likesCount.text = "\(discussion.likeCount - 1) Likes"
        }
        setLikeButtonState(button: likeButton, discussion: discussion)
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
        if commentData.count == 0 {
            setEmptyMessage("Comments Empty")
        } else {
            restore()
        }
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
