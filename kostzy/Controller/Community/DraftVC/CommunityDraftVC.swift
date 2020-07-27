//
//  Community-DraftVC.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 24/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class CommunityDraftVC: UIViewController {
    
    // MARK: - Variable
    private var hiddenCells: [CommunityDraftCollectionCell] = []
    private var expandedCell: CommunityDraftCollectionCell?
    private var isStatusBarHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    
    // MARK: - Array
    let communityImage = ["Kost Area Anggrek Cakra",
                          "Kost Area Kijang",
                          "Kost Area Rawa Belong",
                          "Kost Area Sandang",
                          "Kost Area Syahdan",
                          "Kost Area U"]
    let communityName = ["Kost Area Anggrek Cakra",
                         "Kost Area Kijang",
                         "Kost Area Rawa Belong",
                         "Kost Area Sandang",
                         "Kost Area Syahdan",
                         "Kost Area U"]
    let communityDescription = ["Diskusi bebas seputaran daerah Anggrek Cakra. Yuk gabung!",
                                "Sini sini gausah malu-malu! Kita saling melengkapi aja yah :)",
                                "Mariiiiii anak kost sekitaran Rawa Belong berkumpul disini!",
                                "Eitssss yang bukan anak Sandang dilarang join :p",
                                "Yang kepo kepo tentang susahnya nge-kost di Syahdan cusss gabung.",
                                "UUUUUUUUUUUUUUUUUU? Mantap"]

   
    // MARK: - IBOutlet
    @IBOutlet weak var communityCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        communityCollectionView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9921568627, alpha: 1)
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

extension CommunityDraftVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource
    /*
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    */

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return communityName.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommunityDraftCollectionCell", for: indexPath) as! CommunityDraftCollectionCell
        
        // Configure the cell...
        if isDarkMode == true {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9921568627, alpha: 1)
            cell.communityView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9921568627, alpha: 1)
            cell.communityView.shadowColor = .black
            cell.communityView.shadowOffset = CGSize(width: 0, height: 0)
            cell.communityView.shadowRadius = 4
            cell.communityView.shadowOpacity = 0.2
        }
        else {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9921568627, alpha: 1)
            cell.communityView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9921568627, alpha: 1)
            cell.communityView.shadowColor = .black
            cell.communityView.shadowOffset = CGSize(width: 0, height: 0)
            cell.communityView.shadowRadius = 4
            cell.communityView.shadowOpacity = 0.2
        }
        cell.communityView.cornerRadius = 5
        cell.communityImageView.image = UIImage(named: communityImage[indexPath.row])
        cell.communityNameLabel.text = communityName[indexPath.row]
        cell.communityDescriptionLabel.text = communityDescription[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if communityCollectionView.contentOffset.y < 0 ||
            communityCollectionView.contentOffset.y > communityCollectionView.contentSize.height - communityCollectionView.frame.height {
            return
        }
        
        
        let dampingRatio: CGFloat = 0.8
        let initialVelocity: CGVector = CGVector.zero
        let springParameters: UISpringTimingParameters = UISpringTimingParameters(dampingRatio: dampingRatio, initialVelocity: initialVelocity)
        let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: springParameters)
        
        
        self.view.isUserInteractionEnabled = false
        
        if let selectedCell = expandedCell {
            isStatusBarHidden = false
            
            animator.addAnimations {
                selectedCell.collapse()
                
                for cell in self.hiddenCells {
                    cell.show()
                }
            }
            
            animator.addCompletion { _ in
                self.communityCollectionView.isScrollEnabled = true
                
                self.expandedCell = nil
                self.hiddenCells.removeAll()
            }
        } else {
            isStatusBarHidden = true
            
            communityCollectionView.isScrollEnabled = false
            
            let selectedCell = communityCollectionView.cellForItem(at: indexPath)! as! CommunityDraftCollectionCell
            let frameOfSelectedCell = selectedCell.frame
            
            expandedCell = selectedCell
            hiddenCells = communityCollectionView.visibleCells.map { $0 as! CommunityDraftCollectionCell }.filter { $0 != selectedCell }
            
            animator.addAnimations {
                selectedCell.expand(in: collectionView)
                
                for cell in self.hiddenCells {
                    cell.hide(in: self.communityCollectionView, frameOfSelectedCell: frameOfSelectedCell)
                }
            }
        }
        
        
        animator.addAnimations {
            self.setNeedsStatusBarAppearanceUpdate()
        }

        animator.addCompletion { _ in
            self.view.isUserInteractionEnabled = true
        }
        
        animator.startAnimation()
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
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 600, height: 128)
    }
    */
}
