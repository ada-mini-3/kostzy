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
    
    
    //----------------------------------------------------------------
    // MARK:- Memory Management Methods
    //----------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //----------------------------------------------------------------
    // MARK:- Action Methods
    //----------------------------------------------------------------
    @IBAction func newDiscussionButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "newDiscussionSegue", sender: self)
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
        
        DispatchQueue.main.async(execute: {
            self.discussionTableView.reloadData()

            //In my case i had to call this method after some delay, because (i think) it will allow tableView to reload completely and then calculate the height required for itself. (This might be a workaround, but it worked for me)
            self.perform(#selector(self.adjustHeightOfTableview), with: nil)
        })
    }
    
    override func viewDidLayoutSubviews() {
        /* perform(#selector(self.adjustHeightOfTableview), with: nil) */
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
                dest.uName = memberName[selectedRow]
                dest.uImage = UIImage(named: memberImage[selectedRow])
                dest.discussion = discussion[selectedRow]
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
        selectedRow = indexPath.row
        print(selectedRow)
        performSegue(withIdentifier: "discussionDetailSegue", sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discussion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityDiscussionCell", for: indexPath) as! CommunityDiscussionCell

        // Configure the cell...
        if isDarkMode == true {
            cell.discussionView.backgroundColor = .systemGray5
        }
        else {
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.discussionView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9921568627, alpha: 1)
            cell.discussionView.shadowColor = .black
            cell.discussionView.shadowOffset = CGSize(width: 0, height: 0)
            cell.discussionView.shadowRadius = 2
            cell.discussionView.shadowOpacity = 0.3
        }
        cell.discussionView.cornerRadius = 10
        
        cell.memberImageView.image = UIImage(named: memberImage[indexPath.row])
        cell.memberNameLabel.text = memberName[indexPath.row]
        cell.discussionLabel.text = discussion[indexPath.row]
        cell.commentCountLabel.text = "\(commentCount[indexPath.row]) Comments"
        cell.likeCountLabel.text = "\(likeCount[indexPath.row]) Likes"

        return cell
    }
    
    
}
