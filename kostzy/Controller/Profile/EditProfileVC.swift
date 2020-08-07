//
//  EditProfileVC.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    //imageView
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var txtContent: UITextField!
    @IBOutlet weak var nameContent: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //----------------------------------------------------------------
    // MARK:- Variables
    //----------------------------------------------------------------
    var profileTableVC: ProfileTableVC!
    let defaults = UserDefaults.standard
    var nameText = ""
    var apiManager = BaseAPIManager()
    var imagePicked = false
    
    @IBAction func saveButton(_ sender: Any) {
       // var savedUserDataDict = defaults.dictionary(forKey: "userDataDict") as? [String: String] ?? [String: String]()
        
//        savedUserDataDict["userName"] = nameContent.text
//        savedUserDataDict["userDesc"] = txtContent.text
//        defaults.set(savedUserDataDict, forKey: "userDataDict")
      //  print(savedUserDataDict)
        var payload: [String: Any] = [:]
        let name = nameContent.text!
        let about = txtContent.text ?? ""
        let token = "Token \(defaults.dictionary(forKey: "userToken")!["token"] as! String)"
        let imageData = profileImageView.image?.pngData()
        
        if imagePicked == true {
            payload = ["name": name, "about": about, "image": imageData?.base64EncodedString() ?? ""]
        } else {
             payload = ["name": name, "about": about]
        }
        
        apiManager.performPatchUploadRequest(payload: payload, imageData: imageData!, url: "\(BaseAPIManager.authUrl)profile/", token: token) { (data, response, error) in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                        case 200...299:
                            self.performSegue(withIdentifier: "unwindProfile", sender: self)
                        default:
                            print(response.statusCode)
                            self.setupAlert(msg: "Something's Wrong, Please Try Again Later")
                    }
                } else if let error = error {
                    self.setupAlert(msg: error.localizedDescription)
                }
            }
        }
    }
    
    
    private func setupPlaceholder() {
        let savedUserDataDict = defaults.dictionary(forKey: "userDataDict") as? [String: String] ?? [String: String]()
//        nameContent.placeholder = savedUserDataDict["userName"]
        nameContent.text = savedUserDataDict["userName"]
        txtContent.text = savedUserDataDict["userDesc"]
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupAlert(msg: String) {
        let alert = UIAlertController(title: "Whoops!", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    //action sheet untuk ganti photo
    func setupImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil
        ))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        imagePicked = true
        profileImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtContent.delegate = self
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        profileImageView.addGestureRecognizer(tapRec)
        profileImageView.isUserInteractionEnabled = true
        setupPlaceholder()
        
    }
    
    @objc func tappedView(sender: UITapGestureRecognizer ) {
        setupImagePicker()
    }
    
    
    //character count
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        
        if !text.isEmpty {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        
        let updateText = currentText.replacingCharacters(in: stringRange, with: string)
        lblNumber.text = "\(200 - updateText.count)"
        return updateText.count < 200
    }
}


//override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    let destinationProfile = segue.destination as! ProfileTableVC
//    destinationProfile.profileNameLabel =
//}


