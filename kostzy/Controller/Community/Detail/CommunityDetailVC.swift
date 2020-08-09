//
//  CommunityDetailVC.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 24/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class CommunityDetailVC: UIViewController {

    
    // MARK: - Variable
    var selectedRow: Int?
    var community: Community?
    var defaults = UserDefaults.standard
    var apiManager = BaseAPIManager()
    // MARK: - Array
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var memberCollectionView: UICollectionView!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBOutlet weak var communityDescriptionLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var albumPlaceholderTextLabel: UILabel!
    @IBOutlet weak var requestJoinButtonOutlet: DesignableButton!
    @IBOutlet weak var requestJoinSeparatorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        communityDetailImageView.image = UIImage(named: communityImage[selectedRow!])
//        communityNameLabel.text = communityName[selectedRow!]
      // communityLocationLabel.text = "\(communityLocation[selectedRow!]) • \(communityPost[selectedRow!]) POSTS"
        if let community = self.community {
            communityDescriptionLabel.text = community.description
        }
       
        /* memberCountLabel.text = "\(memberCount[selectedRow!]) Members" */
        memberCountLabel.text = "\(memberName.count) Members"
        setupRequestButton()
        debugCustomization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        memberCollectionView.reloadData()
    }
    
    private func setupRequestButton() {
        guard let community = community else { return }
        let isRequested = defaults.bool(forKey: "requestComm\(community.id)")
        if isRequested == true {
            requestJoinButtonOutlet.setTitle("Requested", for: .normal)
            requestJoinButtonOutlet.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.63)
            requestJoinButtonOutlet.backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        } else {
            self.requestJoinButtonOutlet.setTitle("Request Join", for: .normal)
            self.requestJoinButtonOutlet.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.requestJoinButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 0.7813850045, blue: 0.09716629237, alpha: 1)
        }
    }
    
    private func setupRequestJoinApi(token: String) {
        let payload = ["is_joined": false]
        requestJoinButtonOutlet.backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.requestJoinButtonOutlet.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.63)
        guard let community = community else { return }
        apiManager.performPostRequest(payload: payload, url: "\(apiManager.baseUrl)community/\(community.id)/member-request/", token: "Token \(token)") { (data, response, error) in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                        self.setupAlert(title: "Success!",msg: "You've Successfully Requested To Join \(self.community!.name)!")
                        self.requestJoinButtonOutlet.setTitle("Requested", for: .normal)
                        self.defaults.set(true, forKey: "requestComm\(community.id)")
                    default:
                        print(response.statusCode)
                        self.requestJoinButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 0.7813850045, blue: 0.09716629237, alpha: 1)
                        self.requestJoinButtonOutlet.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        self.setupAlert(msg: "Something went wrong, Please try again later")
                    }
                } else if let error = error {
                    self.setupAlert(msg: error.localizedDescription)
                }
            }
        }
    }
    
    private func setupAlert(title: String =  "Whoops!", msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func setupLoginPage() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - IBAction Function
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func requestJoinButtonAction(_ sender: Any) {
        guard let community = community else { return }
        let isRequested = defaults.bool(forKey: "requestComm\(community.id)")
        guard let token = defaults.dictionary(forKey: "userToken") else {
            setupLoginPage()
            return
        }
        if isRequested == false {
            setupRequestJoinApi(token: token["token"] as! String)
        } else {
            let alert = UIAlertController(title: "Are you sure you want to cancel the request?", message: "You will still be able to request to join the community later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                
                self.requestJoinButtonOutlet.setTitle("Request Join", for: .normal)
                self.requestJoinButtonOutlet.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.requestJoinButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 0.7813850045, blue: 0.09716629237, alpha: 1)
                communityIsJoined[self.selectedRow!] = false
                self.defaults.set(false, forKey: "requestComm\(community.id)")
            }))
            self.present(alert, animated: true)
        }
    }
    
    
    // MARK: - Function
    // Uncomment for a proper button view
    /* func customization() {
        if communityIsRequested[selectedRow!] == false {
            requestJoinButtonOutlet.setTitle("Request Join", for: .normal)
            requestJoinButtonOutlet.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            requestJoinButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 0.7813850045, blue: 0.09716629237, alpha: 1)
        }
        else if communityIsRequested[selectedRow!] == true {
            requestJoinButtonOutlet.setTitle("Requested", for: .normal)
            requestJoinButtonOutlet.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.63)
            requestJoinButtonOutlet.backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        }
    } */
    
    // Delete or comment this function when user testing is finished
    func debugCustomization() {
        guard let community = community else { return }
        //let isRequested = defaults.bool(forKey: "requestComm\(community.id)")
        if community.isJoined == false {
//            aboutAndDiscussionSegmentedControl.isHidden = true
            albumPlaceholderTextLabel.isHidden = true
            albumCollectionView.isHidden = true
            
//            memberCountSeparatorConstraint.constant = 16
            requestJoinSeparatorConstraint.constant = 20
        } else {
//            let segmentedControlTitle = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
//            aboutAndDiscussionSegmentedControl.setTitleTextAttributes(segmentedControlTitle, for: .selected)
            requestJoinButtonOutlet.isHidden = true
            requestJoinSeparatorConstraint.constant = 120
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CommunityDetailVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if collectionView == memberCollectionView {
            return memberName.count
        }
        
        return communityAlbumImage.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let memberCell = memberCollectionView.dequeueReusableCell(withReuseIdentifier: "CommunityMemberCollectionCell", for: indexPath) as! CommunityMemberCollectionCell
        let albumCell = albumCollectionView.dequeueReusableCell(withReuseIdentifier: "CommunityAlbumCollectionCell", for: indexPath) as! CommunityAlbumCollectionCell
    
        // Configure the cell
        if collectionView == memberCollectionView {
            memberCell.memberImageView.image = UIImage(named: memberImage[indexPath.row])
            memberCell.memberNameLabel.text = memberName[indexPath.row]
            memberCell.memberRoleLabel.text = memberRole[indexPath.row]
            
            return memberCell
        }
        else {
            albumCell.albumImageView.image = UIImage(named: communityAlbumImage[indexPath.row])
        }
        
        return albumCell
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
        return CGSize(width: 90, height: 100)
    }
    
    
}
