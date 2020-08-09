//
//  NewDiscussionTableVC.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 28/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class NewDiscussionTableVC: UITableViewController {
    
    //----------------------------------------------------------------
    // MARK:- Outlets
    //----------------------------------------------------------------
    
    @IBOutlet weak var postButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var charCountLabel: UILabel!
    
    @IBOutlet weak var discussionTextViewCell: UITableViewCell!
    @IBOutlet weak var discussionTextView: UITextView!
    
    @IBOutlet weak var addPhotoView: UIView!
    @IBOutlet weak var discussionImageView: UIImageView!
    @IBOutlet weak var addPhotoButtonOutlet: UIButton!
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var guidelinesButtonOutlet: UIButton!
    
    
    //----------------------------------------------------------------
    // MARK:- Variables
    //----------------------------------------------------------------
    let defaults = UserDefaults.standard
    let profileImagePlaceholderImage = "Empty Profile Picture"
    let profileNamePlaceholderText = "User"
    let discussionTextViewPlaceholderText = "Information or question"
    var discussionImagePicker: UIImagePickerController!
    var apiManager = BaseAPIManager()
    var communityId: Int?
    
    //----------------------------------------------------------------
    // MARK:- Action Methods
    //----------------------------------------------------------------
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to cancel?", message: "Unsaved changes will be discarded", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func postButtonAction(_ sender: Any) {
        postDiscussionApi()
    }
    
    @IBAction func addPhotoButtonAction(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            self.openPhotoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            self.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: nil))
        
        /*If you want work actionsheet on ipad
        then you have to use popoverPresentationController to present the actionsheet,
        otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            actionSheet.popoverPresentationController?.sourceView = sender
            actionSheet.popoverPresentationController?.sourceRect = sender.bounds
            actionSheet.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    //----------------------------------------------------------------
    // MARK:- Custom Methods
    //----------------------------------------------------------------
    private func postDiscussionApi() {
        guard let token = defaults.dictionary(forKey: "userToken") else { return }
        guard let id = communityId else { return }
        let theToken = "Token \(token["token"]!)"
        let payload = ["text": discussionTextView.text ?? "", "community": id] as [String : Any]
        apiManager.performPostRequest(payload: payload, url: "\(apiManager.baseUrl)discussion/", token: theToken) { (data, response, error) in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                        self.setupAlertSuccess(title: "Success!",msg: "Success Post New Discussion!")
                    case 400:
                        if let errText = data?["text"] as? [String] {
                            self.setupAlert(msg: errText[0])
                        } else if let errCommmunity = data?["community"] as? [String] {
                            self.setupAlert(msg: errCommmunity[0])
                        }
                        break
                    default:
                        self.setupAlert(msg: "Something went wrong, please try again later")
                        break
                    }
                } else if let error = error {
                    self.setupAlert(msg: error.localizedDescription)
                }
            }
        }
    }
    
    private func setupAlertSuccess(title: String = "Whoops!",msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    private func setupAlert(title: String = "Whoops!",msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func loadProfileData() {
        let savedUserDataDict = defaults.dictionary(forKey: "userDataDict") ?? [String: Any]()
        let userIsLoggedIn = defaults.bool(forKey: "userIsLoggedIn")
            
        if userIsLoggedIn == true {
            setupImageView()
            profileNameLabel.text = savedUserDataDict["userName"] as? String
        }
        else if userIsLoggedIn == false {
            setupImageView()
            profileNameLabel.text = profileNamePlaceholderText
        }
    }
    
    func setupLabel() {
        if isDarkMode {
            charCountLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
            addPhotoLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        }
        else {
            charCountLabel.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.5)
            addPhotoLabel.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.5)
        }
    }
    
    private func setupAddPhotoView() {
        addPhotoView.layer.borderWidth = 1
        addPhotoView.layer.cornerRadius = 6
        
        if isDarkMode {
            addPhotoView.layer.borderColor = UIColor.separator.cgColor
        }
        else {
            addPhotoView.layer.borderColor = UIColor.separator.cgColor
        }
    }
    
    func setupDiscussionImagePicker() {
        discussionImagePicker = UIImagePickerController()
        discussionImagePicker.delegate = self
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            discussionImagePicker.sourceType = UIImagePickerController.SourceType.camera
            discussionImagePicker.allowsEditing = true
            self.present(discussionImagePicker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openPhotoLibrary() {
        discussionImagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        discussionImagePicker.allowsEditing = true
        self.present(discussionImagePicker, animated: true, completion: nil)
    }
    
    private func setupGuidelinesButton() {
        let attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0),
            NSAttributedString.Key.foregroundColor : UIColor(red: 254/255, green: 14/255, blue: 115/255, alpha: 1),
            NSAttributedString.Key.underlineStyle : 1]
        let attributeString = NSMutableAttributedString(string: "guidelines",
        attributes: attrs)
        guidelinesButtonOutlet.setAttributedTitle(attributeString, for: .normal)
    }
    
    func setupImageView() {
        profileImageView.image = loadImageFromDiskWith(fileName: "profileImage")
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            
            return image ?? UIImage(named: profileImagePlaceholderImage)
        }
        return nil
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
        modalPresentationStyle = .formSheet
        isModalInPresentation = true
        tableView.keyboardDismissMode = .interactive
        
        tableView.estimatedRowHeight = 118
        tableView.rowHeight = UITableView.automaticDimension
        loadProfileData()
        setupImageView()
        setupTextView()
        setupLabel()
        setupGuidelinesButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupDiscussionImagePicker()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupTextView()
        setupLabel()
        setupAddPhotoView()
    }

    
    //----------------------------------------------------------------
    // MARK:- Table view data source
    //----------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            let height: CGFloat = tableView.estimatedRowHeight
                        
            return height
        }

        return UITableView.automaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
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


//----------------------------------------------------------------
// MARK:- Text View Delegate
//----------------------------------------------------------------

extension NewDiscussionTableVC: UITextViewDelegate {
    func setupTextView() {
        discussionTextView.delegate = self
        discussionTextView.tag = 0
        discussionTextView.text = discussionTextViewPlaceholderText
        
        if isDarkMode {
            discussionTextView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        }
        else {
            discussionTextView.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.5)
        }
        
        discussionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        discussionTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        setSaveButtonState()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.tag == 0) {
            if discussionTextView.text == discussionTextViewPlaceholderText {
                discussionTextView.text = nil
                
                if isDarkMode {
                    discussionTextView.textColor = .white
                }
                else {
                    discussionTextView.textColor = .black
                }
                
                discussionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            }
            else {
                if isDarkMode {
                    discussionTextView.textColor = .white
                }
                else {
                    discussionTextView.textColor = .black
                }
                
                discussionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if discussionTextView.text.isEmpty {
            discussionTextView.text = discussionTextViewPlaceholderText
            
            if isDarkMode {
                discussionTextView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
            }
            else {
                discussionTextView.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.5)
            }
            discussionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return discussionTextView.text.count + (text.count - range.length) <= 255
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == discussionTextView {
            let newHeight = discussionTextViewCell.frame.size.height + textView.contentSize.height
            discussionTextViewCell.frame.size.height = newHeight
            updateTableViewContentOffsetForTextView()
            
            charCountLabel.text = "\(0 + discussionTextView.text.count)/255"
            setSaveButtonState()
        }
    }
    
    func updateTableViewContentOffsetForTextView() {
            let currentOffset = tableView.contentOffset
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            tableView.setContentOffset(currentOffset, animated: false)
        }
    
    func setSaveButtonState() {
        if discussionTextView.text != discussionTextViewPlaceholderText &&
            !discussionTextView.text.isEmpty {
                postButtonOutlet.isEnabled = true
        } else {
            postButtonOutlet.isEnabled = false
        }
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
}


//----------------------------------------------------------------
// MARK:- Image Picker Delegate
//----------------------------------------------------------------

extension NewDiscussionTableVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        self.discussionImageView.image = image
    }
}
