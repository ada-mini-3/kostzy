//
//  EditProfileVC.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    //----------------------------------------------------------------
    // MARK:- Outlets
    //----------------------------------------------------------------
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var nameContent: UITextField!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    
    
    //----------------------------------------------------------------
    // MARK:- Variables
    //----------------------------------------------------------------
    var profileTableVC: ProfileTableVC!
    var profileImagePicker: UIImagePickerController!
    let defaults = UserDefaults.standard
    var nameText = ""
    var apiManager = BaseAPIManager()
    var imagePicked = false
    var profile: Profile?
    
    @IBAction func saveButton(_ sender: Any) {
       // var savedUserDataDict = defaults.dictionary(forKey: "userDataDict") as? [String: String] ?? [String: String]()
        
//        savedUserDataDict["userName"] = nameContent.text
//        savedUserDataDict["userDesc"] = txtContent.text
//        defaults.set(savedUserDataDict, forKey: "userDataDict")
      //  print(savedUserDataDict)
        var payload: [String: Any] = [:]
        let name = nameContent.text!
        let about = aboutMeTextView.text ?? ""
        
        let token = "Token \(defaults.dictionary(forKey: "userToken")!["token"] as! String)"
        let imageData = profileImageView.image?.pngData()
        
        if imagePicked == true {
            if let image = imageData {
                payload = ["name": name, "about": about, "image": image]
            } else {
                payload = ["name": name, "about": about, "image": ""]
            }
    
        } else {
             payload = ["name": name, "about": about]
        }
        
        apiManager.performPatchUploadRequest(payload: payload, imageData: imageData!, url: "\(BaseAPIManager.authUrl)profile/", token: token) { (data, response, error) in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                        case 200...299:
                            self.performSegue(withIdentifier: "unwindProfile", sender: self)
                        case 400:
                            if let errName = data?["name"] as? [String] {
                                self.setupAlert(msg: errName[0] + " (Name)")
                            } else if let errImage = data?["image"] as? [String] {
                                self.setupAlert(msg: errImage[0] + " (Image)")
                            }
                        default:
                            print(data)
                            self.setupAlert(msg: "Something's Wrong, Please Try Again Later")
                    }
                } else if let error = error {
                    self.setupAlert(msg: error.localizedDescription)
                }
            }
        }
    }
    
    
    private func setupAlert(msg: String) {
        let alert = UIAlertController(title: "Whoops!", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    

    @IBAction func cancelButton(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to cancel?", message: "Unsaved changes will be discarded", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func changePhotoButtonAction(_ sender: UIButton) {
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
    func setupCharCountLabel() {
        if isDarkMode {
            lblNumber.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        }
        else {
            lblNumber.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.5)
        }
    }
    
    func setupImageView() {
        profileImageView.image = loadImageFromDiskWith(fileName: "profileImage")
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
    
    func setupImagePicker() {
        profileImagePicker = UIImagePickerController()
        profileImagePicker.delegate = self
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            profileImagePicker.sourceType = UIImagePickerController.SourceType.camera
            profileImagePicker.allowsEditing = true
            self.present(profileImagePicker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openPhotoLibrary() {
        profileImagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        profileImagePicker.allowsEditing = true
        self.present(profileImagePicker, animated: true, completion: nil)
    }
    
    func setupTextField() {
        nameContent.delegate = self
        nameContent.keyboardType = .namePhonePad
        
        if let theProfile = profile {
            nameContent.text = theProfile.name
        } else {
            nameContent.text = "Name"
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        let notificationCenter = NotificationCenter.default
        
        view.addGestureRecognizer(tapGesture)
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameContent {
            aboutMeTextView.becomeFirstResponder()
        }
        return true
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer)  {
        view.endEditing(true)
    }
    
    
    func saveImage(imageName: String, image: UIImage) {
     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            
            return image ?? UIImage(named: "Empty Profile Picture")
        }
        
        return nil
    }
    
//    navigation bar
//    private func setupNavigationItem() {
//        let atts = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)]
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
//        navigationItem.leftBarButtonItem?.setTitleTextAttributes(atts, for: .normal)
//
//        let save = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: nil)
//        navigationItem.leftBarButtonItem?.setTitleTextAttributes(save, for: .normal)
//
//    }
    
    
    //----------------------------------------------------------------
    // MARK:- View Life Cycle Methods
    //----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.largeTitleDisplayMode = .never
//        setupNavigationItem()
        
//        print("Hello")
        setupImageView()
        setupTextView()
        setupTextField()
        setupCharCountLabel()
        
        self.modalPresentationStyle = .formSheet
        self.isModalInPresentation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupImagePicker()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupTextView()
        setupCharCountLabel()
    }
}


//override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    let destinationProfile = segue.destination as! ProfileTableVC
//    destinationProfile.profileNameLabel =
//}


//----------------------------------------------------------------
// MARK:- Text View Delegate
//----------------------------------------------------------------
extension EditProfileVC: UITextViewDelegate {
    
    func setupTextView() {
        aboutMeTextView.delegate = self
        aboutMeTextView.tag = 0
        
        if let theProfile = profile {
            aboutMeTextView.text = theProfile.about
            saveButtonOutlet.isEnabled = true
        } else {
            aboutMeTextView.text = "About Me"
            saveButtonOutlet.isEnabled = false
        }
        
        if isDarkMode {
            aboutMeTextView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        }
        else {
            aboutMeTextView.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.5)
        }
        
        aboutMeTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        aboutMeTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.tag == 0) {
            if aboutMeTextView.text == "About Me" {
                aboutMeTextView.text = nil
                
                if isDarkMode {
                    aboutMeTextView.textColor = .white
                }
                else {
                    aboutMeTextView.textColor = .black
                }
                
                aboutMeTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            }
            else {
                if isDarkMode {
                    aboutMeTextView.textColor = .white
                }
                else {
                    aboutMeTextView.textColor = .black
                }
                
                aboutMeTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if aboutMeTextView.text.isEmpty {
            aboutMeTextView.text = "About Me"
            
            if isDarkMode {
                aboutMeTextView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
            }
            else {
                aboutMeTextView.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.5)
            }
            aboutMeTextView.font = UIFont.systemFont(ofSize: 16, weight: .light)
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return aboutMeTextView.text.count + (text.count - range.length) <= 255
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == aboutMeTextView {
            lblNumber.text = "\(0 + aboutMeTextView.text.count)/255"
            setSaveButtonState()
        }
    }
    
    func setSaveButtonState() {
        if aboutMeTextView.text != "About Me" &&
            !aboutMeTextView.text.isEmpty {
                saveButtonOutlet.isEnabled = true
        }
        else {
            saveButtonOutlet.isEnabled = false
        }
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
}


//----------------------------------------------------------------
// MARK:- Image Picker Delegate
//----------------------------------------------------------------
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicked = true
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        self.profileImageView.image = image
    }
}
