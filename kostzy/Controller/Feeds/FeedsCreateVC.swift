//
//  FeedsCreateVC.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class FeedsCreateVC: UIViewController {
    
    @IBOutlet weak var addPhoto: UIView!
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var feedTextView: UITextView!
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    @IBOutlet weak var categoryView: UIView!
            
    @IBOutlet weak var categoryName: UILabel!
    
    let tags = Tag.initData()
    
    let categories = FeedCategory.initData()
    
    var categoryPicker = UIPickerView()
    
    var toolbar = UIToolbar()
    
    var category : String = ""
    
    var catId : Int?
    
    var newTag = [Tag]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddPhoto()
        setupProfilePicture()
        setupCancelButton()
        setupPostButton()
        setupTextView()
        setupCategory()
        navigationItem.rightBarButtonItem?.isEnabled = false
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.allowsMultipleSelection = true
        feedTextView.delegate = self
    }
    
    private func setupAddPhoto() {
        addPhoto.layer.borderWidth = 1
        addPhoto.layer.borderColor = UIColor.lightGray.cgColor
        addPhoto.layer.cornerRadius = 10
    }
    
    private func setupCategory() {
        let categoryGesture = UITapGestureRecognizer(target: self, action: #selector(categoryClicked))
        categoryView.addGestureRecognizer(categoryGesture)
    }
    
    @objc private func categoryClicked() {
        category = "Information"
        categoryName.text = "Information"
        catId = 1
        setupPickerView()
        setupPostButton()
    }
    
    private func setupPickerView() {
        categoryPicker = UIPickerView.init()
        categoryPicker.autoresizingMask = .flexibleWidth
        categoryPicker.backgroundColor = UIColor.white
        categoryPicker.contentMode = .center
        categoryPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 350, width: UIScreen.main.bounds.size.width, height: 300)
        categoryPicker.selectedRow(inComponent: 0)
        
        toolbar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 350, width: UIScreen.main.bounds.size.width, height: 50))
        toolbar.barStyle = .default
        toolbar.setItems([UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(pickerViewDoneButtonClicked))], animated: false)
        toolbar.tintColor = UIColor(red: 255.0/255, green: 184.0/255, blue: 0.0/255, alpha: 1)
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        self.view.addSubview(categoryPicker)
        self.view.addSubview(toolbar)
    }
    
    @objc func pickerViewDoneButtonClicked() {
        categoryPicker.removeFromSuperview()
        toolbar.removeFromSuperview()
    }
    
    private func setupProfilePicture() {
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height / 2
        profilePhoto.clipsToBounds = true
    }
    
    private func setupTextView() {
        feedTextView.text = "Information or Question"
        feedTextView.textColor = UIColor.lightGray
    }
    
    private func setupCancelButton() {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain , target: self, action: #selector(cancelClicked))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func setupPostButton() {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done , target: self, action: #selector(postFeed))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 255.0/255, green: 184.0/255, blue: 0.0/255, alpha: 1)
        postButtonState()
    }
    
    @objc private func postFeed() {
        performSegue(withIdentifier: "unwindFeeds", sender: self)
    }
    
    private func postButtonState() {
        if feedTextView.text == "" && category == "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc private func cancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFeeds" {
            if let dest = segue.destination as? FeedsVC {
                let newFeeds = Feeds(user: User.initUser(), time: Date(), location: nil, feed: feedTextView.text, tags: newTag, likeCount: 0, commentCount: 0, category: catId!, likeStatus: false)
            switch catId {
                case 1:
                    dest.feedsInfo.insert(newFeeds, at: 0)
                default:
                    dest.feedsFood.insert(newFeeds, at: 0)
                }
            }
        }
    }

}

extension FeedsCreateVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category = categories[row].name
        catId = categories[row].id
        categoryName.text = categories[row].name
        postButtonState()
    }
    
    
}

extension FeedsCreateVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: "tagCreateCell", for: indexPath) as! FeedTagsCell
        cell.tagCreateName.text = tags[indexPath.row].name
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = tagCollectionView.cellForItem(at: indexPath)
        if cell?.isSelected == true {
            Tag.colorArr.shuffle()
            cell?.backgroundColor = Tag.colorArr[indexPath.row]
            newTag.append(tags[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = tagCollectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray
        if let idx = newTag.firstIndex(where: {$0.name == tags[indexPath.row].name}) {
            newTag.remove(at: idx)
        }
    }
    
}

extension FeedsCreateVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Information or Question"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
