//
//  DetailDiscussionVC.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class CommunityDiscussionVC: UIViewController {

    //----------------------------------------------------------------
    // MARK:- Outlets
    //----------------------------------------------------------------
    
    @IBOutlet weak var discussionTableView: UITableView!
    
    
    //----------------------------------------------------------------
    // MARK:- Constraints Outlets
    //----------------------------------------------------------------
    
    /*
    @IBOutlet var discussionTableHeightConstraint: NSLayoutConstraint!
    */
    
    
    //----------------------------------------------------------------
    // MARK:- Variables
    //----------------------------------------------------------------
    var height: CGFloat!
    var discussionTableHeightConstraint: NSLayoutConstraint!
    var selectedRow: Int = 0
    var communityId: Int?
    var apiManager = BaseAPIManager()
    let defaults = UserDefaults.standard
    var commDiscussions: [Discussion] = []
    //----------------------------------------------------------------
    // MARK:- Memory Management Methods
    //----------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //----------------------------------------------------------------
    // MARK:- Action Methods
    //----------------------------------------------------------------
    
    @IBAction func createDiscussionAction(_ sender: Any) {
        performSegue(withIdentifier: "createDiscussionSegue", sender: self)
    }
    
    
    //----------------------------------------------------------------
    // MARK:- Custom Methods
    //----------------------------------------------------------------
    
    @objc func adjustHeightOfTableview() {
        height = discussionTableView.contentSize.height
        print("Discussion Table Height: \(String(describing: height))")
        //CGFloat maxHeight = self.tableView.superview.frame.size.height - self.tableView.frame.origin.y;

        /*
            Here you have to take care of two things, if there is only    tableView on the screen then you have to see is your tableView going below screen using maxHeight and your screen height,
         Or you can add your tableView inside scrollView so that your tableView can increase its height as much it requires based on the number of cell (with different height based on content) it has to display.
           */

        // now set the height constraint accordingly
        discussionTableHeightConstraint = discussionTableView.heightAnchor.constraint(equalToConstant: height)
        NSLayoutConstraint.activate([
            discussionTableHeightConstraint
        ])
        print("Discussion Table Height Constraint: \(String(describing: discussionTableHeightConstraint))")

        // Preferred Content Size
        preferredContentSize.height = discussionTableView.contentSize.height
        
        //If you want to increase tableView height with animation you can do that as below.

        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func setupDiscussionData() {
        guard let token = defaults.dictionary(forKey: "userToken") else { return }
        let theToken = "Token \(token["token"]!)"
        guard let id = communityId else { return }
        apiManager.performGenericFetchRequest(urlString: "\(apiManager.baseUrl)discussion/?community=\(id)",
            token: theToken,
            errorMsg: {
            print("Error gan")
        }) { (discussions: [Discussion]) in
            DispatchQueue.main.async {
                print("Sukses")
                self.commDiscussions = discussions
                self.discussionTableView.reloadData()
            }
        }
    }
    
    private func setupDiscussionLikeApi(discussionId: Int) {
        guard let token = defaults.dictionary(forKey: "userToken") else { return }
        let theToken = "Token \(token["token"]!)"
        let payload = ["discussion": discussionId]
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
    
    private func setupAlert(msg: String) {
        let alert = UIAlertController(title: "Whoops!", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func setLikeButtonState(button: UIButton, discussion: Discussion) {
        if discussion.likeStatus == true {
                button.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                button.tintColor = UIColor(red: 255/255, green: 183/255, blue: 0/255, alpha: 1)
        } else if discussion.likeStatus == false {
            button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            if isDarkMode == true {
                button.tintColor = UIColor.white
            } else {
                button.tintColor = UIColor.black
            }
        }
    }
    
    
    //----------------------------------------------------------------
    // MARK:- View Life Cycle Methods
    //----------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //----------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //----------------------------------------------------------------
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupDiscussionData()
        DispatchQueue.main.async(execute: {
            self.discussionTableView.reloadData()

            //In my case i had to call this method after some delay, because (i think) it will allow tableView to reload completely and then calculate the height required for itself. (This might be a workaround, but it worked for me)
            self.perform(#selector(self.adjustHeightOfTableview), with: nil)
        })
    }
    
    override func viewDidLayoutSubviews() {
        /* perform(#selector(self.adjustHeightOfTableview), with: nil) */
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        discussionTableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "discussionDetailSegue" {
            if let dest = segue.destination as? DetailDiscussionVC {
               let discussion = commDiscussions[selectedRow]
                dest.discussion = discussion
            }
        }
    }

}


//----------------------------------------------------------------
// MARK:- Table View Data Source
//----------------------------------------------------------------

extension CommunityDiscussionVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 228
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
        performSegue(withIdentifier: "discussionDetailSegue", sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commDiscussions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityDiscussionCell", for: indexPath) as! CommunityDiscussionCell
        var discussion = commDiscussions[indexPath.row]
        // Configure the cell...
        if isDarkMode == true {
            cell.contentView.backgroundColor = .systemBackground
            cell.discussionView.backgroundColor = .systemGray5
        } else {
            cell.contentView.backgroundColor = .systemBackground
            cell.discussionView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9921568627, alpha: 1)
            cell.discussionView.shadowColor = .black
            cell.discussionView.shadowOffset = CGSize(width: 0, height: 0)
            cell.discussionView.shadowRadius = 2
            cell.discussionView.shadowOpacity = 0.3
        }
        cell.discussionView.cornerRadius = 10
        
       // cell.memberImageView.image = UIImage(named: memberImage[indexPath.row])
        if let userImage = discussion.user.image {
            cell.memberImageView.loadImageFromUrl(url: URL(string: userImage)!)
        } else {
            cell.memberImageView.image = #imageLiteral(resourceName: "Empty Profile Picture")
        }
        
        cell.likeAction = {() in
            if discussion.likeStatus == false {
                discussion.likeStatus = true
                cell.likeCountLabel.text = "\(discussion.likeCount+1) Likes"
                self.setupDiscussionLikeApi(discussionId: discussion.id)
            } else {
                discussion.likeStatus = false
                cell.likeCountLabel.text = "\(discussion.likeCount-1) Likes"
                self.setupDiscussionDislikeApi(likeId: discussion.like!.id)
            }
            self.setLikeButtonState(button: cell.likeButton, discussion: discussion)
        }
        
        cell.commentAction = {() in
            self.performSegue(withIdentifier: "discussionDetailSegue", sender: self)
        }
    
        setLikeButtonState(button: cell.likeButton, discussion: discussion)
        cell.memberNameLabel.text = discussion.user.name
        cell.discussionLabel.text = discussion.text
        cell.commentCountLabel.text = "\(discussion.commentCount) Comments"
        cell.likeCountLabel.text = "\(discussion.likeCount) Likes"

        return cell
    }
    
    
}
