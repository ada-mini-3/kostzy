//
//  FeedsVC.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import CoreLocation
import UIKit
import MapKit

let profileImageCache = NSCache<NSString, UIImage>()

//----------------------------------------------------------------
// MARK: - NoSwipeSegmendtedControl
//----------------------------------------------------------------
class NoSwipeSegmentedControl: UISegmentedControl {

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


//----------------------------------------------------------------
// MARK: - FeedsVC
//----------------------------------------------------------------
class FeedsVC: UIViewController, MKMapViewDelegate {
    
    //----------------------------------------------------------------
    // MARK:- Outlets
    //----------------------------------------------------------------
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var segmentedCategory: NoSwipeSegmentedControl!
    @IBOutlet weak var feedsCollectionView: UICollectionView!
    @IBOutlet weak var chevron: UIImageView!
    @IBOutlet weak var actityIndicator: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
    
    var flowLayout: UICollectionViewFlowLayout {
        return self.feedsCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    
    //----------------------------------------------------------------
    // MARK:- Variables
    //----------------------------------------------------------------
    let defaults = UserDefaults.standard
    
    var apiManager = BaseAPIManager()
    var location : Location?
    var feedsData: [Feeds] = []
    var category = 1
    
    var locationManager : CLLocationManager?
    
    
    //----------------------------------------------------------------
    // MARK: - Action Methods
    //----------------------------------------------------------------
    @IBAction func unwindToFeeds(_ sender: UIStoryboardSegue) {
        setupButtonToLocation()
        setupRefreshControl()
        setupFeedsData()
        setupLocationManager()
        setupCollectionViewBg()
    }
    
    private func setupFeedsData() {
        self.actityIndicator.isHidden = false
        self.actityIndicator.startAnimating()
        var theToken = ""
        if let token = defaults.dictionary(forKey: "userToken") {
            theToken = "Token \(token["token"]!)"
        }
        apiManager.performGenericFetchRequest(urlString: "\(apiManager.baseUrl)feeds/?category=\(category)",
            token: theToken,
            errorMsg: {
                DispatchQueue.main.async {
                    self.setEmptyMessage("Feeds aren't loading right now, Try Again")
                }
        },
            completion: { (feeds: [Feeds]) in
            DispatchQueue.main.async {
                self.actityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                self.actityIndicator.isHidden = true
                self.feedsData = feeds
                self.feedsCollectionView.dataSource = self
                self.feedsCollectionView.delegate = self
                self.feedsCollectionView.reloadData()
            }
        })
    }
    
    private func setupFeedLikeApi(button: UIButton, feed: Feeds) {
        guard let token = defaults.dictionary(forKey: "userToken") else {
            setupLoginPage()
            return
        }
        let payload = ["feed": feed.id]
        apiManager.performPostRequest(payload: payload, url: "\(apiManager.baseUrl)likes/",
        token: "Token \(token["token"]!)") { (data, response, error) in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                        print("Like Success")
                        break
                    default:
                        print(response.statusCode)
                        self.setupAlert(msg: "Something went wrong, please try again later")
                        break
                    }
                } else if let error = error {
                    self.setupAlert(msg: error.localizedDescription)
                }
            }
        }
        
    }
    
    private func setupFeedDislikeApi(likeId: Int) {
        guard let token = defaults.dictionary(forKey: "userToken") else {
            setupLoginPage()
            return
        }
        let theToken = "Token \(token["token"]!)"
        apiManager.performDeleteRequest(url: "\(apiManager.baseUrl)likes/\(likeId)/", token: theToken) { (response, error) in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                        print("Success Dislike Feed")
                        break
                    default:
                        print(response.statusCode)
                        self.setupAlert(msg: "Something went wrong, please try again later")
                        break
                    }
                } else if let error = error {
                    self.setupAlert(msg: error.localizedDescription)
                }
            }
        }
    }
    
    private func setupAlert(title: String =  "Whoops!", msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func setupLoginPage() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    private func setupCollectionViewBg() {
        if isDarkMode == true {
            feedsCollectionView.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        } else {
            feedsCollectionView.backgroundColor = UIColor(red: 228/255, green: 233/255, blue: 235/255, alpha: 1)
        }
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    func openMapForPlace () {
        //Defining destination
        let latitude: CLLocationDegrees = -6.200696
        let longitude: CLLocationDegrees = 106.784262

        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)

        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Syahdan"
        mapItem.openInMaps(launchOptions: options)
    }
    
    private func setupRefreshControl() {
        if #available(iOS 10.0, *) {
            feedsCollectionView.refreshControl = refreshControl
        } else {
            feedsCollectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching New Post ...", attributes: nil)
    }
    
    @objc func refresh(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setupFeedsData()
        }
    }
    
    private func setupNavigationBarItem() {
        let icon = UIImage(systemName: "plus.circle.fill")
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 44, height: 44))
        let iconButton = UIButton(frame: iconSize)
        iconButton.setBackgroundImage(icon, for: .normal)
        let barButton = UIBarButtonItem(customView: iconButton)
        iconButton.addTarget(self, action: #selector(segueToCreateFeeds), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func segueToCreateFeeds() {
        let userIsLoggedIn = defaults.bool(forKey: "userIsLoggedIn")
        
        if userIsLoggedIn == false {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        else {
            performSegue(withIdentifier: "createFeedSegue", sender: self)
        }
    }
    
    private func setupSegmentedControl() {
        segmentedCategory.selectedSegmentTintColor = UIColor(red: 255.0/255, green: 184.0/255, blue: 0.0/255, alpha: 1)
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
        segmentedCategory.setTitleTextAttributes(attrs, for: .selected)

        if isDarkMode == true {
            segmentedCategory.backgroundColor = UIColor.black
        } else {
            segmentedCategory.backgroundColor = UIColor.white
            chevron.tintColor = UIColor.black
        }
        fixBackgroundSegmentControl(segmentedCategory)
    }
    
    func fixBackgroundSegmentControl( _ segmentControl: UISegmentedControl){
        if #available(iOS 13.0, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(segmentControl.numberOfSegments-1)  {
                    let backgroundSegmentView = segmentControl.subviews[i]
                    backgroundSegmentView.isHidden = true
                }
            }
        }
    }
    
    private func setupButtonToLocation() {
        
        if let location = location {
            btnLocation.setTitle(location.name, for: .normal)
        }
        
        if isDarkMode == true {
            btnLocation.setTitleColor(.white, for: .normal)
            chevron.tintColor = .white
        } else {
            btnLocation.setTitleColor(.black, for: .normal)
            chevron.tintColor = .black
        }
        
    }
    
    
    @IBAction func changeCategory(_ sender: UISegmentedControl) {
        changeSegmentedImage()
        filterFeedBasedOnCategory()
        self.feedsData.removeAll()
        self.feedsCollectionView.dataSource = nil
        self.feedsCollectionView.delegate = nil
        feedsCollectionView.reloadData()
        setupFeedsData()
    }
    
    private func filterFeedBasedOnCategory() {
        switch segmentedCategory.selectedSegmentIndex {
            case 0:
                category = 1
            case 1:
                category = 2
            case 2:
                category = 3
            default:
                category = 4
        }
    }
    
    private func changeSegmentedImage() {
        switch segmentedCategory.selectedSegmentIndex {
            case 0:
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "info-selected"), forSegmentAt: 0)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-culinary"), forSegmentAt: 1)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-experience"), forSegmentAt: 2)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-hangouts"), forSegmentAt: 3)
            case 1:
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-information"), forSegmentAt: 0)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "food-selected"), forSegmentAt: 1)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-experience"), forSegmentAt: 2)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-hangouts"), forSegmentAt: 3)
            case 2:
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-information"), forSegmentAt: 0)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-culinary"), forSegmentAt: 1)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "exp-selected"), forSegmentAt: 2)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-hangouts"), forSegmentAt: 3)
            default:
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-information"), forSegmentAt: 0)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-culinary"), forSegmentAt: 1)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-experience"), forSegmentAt: 2)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "hangout-selected"), forSegmentAt: 3)
        }
    }
    
    func setEmptyMessage(_ message: String) {
         let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))

         messageLabel.text = message
         messageLabel.textColor = .black
         messageLabel.numberOfLines = 0
         messageLabel.textAlignment = .center
         messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
         messageLabel.sizeToFit()
         messageLabel.clipsToBounds = true

         self.feedsCollectionView.backgroundView = messageLabel
     }
    
    
    func cacheProfileImageFromUrl() {
        guard let token = defaults.dictionary(forKey: "userToken") else { return }
        let theToken = "Token \(token["token"]!)"
        if profileImageCache.object(forKey: "imageProfile") == nil {
            apiManager.performGenericFetchRequest(urlString: "\(BaseAPIManager.authUrl)profile/",
                token: theToken,
                errorMsg: {
                self.setupAlert(msg: "Something went wrong")
            }) { (profle: Profile) in
                DispatchQueue.main.async {
                    if let image = profle.image {
                        let imageData = try? Data(contentsOf: URL(string: image)!)
                        if let data = imageData {
                            if let theImage = UIImage(data: data) {
                                print("Sampe gak")
                                profileImageCache.setObject(theImage, forKey: "imageProfile")
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //----------------------------------------------------------------
    // MARK:- View Life Cycle Methods
    //----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        cacheProfileImageFromUrl()
        setupNavigationBarItem()
        setupSegmentedControl()
        setupButtonToLocation()
        setupRefreshControl()
        setupLocationManager()
        setupCollectionViewBg()
        setupFeedsData()
        flowLayout.estimatedItemSize = CGSize(width: 342, height: 266)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupFeedsData()
        feedsCollectionView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupButtonToLocation()
        setupSegmentedControl()
        setupCollectionViewBg()
        feedsCollectionView.reloadData()
    }
    
}


//----------------------------------------------------------------
// MARK: - CLLocation
//----------------------------------------------------------------
extension FeedsVC : CLLocationManagerDelegate {
    
    func fetchCity(from location: CLLocation, completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemark, error in
            completion(placemark?.first?.locality,
                       error)
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        fetchCity(from: location) { city, error in
            guard let city = city, error == nil else { return }
            self.btnLocation.setTitle(city, for: .normal)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
                if CLLocationManager.isRangingAvailable() {
                    guard let location: CLLocation = manager.location else { return }
                    fetchCity(from: location) { city, error in
                       guard let city = city, error == nil else { return }
                       self.btnLocation.setTitle(city, for: .normal)
                   }
                }
        }
    }
    
}


//----------------------------------------------------------------
// MARK: - UICollectionView
//----------------------------------------------------------------
extension FeedsVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailFeedSegue" {
         if let dest = segue.destination as? FeedsDetailVC {
             dest.feeds = sender as? Feeds
         }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         performSegue(withIdentifier: "detailFeedSegue", sender: feedsData[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        feedsData.count
    }
    
    private func setupReportAlert() {
        let alert = UIAlertController(title: "Are you sure you want to report this post?", message: "Once you send the report, we will check whether this post violates our rules. Please make report only if you are sure this is a violation", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func setLikeButtonState(button: UIButton, feed: Feeds) {
        if feed.likeStatus == true {
                button.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                button.tintColor = UIColor(red: 255/255, green: 183/255, blue: 0/255, alpha: 1)
        } else if feed.likeStatus == false {
            button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            if isDarkMode == true {
                button.tintColor = UIColor.white
            } else {
                button.tintColor = UIColor.black
            }
        }
    }
    
    private func setupUserBadge(badge: UIImageView,feed: Feeds) {
        if feed.user.exp >= 100 && feed.user.exp < 200 {
            badge.image = #imageLiteral(resourceName: "Badge-100 Likes")
        }
        else if feed.user.exp >= 200 && feed.user.exp < 300 {
            badge.image = #imageLiteral(resourceName: "Badge-200 Likes")
        }
        else if feed.user.exp >= 300 && feed.user.exp < 400 {
            badge.image = #imageLiteral(resourceName: "Badge-300 Likes")
        }
        else if feed.user.exp >= 400 && feed.user.exp < 500 {
            badge.image = #imageLiteral(resourceName: "Badge-400 Likes")
        }
        else if feed.user.exp >= 500 {
            badge.image = #imageLiteral(resourceName: "Badge-500 Likes")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedCell
        var feed = feedsData[indexPath.row]
        if isDarkMode == true {
            cell.contentView.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
            cell.commentButton.tintColor = .white
            cell.likeButton.tintColor = .white
            cell.reportButton.setImage(UIImage(named: "Report"), for: .normal)
        } else {
            cell.contentView.backgroundColor = .white
            cell.commentButton.tintColor = .black
        }
        
        cell.userName.text = feed.user.name
        
        if let userImage = feed.user.image {
            cell.userImage.loadImageFromUrl(url: URL(string: userImage)!)
        } else {
            cell.userImage.image = UIImage(named: "Empty Profile Picture")
        }
        
        
        if feed.location == "" {
            cell.feedLocationChevronImage.isHidden = true
            cell.feedLocation.isHidden = true
            cell.userNameTopConstraint.constant = 14
        } else {
            cell.feedLocationChevronImage.isHidden = false
            cell.feedLocation.isHidden = false
            cell.feedLocation.setTitle(feed.location, for: .normal)
            cell.userNameTopConstraint.constant = 4
        }
        
        cell.feed.text = feed.feed
        
        if feed.tags.count == 0 {
            cell.feedTagsTopConstraint.constant = 0
            cell.feedTagsHeightConstraint.constant = 0
        }
        else {
            cell.feedTagsTopConstraint.constant = 16
            cell.feedTagsHeightConstraint.constant = 30
            cell.tags = feed.tags
        }
        
        cell.likeCount.text = "\(feed.likeCount) Likes"
        cell.commentCount.text = "\(feed.commentCount) Comments"
        cell.commentTapAction = {() in
            self.performSegue(withIdentifier: "detailFeedSegue", sender: self.feedsData[indexPath.row])
        }
        
        cell.locationTapAction = {() in
            self.openMapForPlace()
        }
    
        cell.reportTapAction = {() in
            self.setupReportAlert()
        }
    
        cell.likeTapAction = {() in
            if feed.likeStatus == false {
                self.setupFeedLikeApi(button: cell.likeButton, feed: feed)
                feed.likeStatus = true
                cell.likeCount.text = "\(feed.likeCount + 1) Likes"
                print(feed)
            } else {
                self.setupFeedDislikeApi(likeId: feed.like!.id)
                feed.likeStatus = false
                cell.likeCount.text = "\(feed.likeCount - 1) Likes"
            }
            self.setLikeButtonState(button: cell.likeButton, feed: feed)
        }
        
        setLikeButtonState(button: cell.likeButton, feed: feed)
        setupUserBadge(badge: cell.userBadge, feed: feed)
        cell.configure()
        return cell
    }
}
