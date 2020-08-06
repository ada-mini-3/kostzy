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
    
    // MARK: - Arrays
    /*var image = ["My Community Dummy Data 2",
                 "My Community Dummy Data 2 2",
                 "My Community Dummy Data 2",
                 "My Community Dummy Data 2 2",
                 "My Community Dummy Data 2",
                 "My Community Dummy Data 2 2",
                 "My Community Dummy Data 2",
                 "My Community Dummy Data 2 2",
                 "My Community Dummy Data 2",
                 "My Community Dummy Data 2 2"]
    var community = ["Kost Area Anggrek Cakra",
                     "Kost Area Binus Syahdan",
                     "Kost Area Anggrek Cakra",
                     "Kost Area Binus Syahdan",
                     "Kost Area Anggrek Cakra",
                     "Kost Area Binus Syahdan",
                     "Kost Area Anggrek Cakra",
                     "Kost Area Binus Syahdan",
                     "Kost Area Anggrek Cakra",
                     "Kost Area Binus Syahdan"]*/

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Community.myCommunity.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCommunityCell", for: indexPath) as! MyCommunityCell
        cell.myCommunityImage.image = UIImage(named: Community.myCommunity[indexPath.row].communityImage!)
        cell.myCommunityLabel.text = Community.myCommunity[indexPath.row].communityName
        
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
    
    var dataSource = DataSource()
    
    
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
        

        myCommunityTableView.delegate = dataSource
        myCommunityTableView.dataSource = dataSource
        
        myCommunityTableView.rowHeight = 60
        myCommunityTableView.estimatedRowHeight = 600
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadProfileData()
        setupView()
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadProfileData()
        setupView()
        
        tableView.reloadData()
        badgeCollectionView.reloadData()
        myCommunityTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        profileAboutMeLabel.sizeToFit()
    }
    
    
    // MARK: - Custom Methods
    func loadProfileData() {
        let savedUserDataDict = defaults.dictionary(forKey: "userDataDict") ?? [String: Any]()
        let userIsLoggedIn = defaults.bool(forKey: "userIsLoggedIn")
        
        if userIsLoggedIn == true {
            setupImageView()
            profileNameLabel.text = savedUserDataDict["userName"] as? String
            profileTitleLabel.text = profileTitlePlaceholderText
            userLike = userLikePlaceholderNumber
            profileAboutMeLabel.text = profileAboutMePlaceholderText
        }
        else if userIsLoggedIn == false {
            setupImageView()
            profileNameLabel.text = profileNamePlaceholderText
            profileTitleLabel.text = profileTitlePlaceholderText
            userLike = userLikePlaceholderNumber
            profileAboutMeLabel.text = profileAboutMePlaceholderText
        }
        
        if savedUserDataDict["userDesc"] != nil {
            profileAboutMeLabel.text = savedUserDataDict["userDesc"] as? String
        } else {
            profileAboutMeLabel.text = profileAboutMePlaceholderText
        }
    }
    
    func setupView() {
        let userIsLoggedIn = defaults.bool(forKey: "userIsLoggedIn")
        
        if userIsLoggedIn == false {
            editProfileButtonOutlet.isHidden = true
        }
        else {
            editProfileButtonOutlet.isHidden = false
        }
    }
    
    func setupImageView() {
        profileImage.image = loadImageFromDiskWith(fileName: "profileImage")
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    func saveImage(imageName: String, image: UIImage) {
     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            
            return image ?? UIImage(named: profileImagePlaceholderImage)
        }
        
        return nil
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
        let floatXP = Float(userLike ?? 0)
    
        // Configure the cell
        cell.likeProgressView.setProgress(floatXP / 600, animated: true)
        print(floatXP / 600)
        
        if userLike ?? 0 >= 100 {
            cell.like100DotView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3098039216, blue: 0.7882352941, alpha: 1)
        }
        if userLike ?? 0 >= 200 {
            cell.like200DotView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3098039216, blue: 0.7882352941, alpha: 1)
        }
        if userLike ?? 0 >= 300 {
            cell.like300DotView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3098039216, blue: 0.7882352941, alpha: 1)
        }
        if userLike ?? 0 >= 400 {
            cell.like400DotView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3098039216, blue: 0.7882352941, alpha: 1)
        }
        if userLike ?? 0 >= 500 {
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
