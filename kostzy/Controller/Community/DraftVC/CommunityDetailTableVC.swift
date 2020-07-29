//
//  CommunityDetailTableVC.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 28/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class CommunityDetailTableVC: UITableViewController {
    
    //----------------------------------------------------------------
    // MARK:- Outlets
    //----------------------------------------------------------------
    
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    
    @IBOutlet weak var communityDetailImageView: UIImageView!
    @IBOutlet weak var communityNameLabel: UILabel!
    @IBOutlet weak var communityLocationLabel: UILabel!
    @IBOutlet weak var aboutAndDiscussionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var newDiscussionButtonOutlet: UIButton!
    @IBOutlet weak var sortByButtonOutlet: UIButton!
    
    @IBOutlet weak var communityDetailContainerView: UIView!
    
    
    @IBOutlet var containerViewHeightConstraint: NSLayoutConstraint!
    
    //----------------------------------------------------------------
    // MARK:- Variables
    //----------------------------------------------------------------
    
    var selectedRow: Int?
    
    private lazy var CommunityAboutVC: CommunityDetailVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Community", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "CommunityDetailVC") as! CommunityDetailVC
        viewController.selectedRow = selectedRow
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var CommunityDiscussionVC: DetailDiscussionVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Community", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "DetailDiscussionVC") as! DetailDiscussionVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    
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
            
            containerViewHeightConstraint.constant = 460
            
            /*
            DispatchQueue.main.async(execute: {
                //In my case i had to call this method after some delay, because (i think) it will allow tableView to reload completely and then calculate the height required for itself. (This might be a workaround, but it worked for me)
                self.perform(#selector(self.adjustHeightOfContainerView), with: nil)
                self.communityDetailContainerView.updateConstraints()
            })
            */
        } else {
            remove(asChildViewController: CommunityAboutVC)
            add(asChildViewController: CommunityDiscussionVC)
                
            newDiscussionButtonOutlet.isHidden = false
            sortByButtonOutlet.isHidden = false
            
            containerViewHeightConstraint.constant = 1220
            
            /*
            DispatchQueue.main.async(execute: {
                //In my case i had to call this method after some delay, because (i think) it will allow tableView to reload completely and then calculate the height required for itself. (This might be a workaround, but it worked for me)
                self.perform(#selector(self.adjustHeightOfContainerView), with: nil)
                self.communityDetailContainerView.updateConstraints()
            })
            */
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
        }
        else if communityIsRequested[selectedRow!] == true {
            let segmentedControlTitle = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
            aboutAndDiscussionSegmentedControl.setTitleTextAttributes(segmentedControlTitle, for: .selected)
        }
    }
       
    /*
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
    */
        
        
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        setupView()
    }
    

    //----------------------------------------------------------------
    // MARK:- View Life Cycle Methods
    //----------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationBarTitle.title = communityName[selectedRow!]
        
        communityDetailImageView.image = UIImage(named: communityImage[selectedRow!])
        communityNameLabel.text = communityName[selectedRow!]
        communityLocationLabel.text = "\(communityLocation[selectedRow!]) • \(communityPost[selectedRow!]) POSTS"
        
        debugCustomization()
        setupView()
    }


    //----------------------------------------------------------------
    // MARK: - Table view data source
    //----------------------------------------------------------------

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 4 {
            if aboutAndDiscussionSegmentedControl.selectedSegmentIndex == 0 {
                let height: CGFloat = 500
                return height

            } else {
                let height: CGFloat = 1220
                return height
            }
        }
        if indexPath.row == 0 && indexPath.section == 2 {
            if communityIsRequested[selectedRow!] == false {
                let height: CGFloat = 0
                return height
            }
            else if communityIsRequested[selectedRow!] == true {
                let height: CGFloat = 35
                return height
            }
        }
        if indexPath.row == 0 && indexPath.section == 3 {
            if aboutAndDiscussionSegmentedControl.selectedSegmentIndex == 0 {
                let height: CGFloat = 0
                return height

            } else {
                let height: CGFloat = 28
                return height
            }
        }

        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let segmentedIndexPath = IndexPath(row: 0, section: 2)
//
//        if durationIndexPath == indexPath {
//            if durationPicker.isHidden == true {
//                durationPicker.isHidden = false
//
//                UIView.animate(withDuration: 0.3, animations: { () -> Void in
//                    self.tableView.beginUpdates()
//                    // apple bug fix - some TV lines hide after animation
//                    self.tableView.deselectRow(at: indexPath, animated: true)
//                    self.tableView.endUpdates()
//                })
//            }
//            else {
//                durationPicker.isHidden = true
//
//                UIView.animate(withDuration: 0.3, animations: { () -> Void in
//                    self.tableView.beginUpdates()
//                    // apple bug fix - some TV lines hide after animation
//                    self.tableView.deselectRow(at: indexPath, animated: true)
//                    self.tableView.endUpdates()
//                })
//            }
//        }
//    }

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
