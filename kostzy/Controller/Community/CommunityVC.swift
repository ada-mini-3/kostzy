//
//  CommunityController.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class CommunityVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variable
    var location: Location?
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var communityTableView: UITableView!
    
    @IBOutlet weak var locationButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLocationButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        communityTableView.reloadData()
    }
    
    
    // MARK: - IBAction Function
    @IBAction func unwindSegueToCommunity(_ sender: UIStoryboardSegue) {
        setupLocationButton()
    }
    
    @IBAction func locationButtonAction(_ sender: Any) {
        
    }
    
    
    // MARK: - Function
    func setupLocationButton() {
        if location == nil {
            locationButtonOutlet.setTitle("Slipi", for: .normal)
        }
        else {
            locationButtonOutlet.setTitle(location?.name, for: .normal)
        }
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return communityName.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if isDarkMode ==  true {
            (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.black
            (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
        }
        else {
            (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.white
            (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.black
        }
    }

//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = communityTableView.dequeueReusableCell(withIdentifier: "CommunityCell", for: indexPath) as! CommunityCell

        // Configure the cell...
        if isDarkMode == true {
            cell.communityView.backgroundColor = .systemGray5
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
        cell.communityImage.cornerRadius = 5
        cell.communityImage.image = UIImage(named: communityImage[indexPath.row])
        cell.communityNameLabel.text = communityName[indexPath.row]
        cell.communityBriefLabel.text = communityBrief[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 296
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "CommunityDetailSegue", sender: indexPath.row)
    }
    

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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CommunityDetailSegue"{
            if let destination = segue.destination as? CommunityDetailContainerVC {
                let selectedRow = sender as? Int
                
                destination.selectedRow = selectedRow
            }
        }
    }
}
