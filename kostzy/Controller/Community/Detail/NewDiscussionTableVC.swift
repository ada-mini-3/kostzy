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
    
    @IBOutlet weak var discussionTextView: UITextView!
    
    @IBOutlet weak var discussionImageView: UIImageView!
    @IBOutlet weak var addPhotoButtonOutlet: UIButton!
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var guidelinesButtonOutlet: UIButton!
    
    
    //----------------------------------------------------------------
    // MARK:- Variables
    //----------------------------------------------------------------
    
    let discussionTextViewPlaceholderText = "Information or question"
    var discussionImagePicker: UIImagePickerController!
    
    
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
        dismiss(animated: true, completion: nil)
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
        
        setupTextView()
        setupLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupDiscussionImagePicker()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupTextView()
        setupLabel()
    }

    
    //----------------------------------------------------------------
    // MARK:- Table view data source
    //----------------------------------------------------------------

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
            charCountLabel.text = "\(0 + discussionTextView.text.count)/255"
            setSaveButtonState()
        }
    }
    
    func setSaveButtonState() {
        if discussionTextView.text != discussionTextViewPlaceholderText &&
            !discussionTextView.text.isEmpty {
                postButtonOutlet.isEnabled = true
        }
        else {
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
