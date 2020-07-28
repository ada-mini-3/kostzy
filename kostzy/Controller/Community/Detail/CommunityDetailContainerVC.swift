//
//  CommunityDetailContainerVC.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 27/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class CommunityDetailContainerVC: UIViewController {
    
    //----------------------------------------------------------------
    // MARK:- Outlets
    //----------------------------------------------------------------
    
    @IBOutlet weak var communityDetailImageView: UIImageView!
    @IBOutlet weak var communityNameLabel: UILabel!
    @IBOutlet weak var communityLocationLabel: UILabel!
    @IBOutlet weak var aboutAndDiscussionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var newDiscussionButtonOutlet: UIButton!
    @IBOutlet weak var sortByButtonOutlet: UIButton!
    
    @IBOutlet weak var communityDetailContainerView: UIView!

    
    //----------------------------------------------------------------
    // MARK:- Constraints Outlets
    //----------------------------------------------------------------
    
    @IBOutlet weak var containerSeparatorTopConstraint: NSLayoutConstraint!
    var containerViewHeightConstraint: NSLayoutConstraint!
    /*
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    */
    
    
    //----------------------------------------------------------------
    // MARK:- Variables
    //----------------------------------------------------------------
    
    var selectedRow: Int?
    var containerViewheight: CGFloat!
    
    private lazy var CommunityAboutVC: CommunityDetailVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Community", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "CommunityDetailVC") as! CommunityDetailVC
        viewController.selectedRow = selectedRow
        containerViewheight = 460
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var CommunityDiscussionVC: DetailDiscussionVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Community", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "DetailDiscussionVC") as! DetailDiscussionVC
        containerViewheight = 1140
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    
    //----------------------------------------------------------------\
    // MARK:- Abstract Method
    //----------------------------------------------------------------
    
    static func viewController() -> CommunityDetailContainerVC {
        return UIStoryboard.init(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "CommunityDetailContainerVC") as! CommunityDetailContainerVC
    }
    
    
    //----------------------------------------------------------------
    // MARK:- Memory Management Methods
    //----------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //----------------------------------------------------------------
    // MARK:- Action Methods
    //----------------------------------------------------------------
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func aboutAndDiscussionSegmentedControlAction(_ sender: Any) {
        updateView()
    }
    
    
    //----------------------------------------------------------------
    // MARK:- Custom Methods
    //----------------------------------------------------------------
    
    private func add(asChildViewController viewController: UIViewController) {
        
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        communityDetailContainerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = communityDetailContainerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    //----------------------------------------------------------------
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    //----------------------------------------------------------------
    
    private func updateView() {
        if aboutAndDiscussionSegmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: CommunityDiscussionVC)
            add(asChildViewController: CommunityAboutVC)
            
            newDiscussionButtonOutlet.isHidden = true
            sortByButtonOutlet.isHidden = true
        } else {
            remove(asChildViewController: CommunityAboutVC)
            add(asChildViewController: CommunityDiscussionVC)
            
            newDiscussionButtonOutlet.isHidden = false
            sortByButtonOutlet.isHidden = false
        }
    }
    
    //----------------------------------------------------------------
    
    func setupView() {
//        setupSegmentedControl()
        
        updateView()
    }
    
    // Delete or comment this function when user testing is finished
    func debugCustomization() {
        if communityIsRequested[selectedRow!] == false {
            aboutAndDiscussionSegmentedControl.isHidden = true
            newDiscussionButtonOutlet.isHidden = true
            sortByButtonOutlet.isHidden = true
            
            containerSeparatorTopConstraint.constant = 20
        }
        else if communityIsRequested[selectedRow!] == true {
            let segmentedControlTitle = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
            aboutAndDiscussionSegmentedControl.setTitleTextAttributes(segmentedControlTitle, for: .selected)
        }
    }
    
    @objc func adjustHeightOfContainerView() {
        /*
            Here you have to take care of two things, if there is only tableView on the screen then you have to see is your tableView going below screen using maxHeight and your screen height,
         Or you can add your tableView inside scrollView so that your tableView can increase its height as much it requires based on the number of cell (with different height based on content) it has to display.
           */
        
        // now set the height constraint accordingly
        containerViewHeightConstraint = communityDetailContainerView.heightAnchor.constraint(equalToConstant: containerViewheight)
        
        NSLayoutConstraint.activate([
            containerViewHeightConstraint
        ])
        print("Container View Height Constraint: \(String(describing: containerViewHeightConstraint))")

        //If you want to increase tableView height with animation you can do that as below.

        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    /*
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        if let child = container as? DetailDiscussionVC {
            containerViewHeightConstraint.constant = child.preferredContentSize.height
            communityDetailContainerView.updateConstraints()
        }
    }
    */
    
    
    //----------------------------------------------------------------
    // MARK:- View Life Cycle Methods
    //----------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        communityDetailImageView.image = UIImage(named: communityImage[selectedRow!])
        communityNameLabel.text = communityName[selectedRow!]
        communityLocationLabel.text = "\(communityLocation[selectedRow!]) • \(communityPost[selectedRow!]) POSTS"
        
        debugCustomization()
        setupView()
    }
    
    //----------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //----------------------------------------------------------------
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        DispatchQueue.main.async(execute: {
            //In my case i had to call this method after some delay, because (i think) it will allow tableView to reload completely and then calculate the height required for itself. (This might be a workaround, but it worked for me)
            self.perform(#selector(self.adjustHeightOfContainerView), with: nil)
        })
        */
    }
    
    
    //----------------------------------------------------------------
    // MARK: - Navigation
    //----------------------------------------------------------------

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
