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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topLabel: UILabel!
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
    var community: Community?
    var containerViewheight: CGFloat!
    var percentageVerticalOffset: CGFloat = 0
    
    // variable to save the last position visited, default to zero
    private var lastContentOffset: CGFloat = 0
    
    private lazy var CommunityAboutVC: CommunityDetailVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Community", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "CommunityDetailVC") as! CommunityDetailVC
        viewController.selectedRow = selectedRow
        if let community = self.community {
             viewController.community = community
        }
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var communityDiscussionVC: CommunityDiscussionVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Community", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "DetailDiscussionVC") as! CommunityDiscussionVC
        containerViewheight = viewController.height
        viewController.communityId = self.community?.id
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
    
    @IBAction func createDiscussionAction(_ sender: Any) {
        performSegue(withIdentifier: "createDiscussionSegue", sender: self)
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
            remove(asChildViewController: communityDiscussionVC)
            add(asChildViewController: CommunityAboutVC)
            
            newDiscussionButtonOutlet.isHidden = true
            sortByButtonOutlet.isHidden = true
            
            containerViewheight = 1240
            DispatchQueue.main.async(execute: {
                //In my case i had to call this method after some delay, because (i think) it will allow tableView to reload completely and then calculate the height required for itself. (This might be a workaround, but it worked for me)
                self.perform(#selector(self.adjustHeightOfContainerView), with: nil)
                self.communityDetailContainerView.updateConstraints()
            })
        } else {
            remove(asChildViewController: CommunityAboutVC)
            add(asChildViewController: communityDiscussionVC)
            
            newDiscussionButtonOutlet.isHidden = false
            sortByButtonOutlet.isHidden = false
            
            containerViewheight = 1240
            DispatchQueue.main.async(execute: {
                //In my case i had to call this method after some delay, because (i think) it will allow tableView to reload completely and then calculate the height required for itself. (This might be a workaround, but it worked for me)
                self.perform(#selector(self.adjustHeightOfContainerView), with: nil)
                self.communityDetailContainerView.updateConstraints()
            })
        }
    }
    
    //----------------------------------------------------------------
    
    func setupView() {
//        setupSegmentedControl()
        updateView()
    }
    
    func setupTopView() {
        
        // Uncomment for blur effect
        /*let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = topView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]*/
        
        scrollView.delegate = self
        
        topView.backgroundColor = UIColor.clear
        topLabel.text = community?.name
        topLabel.alpha = 0.0
        
        /*topView.addSubview(blurEffectView)
        topView.sendSubviewToBack(blurEffectView)*/
    }
    
    // Delete or comment this function when user testing is finished
    func debugCustomization() {
        guard let community = community else { return }
        if community.isJoined == false {
            aboutAndDiscussionSegmentedControl.isHidden = true
            newDiscussionButtonOutlet.isHidden = true
            sortByButtonOutlet.isHidden = true
            containerSeparatorTopConstraint.constant = 20
        } else {
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
    
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        setupView()
    }
    
    
    //----------------------------------------------------------------
    // MARK:- View Life Cycle Methods
    //----------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let theCommunity = community else { return }
        
        communityDetailImageView.loadImageFromUrl(url: URL(string: theCommunity.image)!)
        communityNameLabel.text = theCommunity.name
        communityLocationLabel.text = "\(theCommunity.location) • \(communityPost[selectedRow!]) POSTS"
        
        debugCustomization()
        setupView()
        setupTopView()
    }
    
    //----------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //----------------------------------------------------------------
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async(execute: {
            //In my case i had to call this method after some delay, because (i think) it will allow tableView to reload completely and then calculate the height required for itself. (This might be a workaround, but it worked for me)
            self.perform(#selector(self.adjustHeightOfContainerView), with: nil)
        })
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if isDarkMode {
            let white = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: percentageVerticalOffset)
            topView.backgroundColor = white
        }
        else {
            let black = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: percentageVerticalOffset)
            topView.backgroundColor = black
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createDiscussionSegue" {
            if let destFirst = segue.destination as? UINavigationController {
                guard let targetController = destFirst.topViewController as? NewDiscussionTableVC else { return }
                guard let id = community?.id else { return }
                targetController.communityId = id
            }
        }
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


//----------------------------------------------------------------
// MARK: - UIScrollViewDelegate
//----------------------------------------------------------------
extension CommunityDetailContainerVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maximumVerticalOffset = CGFloat(250)
        let currentVerticalOffset = scrollView.contentOffset.y
        percentageVerticalOffset = currentVerticalOffset / maximumVerticalOffset
        print(percentageVerticalOffset)

        if isDarkMode {
            let white = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: percentageVerticalOffset)
            topView.backgroundColor = white
        }
        else {
            let black = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: percentageVerticalOffset)
            topView.backgroundColor = black
        }
        
        if deviceSize == .i5_8Inch && deviceSize == .i6_1Inch && deviceSize == .i6_5Inch {
            if lastContentOffset > scrollView.contentOffset.y && lastContentOffset < scrollView.contentSize.height - scrollView.frame.height && lastContentOffset < 255 {
                // move up
                UIView.animate(withDuration: 0.3) {
                    self.topLabel.alpha = 0
                }
            } else if lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0 && lastContentOffset >= 255 {
                // move down
                UIView.animate(withDuration: 0.3) {
                    self.topLabel.alpha = 1
                }
            }
        }
        else {
            if lastContentOffset > scrollView.contentOffset.y && lastContentOffset < scrollView.contentSize.height - scrollView.frame.height && lastContentOffset < 279 {
                // move up
                UIView.animate(withDuration: 0.3) {
                    self.topLabel.alpha = 0
                }
            } else if lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0 && lastContentOffset >= 279 {
                // move down
                UIView.animate(withDuration: 0.3) {
                    self.topLabel.alpha = 1
                }
            }
        }

        // update the new position acquired
        lastContentOffset = scrollView.contentOffset.y
        //print(lastContentOffset)
    }
}
