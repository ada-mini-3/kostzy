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
    
    
    //----------------------------------------------------------------
    // MARK:- Variables
    //----------------------------------------------------------------
    var profileTableVC: ProfileTableVC!
    let defaults = UserDefaults.standard
    var nameText = ""
    
    @IBAction func saveButton(_ sender: Any) {
        var savedUserDataDict = defaults.dictionary(forKey: "userDataDict") as? [String: String] ?? [String: String]()
        
        savedUserDataDict["userName"] = nameContent.text
        savedUserDataDict["userDesc"] = txtContent.text
        defaults.set(savedUserDataDict, forKey: "userDataDict")
      //  print(savedUserDataDict)
        performSegue(withIdentifier: "unwindProfile", sender: self)
       // profileTableVC.tableView.reloadData()
        //self.nameText = nameContent.text!
        //performSegue(withIdentifier: "data", sender: self)
        //self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! ProfileTableVC
        vc.finalname = self.nameText
    }*/
    
    private func setupPlaceholder() {
        let savedUserDataDict = defaults.dictionary(forKey: "userDataDict") as? [String: String] ?? [String: String]()
//        nameContent.placeholder = savedUserDataDict["userName"]
        nameContent.text = savedUserDataDict["userName"]
        txtContent.text = savedUserDataDict["userDesc"]
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        profileImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtContent.delegate = self
        
//        self.navigationItem.largeTitleDisplayMode = .never
//        setupNavigationItem()
        
//        print("Hello")
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
        guard let stringRange = Range(range, in: currentText) else {
            return false
            
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


