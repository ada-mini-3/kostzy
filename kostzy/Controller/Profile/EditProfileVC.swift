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
    
    //navigation bar
    private func setupNavigationItem() {
        let atts = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(atts, for: .normal)
        
        let save = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(save, for: .normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtContent.delegate = self
        
        self.navigationItem.largeTitleDisplayMode = .never
        setupNavigationItem()
        
        print("Hello")
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        
        profileImageView.addGestureRecognizer(tapRec)
        profileImageView.isUserInteractionEnabled = true
        
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

//    }
//}



