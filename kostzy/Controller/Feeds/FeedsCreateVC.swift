//
//  FeedsCreateVC.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class FeedsCreateVC: UIViewController {
    
    //----------------------------------------------------------------
    // MARK:- Outlets
    //----------------------------------------------------------------
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var feedTextView: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var multipurposeView: UIView!
    @IBOutlet weak var kostNameField: UITextField!
    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var addPhoto: UIView!
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    @IBOutlet weak var guidelinesButton: UIButton!
    
    
    //----------------------------------------------------------------
    // MARK:- Variables
    //----------------------------------------------------------------
    let feedTextViewPlaceholderText = "Information or Question"
    
    let categories = FeedCategory.initData()
    var categoryPicker = UIPickerView()
    var category : String = ""
    var catId : Int?
    
    var locationString :String?
    
    var newTag = [Tag]()
    let infoTags = Tag.initData()
    let culinaryTags = Tag.initCulinaryTag()
    let hangoutTags = Tag.initHangoutsTag()
    let expTags = Tag.initExpTag()
    lazy var displayedTags = infoTags
    
    var toolbar = UIToolbar()
    
    
    //----------------------------------------------------------------
    // MARK:- Action Methods
    //----------------------------------------------------------------
    @IBAction func unwindToCreate(_ sender:UIStoryboardSegue) {
        locationName.text = locationString
    }
    
    
    //----------------------------------------------------------------
    // MARK:- Custom Methods
    //----------------------------------------------------------------
    func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        let notificationCenter = NotificationCenter.default
        
        view.addGestureRecognizer(tapGesture)
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
    
    private func setupCharCountLabel() {
        if isDarkMode {
            charCountLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        }
        else {
            charCountLabel.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.5)
        }
    }
    
    fileprivate func setupCollectionViewData() {
        switch catId {
            case 1:
                displayedTags = infoTags
                kostNameField.placeholder = "Kost Name"
            case 2:
                displayedTags = culinaryTags
                kostNameField.placeholder = "Restaurant / Place"
            case 3:
                displayedTags = expTags
                kostNameField.placeholder = "Kost Name"
            default:
                displayedTags = hangoutTags
                kostNameField.placeholder = "Hangout Place"
        }
        tagCollectionView.reloadData()
    }
    
    private func setupGuidelines() {
        let attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.0),
            NSAttributedString.Key.foregroundColor : UIColor(red: 254/255, green: 14/255, blue: 115/255, alpha: 1),
            NSAttributedString.Key.underlineStyle : 1]
        let attributeString = NSMutableAttributedString(string: "guidelines",
        attributes: attrs)
        guidelinesButton.setAttributedTitle(attributeString, for: .normal)
    }
    
    private func setupAddPhoto() {
        addPhoto.layer.borderWidth = 1
        addPhoto.layer.borderColor = UIColor.lightGray.cgColor
        addPhoto.layer.cornerRadius = 10
    }
    
    private func setupCategory() {
        let categoryGesture = UITapGestureRecognizer(target: self, action: #selector(categoryClicked))
        categoryView.addGestureRecognizer(categoryGesture)
        categoryView.underlinedView()
    }
    
    @objc private func categoryClicked() {
        category = "Information"
        categoryName.text = "Information"
        catId = 1
        setupPickerView()
        setupPostButton()
        self.view.endEditing(true)
    }
    
    private func setupMapView() {
        let mapGesture = UITapGestureRecognizer(target: self, action: #selector(mapClicked))
        mapView.addGestureRecognizer(mapGesture)
        mapView.underlinedView()
    }
    
    @objc private func mapClicked() {
        performSegue(withIdentifier: "mapSegue" , sender: self)
    }
    
    private func setupPickerView() {
        categoryPicker = UIPickerView.init()
        categoryPicker.autoresizingMask = .flexibleWidth
        if isDarkMode == true {
            categoryPicker.backgroundColor = UIColor.black
        } else {
            categoryPicker.backgroundColor = UIColor.white
        }
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
        let alert = UIAlertController(title: "Are you sure you want to cancel?", message: "Unsaved changes will be discarded", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    
    //----------------------------------------------------------------
    // MARK:- View Life Cycle Methods
    //----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardDismissal()
        setupAddPhoto()
        setupProfilePicture()
        setupCancelButton()
        setupPostButton()
        setupTextView()
        setupCharCountLabel()
        setupCategory()
        setupGuidelines()
        setupMapView()
        multipurposeView.underlinedView()
        
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.allowsMultipleSelection = true
        feedTextView.delegate = self
        kostNameField.delegate = self
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        modalPresentationStyle = .formSheet
        isModalInPresentation = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupTextView()
        setupCharCountLabel()
    }
    
    
    //----------------------------------------------------------------
    // MARK:- Segue Preparation
    //----------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFeeds" {
            if let dest = segue.destination as? FeedsVC {
                let newFeeds = Feeds(user: User.initUser(), time: Date(), location: locationString, feed: feedTextView.text, tags: newTag, likeCount: 0, commentCount: 0, category: catId!, likeStatus: false)
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


//----------------------------------------------------------------
// MARK:- Picker View Delegate
//----------------------------------------------------------------
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
        setupCollectionViewData()
    }
}


//----------------------------------------------------------------
// MARK:- Collection View Delegate
//----------------------------------------------------------------
extension FeedsCreateVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        displayedTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: "tagCreateCell", for: indexPath) as! FeedTagsCell
        cell.tagCreateName.text = displayedTags[indexPath.row].name
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = tagCollectionView.cellForItem(at: indexPath)
        if cell?.isSelected == true {
            cell?.backgroundColor = displayedTags[indexPath.row].color
            newTag.append(displayedTags[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = tagCollectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray
        if let idx = newTag.firstIndex(where: {$0.name == infoTags[indexPath.row].name}) {
            newTag.remove(at: idx)
        }
    }
}


//----------------------------------------------------------------
// MARK:- Text Field Delegate
//----------------------------------------------------------------
extension FeedsCreateVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


//----------------------------------------------------------------
// MARK:- Text View Delegate
//----------------------------------------------------------------
extension FeedsCreateVC: UITextViewDelegate {
    func setupTextView() {
        feedTextView.delegate = self
        feedTextView.tag = 0
        feedTextView.text = feedTextViewPlaceholderText
        
        if isDarkMode {
            feedTextView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        }
        else {
            feedTextView.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.5)
        }
        
        feedTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        feedTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.tag == 0) {
            if feedTextView.text == feedTextViewPlaceholderText {
                feedTextView.text = nil
                
                if isDarkMode {
                    feedTextView.textColor = .white
                }
                else {
                    feedTextView.textColor = .black
                }
                
                feedTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            }
            else {
                if isDarkMode {
                    feedTextView.textColor = .white
                }
                else {
                    feedTextView.textColor = .black
                }
                
                feedTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if feedTextView.text.isEmpty {
            feedTextView.text = feedTextViewPlaceholderText
            
            if isDarkMode {
                feedTextView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
            }
            else {
                feedTextView.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.5)
            }
            feedTextView.font = UIFont.systemFont(ofSize: 16, weight: .light)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return feedTextView.text.count + (text.count - range.length) <= 255
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == feedTextView {
            charCountLabel.text = "\(0 + feedTextView.text.count)/255"
        }
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
}
