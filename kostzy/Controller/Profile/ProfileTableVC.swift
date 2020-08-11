//
//  ProfileTableVC.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 22/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit


// MARK: - DataSource
class DataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var communities = [CommunityProfile]()
    let baseUrl = "http://34.101.87.22:8000"

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCommunityCell", for: indexPath) as! MyCommunityCell
        let community = communities[indexPath.row]
        cell.myCommunityImage.loadImageFromUrl(url: URL(string: baseUrl + community.image)!)
        cell.myCommunityLabel.text = community.name
        
        return cell
    }
}


// MARK: - ProfileTableVC
class ProfileTableVC: UITableViewController {
    
    // MARK: - Variables
    let defaults = UserDefaults.standard
    let notificationCenter = NotificationCenter.default
    
    let profileImagePlaceholderImage = "Empty Profile Picture"
    let profileNamePlaceholderText = "User"
    let profileTitlePlaceholderText = "Kostzy Beginner"
    let userLikePlaceholderNumber = 0
    let profileAboutMePlaceholderText = "There's no description."
    var userLike: Int?
    let apiManager = BaseAPIManager()
    
    var dataSource = DataSource()
    var profile: Profile?
    
    // MARK: - IBOutlets
    @IBOutlet weak var badgeCollectionView: UICollectionView!
    @IBOutlet weak var myCommunityTableView: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileTitleLabel: UILabel!
    @IBOutlet weak var profileAboutMeLabel: UILabel!
    @IBOutlet weak var editProfileButtonOutlet: UIButton!
    
    
    // MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
        
        myCommunityTableView.rowHeight = 60
        myCommunityTableView.estimatedRowHeight = 600
        
        setupRefreshControl()
        setupImageView()
        setupBtnEdit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadProfileData()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadProfileData()
        setupBtnEdit()
        
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        profileAboutMeLabel.sizeToFit()
    }
    
    
    // MARK: - Custom Methods
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadProfileData()
        }
    }
    
    func setupRefreshControl() {
        refreshControl?.attributedTitle = NSAttributedString(string: "Fetching Profile Data")
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }
    
    func loadProfileData() {
        let userIsLoggedIn = defaults.bool(forKey: "userIsLoggedIn")
        guard let token = defaults.dictionary(forKey: "userToken") else { return }
        let theToken = "Token \(token["token"]!)"
        editProfileButtonOutlet.isEnabled = false
        if userIsLoggedIn == true {
            apiManager.performGenericFetchRequest(urlString: "\(BaseAPIManager.authUrl)profile/", token: theToken,
            errorMsg: {
                print("Error Kak")
            }) { (user: Profile) in
                DispatchQueue.main.async {
                    self.profile = user
                    self.editProfileButtonOutlet.isEnabled = true
                    self.profileNameLabel.text = user.name
                    if let image = user.image {
                        self.profileImage.loadImageFromUrl(url: URL(string: image)!)
                    } else {
                        self.profileImage.image = UIImage(named: self.profileImagePlaceholderImage)
                    }
                    if user.about == "" {
                        self.profileAboutMeLabel.text = self.profileAboutMePlaceholderText
                    } else {
                        self.profileAboutMeLabel.text = user.about
                    }
                    self.userLike = user.exp
                    self.dataSource.communities = user.community
                    self.refreshControl?.endRefreshing()
                    self.myCommunityTableView.delegate = self.dataSource
                    self.myCommunityTableView.dataSource = self.dataSource
                    self.badgeCollectionView.reloadData()
                    self.myCommunityTableView.reloadData()
                }
            }
        } else {
            profileImage.image = UIImage(named: profileImagePlaceholderImage)
            profileNameLabel.text = profileNamePlaceholderText
            profileTitleLabel.text = profileTitlePlaceholderText
            userLike = userLikePlaceholderNumber
            profileAboutMeLabel.text = profileAboutMePlaceholderText
        }
    }
    
    func setupImageView() {
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    func setupBtnEdit() {
        let userIsLoggedIn = defaults.bool(forKey: "userIsLoggedIn")
        
        if userIsLoggedIn == false {
            editProfileButtonOutlet.isHidden = true
        }
        else {
            editProfileButtonOutlet.isHidden = false
        }
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 3 {
            let height: CGFloat = myCommunityTableView.estimatedRowHeight
                        
            return height
        }

        return UITableView.automaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileSegue" {
            guard let destFirst = segue.destination as? UINavigationController else { return }
            guard let targetController = destFirst.topViewController as? EditProfileVC else { return }
            guard let theProfile = self.profile else { return }
            targetController.profile = theProfile
        }
    }
    
    
    @IBAction func editProfileClicked(_ sender: Any) {
        performSegue(withIdentifier: "editProfileSegue", sender: self)
    }
    
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    */

    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension ProfileTableVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCollectionCell", for: indexPath) as! BadgeCollectionCell
        let floatXP = Float(profile?.exp ?? 0)
        
        // Configure the cell
        cell.likeProgressView.setProgress(floatXP / 600, animated: true)
        print(floatXP / 600)
        print(profile?.exp, "EXP")
        
        if profile?.exp ?? 0 >= 100 {
            cell.like100DotView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3098039216, blue: 0.7882352941, alpha: 1)
        }
        if profile?.exp ?? 0 >= 200 {
            cell.like200DotView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3098039216, blue: 0.7882352941, alpha: 1)
        }
        if profile?.exp ?? 0 >= 300 {
            cell.like300DotView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3098039216, blue: 0.7882352941, alpha: 1)
        }
        if profile?.exp ?? 0 >= 400 {
            cell.like400DotView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3098039216, blue: 0.7882352941, alpha: 1)
        }
        if profile?.exp ?? 0 >= 500 {
            cell.like500DotView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3098039216, blue: 0.7882352941, alpha: 1)
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 600, height: 128)
    }
    
  @IBAction func unwindToProfile (_ sender: UIStoryboardSegue) {
        loadProfileData()
        tableView.reloadData()
    }
    
}
