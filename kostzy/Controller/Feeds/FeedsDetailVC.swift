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
   // @IBOutlet weak var feedLocationImageView: UIImageView!
    @IBOutlet weak var feedText: UILabel!
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
    @IBOutlet weak var commentIndicator: UIActivityIndicatorView!
    @IBOutlet weak var replyButton: UIButton!
    
    var feeds : Feeds?
    var commentData: [FeedComment] =  []
    var bottomConstraint : NSLayoutConstraint?
    var apiManager = BaseAPIManager()
    let defaults = UserDefaults.standard
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupLocationButton()
        setupCommentTableView()
        setupKeyboardConstraint()
        setupCommentData()
        setupRefreshControl()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        tagsCollectionView.dataSource = self
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
        commentTableView.reloadData()
    }
    
    private func setupCommentData() {
        guard let id = feeds?.id else { return }
        self.commentTableView.delegate = nil
        self.commentTableView.dataSource = nil
        apiManager.performGenericFetchRequest(urlString: "\(apiManager.baseUrl)comments?feed=\(id)", token: "",
        errorMsg: {
            print("Error Kak")
        }, completion: { (comment: [FeedComment]) in
            DispatchQueue.main.async {
                
                self.refreshControl.endRefreshing()
                self.commentData = comment
                self.setupCommentTableView()
                self.commentTableView.reloadData()
            }
        })
    }
    
    private func setupRefreshControl() {
        if #available(iOS 10.0, *) {
            commentTableView.refreshControl = refreshControl
        } else {
            commentTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching New Comments ...", attributes: nil)
    }
    
    @objc func refresh(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setupCommentData()
        }
    }
    
    private func setupLocationButton() {
        if isDarkMode == true {
            feedLocation.setTitleColor(UIColor.white, for: .normal)
            feedLocation.tintColor = UIColor.white
        } else {
            feedLocation.setTitleColor(#colorLiteral(red: 0.1462399662, green: 0.1462444067, blue: 0.1462419927, alpha: 0.71), for: .normal)
            feedLocation.tintColor = UIColor(#colorLiteral(red: 0.1462399662, green: 0.1462444067, blue: 0.1462419927, alpha: 0.71))
        }
        
        if let location = feeds?.location {
            feedLocation.setTitle(location, for: .normal)
        }
         feedLocation.contentHorizontalAlignment = .left
    }
    
    private func setupDarkMode() {
        if isDarkMode == true {
            likeButton.tintColor = UIColor.white
            commentButton.tintColor = UIColor.white
            feedLocation.tintColor = UIColor.white
            feedLocation.setTitleColor(UIColor.white, for: .normal)
            feedLocation.tintColor = .white
        } else {
            likeButton.tintColor = UIColor.black
            commentButton.tintColor = UIColor.black
            feedLocation.tintColor = #colorLiteral(red: 0.1462399662, green: 0.1462444067, blue: 0.1462419927, alpha: 0.71)
            feedLocation.setTitleColor(#colorLiteral(red: 0.1462399662, green: 0.1462444067, blue: 0.1462419927, alpha: 0.71), for: .normal)
            feedLocation.tintColor = #colorLiteral(red: 0.1462399662, green: 0.1462444067, blue: 0.1462419927, alpha: 0.71)
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
        if let theImage = feeds?.user.image {
             userImage.loadImageFromUrl(url: URL(string: (theImage))!)
        } else {
            userImage.image = UIImage(named: "Empty Profile Picture")
        }
        
        setupDarkMode()
        
        if let feed = feeds {
            setLikeButtonState(button: likeButton, feed: feed)
        }
        
        replyButton.isEnabled = false
        replyButton.setTitleColor(UIColor.lightGray, for: .normal)
        commentField.delegate = self
        
        userName.text = feeds?.user.name
        feedLocation.setTitle(feeds?.location, for: .normal)
        
        feedText.text = feeds?.feed
        commentCount.text = "\(feeds?.commentCount ?? 0) Comments"
        likeCount.text = "\(feeds?.likeCount ?? 0) Likes"
        
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.clipsToBounds = true
        
        if let image = profileImageCache.object(forKey: "imageProfile") {
            profileImage.image = image
        }
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
    }
    
    private func setLikeButtonState(button: UIButton, feed: Feeds) {
        if feed.likeStatus == true {
            button.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            button.tintColor = UIColor.hexStringToUIColor(hex: "#FFB700")
        } else if feed.likeStatus == false {
            button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            if isDarkMode == true {
                button.tintColor = UIColor.white
            } else {
                button.tintColor = UIColor.black
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    @IBAction func replyCommentClicked(_ sender: Any) {
        postReplyApi()
    }
    
    private func postReplyApi() {
        guard let id = feeds?.id else { return }
        guard let token = defaults.dictionary(forKey: "userToken") else {
            setupLoginPage()
            return
        }
        let theToken = "Token \(token["token"]!)"
        let payload = ["comment": commentField.text ?? "", "feed": id] as [String : Any]
        apiManager.performPostRequest(payload: payload, url: "\(apiManager.baseUrl)comments/", token: theToken) { (data, response, error) in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                      self.setupAlert(title: "Success!" ,msg: "Success Post Reply")
                      self.view.endEditing(true)
                    case 400:
                        self.setupAlert(msg: "Bad Request")
                    default:
                        print(response.statusCode)
                        self.setupAlert(msg: "Something's wrong, Please Try Again Later")
                    }
                } else if let error = error {
                    self.setupAlert(msg: error.localizedDescription)
                }
            }
        }
    }
    
    private func setupLoginPage() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    private func setupAlert(title: String =  "Whoops!", msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        likeButton.tintColor = UIColor.red
    }
    
}

extension FeedsDetailVC: UITextFieldDelegate {
    
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

extension FeedsDetailVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        feeds?.tags.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagsCollectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! FeedTagsCell
        cell.tagName.text = feeds?.tags[indexPath.row].name
        cell.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: (feeds?.tags[indexPath.row].color)!)
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
        commentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! FeedCommentCell
        
        if isDarkMode == true {
            cell.commentText.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        } else {
            cell.commentText.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        }
        
        cell.userimage.loadImageFromUrl(url: URL(string: commentData[indexPath.row].user.image!)!)
        cell.userName.text = commentData[indexPath.row].user.name
        cell.commentText.text = commentData[indexPath.row].comment
        
        return cell
    }
}
