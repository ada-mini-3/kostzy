////
////  NotificationTableVC.swift
////  kostzy
////
////  Created by Rayhan Martiza Faluda on 03/08/20.
////  Copyright © 2020 Apple Developer Academy. All rights reserved.
////
//
//import UIKit
//
//
////----------------------------------------------------------------
//// MARK:- Private Function
////----------------------------------------------------------------
//private func firstDayOfMonth(date: Date) -> Date {
//    let calendar = Calendar.current
//    let components = calendar.dateComponents([.year, .month, .day], from: date)
//    return calendar.date(from: components)!
//}
//
//private func parseDate(_ str : String) -> Date {
//    let dateFormat = DateFormatter()
//    dateFormat.dateFormat = "yyyy-MM-dd"
//    return dateFormat.date(from: str)!
//}
//
//
//class NotificationTableVC: UITableViewController {
//
//    //----------------------------------------------------------------
//    // MARK:- Variables
//    //----------------------------------------------------------------
//    /*var notif = Notif.initNotif()*/
//    var notifications = [Notif(date: parseDate("2020-08-04"), userImage: "Other User 1", userName: "Eleanor", time: "Now", userComment: "Liked your post"),
//                 Notif(date: parseDate("2020-08-04"), userImage: "Other User 2", userName: "Kahfi", time: "10m", userComment: "Commented: Itu emang tempatnya pewe banget sih gilaa"),
//                 Notif(date: parseDate("2020-08-04"), userImage: "Other User 2", userName: "Kahfi", time: "11m", userComment: "Liked your post"),
//                 Notif(date: parseDate("2020-08-04"), userImage: "Other User 3", userName: "Justin", time: "20m", userComment: "Liked your post"),
//                 Notif(date: parseDate("2020-08-03"), userImage: "Other User 4", userName: "Emily", time: "1d", userComment: "Liked your post"),
//                 Notif(date: parseDate("2020-08-03"), userImage: "Other User 5", userName: "Tanos", time: "1d", userComment: "Liked your post"),
//                 Notif(date: parseDate("2020-08-03"), userImage: "Other User 6", userName: "Mawar", time: "1d", userComment: "Commented: Gue sih no bgt sama kostan itu.. Ibu kostnya rese trs kamarnya kotor"),
//                 Notif(date: parseDate("2020-08-03"), userImage: "Rais", userName: "Rey", time: "1d", userComment: "Liked your post")]
//    var sections = [GroupedSection<Date, Notif>]()
//
//    
//    //----------------------------------------------------------------
//    // MARK:- View Life Cycle Methods
//    //----------------------------------------------------------------
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        tableView.estimatedRowHeight = 90
//        self.sections = GroupedSection.group(rows: notifications, by: { firstDayOfMonth(date: $0.date) })
//        self.sections.sort { lhs, rhs in lhs.sectionItem > rhs.sectionItem }
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        tableView.reloadData()
//    }
//
//
//    //----------------------------------------------------------------
//    // MARK: - Table view data source
//    //----------------------------------------------------------------
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 90
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return self.sections.count
//    }
//
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
//        view.upperlined()
//        if isDarkMode {
//            view.backgroundColor = .black
//        }
//        else {
//            view.backgroundColor = .white
//        }
//
//        let section = self.sections[section]
//        let date = section.sectionItem
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale.autoupdatingCurrent
//        dateFormatter.doesRelativeDateFormatting = true
//        dateFormatter.timeStyle = .none
//        dateFormatter.dateStyle = .medium
//
//        let dateString: String = dateFormatter.string(from: date)
//
//        let label = UILabel(frame: CGRect(x: 20, y: 10, width: tableView.frame.size.width, height: 20))
//        label.text = dateString
//        label.textColor = UIColor.black
//        label.font = .boldSystemFont(ofSize: 18)
//
//        view.addSubview(label)
//
//        return view
//    }
//
//    /*override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let section = self.sections[section]
//        let date = section.sectionItem
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale.autoupdatingCurrent
//        dateFormatter.doesRelativeDateFormatting = true
//        dateFormatter.timeStyle = .none
//        dateFormatter.dateStyle = .medium
//
//        let dateString: String = dateFormatter.string(from: date)
//
//        return dateString
//    }*/
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        let section = self.sections[section]
//        return section.rows.count
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let notificationCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
//
//        // Configure the cell...
//        let customView = Bundle.main.loadNibNamed(String(describing: NotificationView.self), owner: self, options: nil)?.first as! NotificationView
//        notificationCell.contentView.addSubview(customView)
//        customView.translatesAutoresizingMaskIntoConstraints = false
//        customView.leadingAnchor.constraint(equalTo: notificationCell.contentView.leadingAnchor).isActive = true
//        customView.trailingAnchor.constraint(equalTo: notificationCell.contentView.trailingAnchor).isActive = true
//        customView.topAnchor.constraint(equalTo: notificationCell.contentView.topAnchor).isActive = true
//        customView.bottomAnchor.constraint(equalTo: notificationCell.contentView.bottomAnchor).isActive = true
//
//        let section = self.sections[indexPath.section]
//        let notification = section.rows[indexPath.row]
//        customView.setupWith(notification)
//
//        return notificationCell
//    }
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
