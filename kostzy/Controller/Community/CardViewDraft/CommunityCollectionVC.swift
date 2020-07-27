//
//  CommunityCollectionVC.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 24/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class CommunityCollectionVC: UICollectionViewController {
    
    private var hiddenCells: [CommunityCollectionCell] = []
    private var expandedCell: CommunityCollectionCell?
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
    
    // MARK: - UICollectionViewDelegates
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return communityName.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommunityCollectionCell", for: indexPath) as! CommunityCollectionCell
        
        cell.communityImageView.image = UIImage(named: communityImage[indexPath.row])
        cell.communityNameLabel.text = communityName[indexPath.row]
        cell.communityDescriptionLabel.text = communityDescription[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.contentOffset.y < 0 ||
            collectionView.contentOffset.y > collectionView.contentSize.height - collectionView.frame.height {
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
                collectionView.isScrollEnabled = true
                
                self.expandedCell = nil
                self.hiddenCells.removeAll()
            }
        } else {
            isStatusBarHidden = true
            
            collectionView.isScrollEnabled = false
            
            let selectedCell = collectionView.cellForItem(at: indexPath)! as! CommunityCollectionCell
            let frameOfSelectedCell = selectedCell.frame
            
            expandedCell = selectedCell
            hiddenCells = collectionView.visibleCells.map { $0 as! CommunityCollectionCell }.filter { $0 != selectedCell }
            
            animator.addAnimations {
                selectedCell.expand(in: collectionView)
                
                for cell in self.hiddenCells {
                    cell.hide(in: collectionView, frameOfSelectedCell: frameOfSelectedCell)
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

}
