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
    
    
    // MARK: - Array
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var memberCollectionView: UICollectionView!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    @IBOutlet weak var communityDetailImageView: UIImageView!
    @IBOutlet weak var communityNameLabel: UILabel!
    @IBOutlet weak var communityLocationLabel: UILabel!
    @IBOutlet weak var communityDescriptionLabel: UILabel!
    @IBOutlet weak var aboutAndDiscussionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var memberCountLabel: UILabel!
    
    @IBOutlet weak var segmentedControlSeparator: UIView!
    @IBOutlet weak var albumPlaceholderTextLabel: UILabel!
    
    @IBOutlet weak var requestJoinButtonOutlet: DesignableButton!
    
    @IBOutlet weak var memberCountSeparatorConstraint: NSLayoutConstraint!
    @IBOutlet weak var requestJoinSeparatorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        communityDetailImageView.image = UIImage(named: communityImage[selectedRow!])
//        communityNameLabel.text = communityName[selectedRow!]
//        communityLocationLabel.text = "\(communityLocation[selectedRow!]) • \(communityPost[selectedRow!]) POSTS"
        communityDescriptionLabel.text = communityDescription[selectedRow!]
        
        /* memberCountLabel.text = "\(memberCount[selectedRow!]) Members" */
        memberCountLabel.text = "\(memberName.count) Members"
        
        debugCustomization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        memberCollectionView.reloadData()
    }
    
    
    // MARK: - IBAction Function
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func requestJoinButtonAction(_ sender: Any) {
        if communityIsRequested[selectedRow!] == false {
            requestJoinButtonOutlet.setTitle("Requested", for: .normal)
            requestJoinButtonOutlet.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.63)
            requestJoinButtonOutlet.backgroundColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            communityIsRequested[selectedRow!] = true
            communityIsJoined[selectedRow!] = true
            
            Community.myCommunity.append(Community(communityImage: communityImage[selectedRow!], communityName: communityName[selectedRow!], communityBrief: communityBrief[selectedRow!], communityLocation: communityLocation[selectedRow!], communityPost: communityPost[selectedRow!], communityDescription: communityDescription[selectedRow!], communityAlbumImage: communityAlbumImage[selectedRow!], memberCount: memberCount[selectedRow!], memberImage: memberImage[selectedRow!], memberName: memberName[selectedRow!], memberRole: memberRole[selectedRow!], memberIsAdmin: memberIsAdmin, isRequested: communityIsRequested[selectedRow!], isJoined: communityIsJoined[selectedRow!]))
            
            print("Requested: \(communityIsRequested[selectedRow!])")
        }
        else if communityIsRequested[selectedRow!] == true {
            let alert = UIAlertController(title: "Are you sure you want to cancel the request?", message: "You will still be able to request to join the community later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                
                self.requestJoinButtonOutlet.setTitle("Request Join", for: .normal)
                self.requestJoinButtonOutlet.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.requestJoinButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 0.7813850045, blue: 0.09716629237, alpha: 1)
                communityIsRequested[self.selectedRow!] = false
                communityIsJoined[self.selectedRow!] = false
                
                Community.myCommunity.remove(at: self.selectedRow!)
                
                print("Request Join: \(communityIsRequested[self.selectedRow!])")
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
        if communityIsRequested[selectedRow!] == false {
//            aboutAndDiscussionSegmentedControl.isHidden = true
            albumPlaceholderTextLabel.isHidden = true
            albumCollectionView.isHidden = true
            
//            memberCountSeparatorConstraint.constant = 16
            requestJoinSeparatorConstraint.constant = 20
        }
        else if communityIsRequested[selectedRow!] == true {
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
