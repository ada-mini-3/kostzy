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
    
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var feedTextView: UITextView!
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    @IBOutlet weak var categoryView: UIView!
            
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var kostNameField: UITextField!
    
    @IBOutlet weak var guidelinesButton: UIButton!
    
    @IBOutlet weak var locationName: UILabel!
    
    let infoTags = Tag.initData()
    
    let culinaryTags = Tag.initCulinaryTag()
    
    let hangoutTags = Tag.initHangoutsTag()
    
    let expTags = Tag.initExpTag()
    
    lazy var displayedTags = infoTags
    
    let categories = FeedCategory.initData()
    
    var categoryPicker = UIPickerView()
    
    var toolbar = UIToolbar()
    
    var category : String = ""
    
    var catId : Int?
    
    var newTag = [Tag]()
    
    var tagsId : [Int] = []

    var locationString :String?
    
    let defaults = UserDefaults.standard
    
    let apiManager = BaseAPIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddPhoto()
        setupProfilePicture()
        setupCancelButton()
        setupPostButton()
        setupTextView()
        setupCategory()
        setupGuidelines()
        setupMapView()
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.allowsMultipleSelection = true
        feedTextView.delegate = self
        kostNameField.delegate = self
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
    
    func postFeedApi() {
        let payload = ["feed": feedTextView.text ?? "", "category": catId ?? 1,
                       "lat": 0, "long": 0, "location_name": locationString ?? "",
                       "tags": tagsId] as [String : Any]
        let token = "Token \(defaults.dictionary(forKey: "userToken")!["token"] as! String)"
        apiManager.performPostRequest(payload: payload, url: "\(apiManager.baseUrl)feeds/",
            token: token)
        { (data, response, error) in
            DispatchQueue.main.async {
                if let response =  response as? HTTPURLResponse {
                    switch response.statusCode {
                       case 201:
                            self.performSegue(withIdentifier: "unwindFeeds", sender: self)
                           break
                       case 400:
                           if let feedErr = data?["feed"] as? [String] {
                               self.setupAlert(msg: "\(feedErr[0]) (Feed)")
                           } else if let catErr = data?["category"] as? [String] {
                               self.setupAlert(msg: "\(catErr[0]) (Category)")
                           }
                            break
                       default:
                            print(response.statusCode)
                           self.setupAlert(msg: "Something Wrong, Try Again Later")
                           break
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
    
    @objc private func postFeed() {
       print("Post Clicked....")
       postFeedApi()
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
                let newFeeds = Feeds(user: User.initUser(), time: "2019-10-07", location: locationString, feed: feedTextView.text, tags: newTag, likeCount: 0, commentCount: 0, category: catId!, likeStatus: false)
            switch catId {
                case 1:
                    dest.feedsInfo.insert(newFeeds, at: 0)
                default:
                    dest.feedsFood.insert(newFeeds, at: 0)
                }
            }
        }
    }
    
    @IBAction func unwindToCreate(_ sender:UIStoryboardSegue) {
        locationName.text = locationString
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
        setupCollectionViewData()
    }
    
    
}

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
            cell?.backgroundColor = UIColor.hexStringToUIColor(hex: displayedTags[indexPath.row].color)
            newTag.append(displayedTags[indexPath.row])
            tagsId.append(displayedTags[indexPath.row].id)
            print(tagsId)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = tagCollectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray
        if let idx = newTag.firstIndex(where: {$0.name == infoTags[indexPath.row].name}) {
            newTag.remove(at: idx)
            tagsId.remove(at: idx)
            print(tagsId)
        }
    }
    
}

extension FeedsCreateVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

extension FeedsCreateVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            if isDarkMode == true {
                feedTextView.textColor = UIColor.white
            } else {
                feedTextView.textColor = UIColor.black
            }
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
