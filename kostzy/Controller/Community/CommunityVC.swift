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
    var communityData: [Community] = []
    var apiManager = BaseAPIManager()
    var defaults = UserDefaults.standard
    var selectedRow: Int?
    
    // MARK: - IBOutlet
    @IBOutlet weak var communityTableView: UITableView!
    @IBOutlet weak var locationButtonOutlet: UIButton!
    @IBOutlet weak var communityIndicator: UIActivityIndicatorView!
    
    // MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCommunityData()
        setupLocationButton()
    }
    
    private func fetchCommunityData() {
        self.communityTableView.delegate = nil
        self.communityTableView.dataSource = nil
        var theToken = ""
        if let token = defaults.dictionary(forKey: "userToken") {
            theToken = "Token \(token["token"]!)"
        }
        apiManager.performGenericFetchRequest(urlString: "\(apiManager.baseUrl)community/", token: theToken, errorMsg: {
            print("Error Kak")
        }) { (communties: [Community]) in
            DispatchQueue.main.async {
                self.communityData = communties
                self.communityIndicator.stopAnimating()
                self.communityTableView.delegate = self
                self.communityTableView.dataSource = self
                self.communityTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        communityTableView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
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
        return communityData.count
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
            cell.contentView.backgroundColor = .systemBackground
            cell.communityView.backgroundColor = .systemGray5
        }
        else {
            cell.contentView.backgroundColor = .systemBackground
            cell.communityView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9921568627, alpha: 1)
            cell.communityView.shadowColor = .black
            cell.communityView.shadowOffset = CGSize(width: 0, height: 0)
            cell.communityView.shadowRadius = 4
            cell.communityView.shadowOpacity = 0.2
        }
        cell.communityView.cornerRadius = 5
        cell.communityImage.cornerRadius = 5
        cell.communityImage.loadImageFromUrl(url: URL(string: communityData[indexPath.row].image)!)
        cell.communityNameLabel.text = communityData[indexPath.row].name
        cell.communityBriefLabel.text = communityData[indexPath.row].subtitle

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
        performSegue(withIdentifier: "CommunityDetailSegue", sender: communityData[indexPath.row])
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
        if segue.identifier == "CommunityDetailSegue"{
            if let destination = segue.destination as? CommunityDetailContainerVC {
                let community = sender as? Community
                destination.community = community
                destination.selectedRow = selectedRow
            }
        }
    }
}
