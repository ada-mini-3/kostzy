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

class FeedsVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var btnLocation: UIButton!
    
    @IBOutlet weak var segmentedCategory: UISegmentedControl!
    
    @IBOutlet weak var feedsCollectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var actityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var chevron: UIImageView!
    
    //----------------------------------------------------------------
    // MARK:- Variables
    //----------------------------------------------------------------
    let defaults = UserDefaults.standard
    
    
    var location : Location?
    
    var feedsInfo = Feeds.initData()
    var feedsFood = Feeds.initFeedCatData()
    var feedsExp = Feeds.initFeedExpData()
    var feedsHangouts = Feeds.initFeedHangoutsData()
    
    lazy var feedsToDisplay = feedsInfo
    var locationManager : CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItem()
        setupSegmentedControl()
        setupButtonToLocation()
        setupRefreshControl()
        setupIndicator()
        setupLocationManager()
        setupCollectionViewBg()
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
    
    private func setupIndicator() {
        actityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.actityIndicator.stopAnimating()
            self.actityIndicator.isHidden = true
            self.feedsCollectionView.dataSource = self
            self.feedsCollectionView.delegate = self
            self.feedsCollectionView.reloadData()
        }
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
            self.refreshControl.endRefreshing()
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
                    //it is not enogh changing the background color. It has some kind of shadow layer
                    backgroundSegmentView.isHidden = true
                }
            }
        }
    }
    
    private func setupButtonToLocation() {
        btnLocation.contentHorizontalAlignment = .left
        if location != nil {
             btnLocation.setTitle(location?.name, for: .normal)
        }
        
        if isDarkMode == true {
            btnLocation.setTitleColor(UIColor.white, for: .normal)
            chevron.tintColor = UIColor.white
        } else {
            btnLocation.setTitleColor(UIColor.black, for: .normal)
            chevron.tintColor = UIColor.black
        }
        
    }
    
    @IBAction func unwindToFeeds(_ sender: UIStoryboardSegue) {
        setupButtonToLocation()
        segmentedCategory.selectedSegmentIndex = 0
        changeSegmentedImage()
        feedsToDisplay = feedsInfo
        feedsCollectionView.reloadData()
    }
    
    @IBAction func changeCategory(_ sender: UISegmentedControl) {
        changeSegmentedImage()
        filterFeedBasedOnCategory()
        feedsCollectionView.reloadData()
    }
    
    private func filterFeedBasedOnCategory() {
        switch segmentedCategory.selectedSegmentIndex {
            case 0:
                feedsToDisplay = feedsInfo
            case 1:
                feedsToDisplay = feedsFood
            case 2:
                feedsToDisplay = feedsExp
            default:
                feedsToDisplay = feedsHangouts
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
    
}

extension FeedsVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeacon.self) {
                if CLLocationManager.isRangingAvailable() {
                    
                }
            }
        }
    }
    
}

extension FeedsVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailFeedSegue" {
         if let dest = segue.destination as? FeedsDetailVC {
             dest.feeds = sender as? Feeds
         }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         performSegue(withIdentifier: "detailFeedSegue", sender: feedsToDisplay[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        feedsToDisplay.count
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
            }
        else {
            button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            if isDarkMode == true {
                button.tintColor = UIColor.white
            } else {
                button.tintColor = UIColor.black
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedCell
        var feed = feedsToDisplay[indexPath.row]
        
        if isDarkMode == true {
            cell.contentView.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
            cell.feedLocation.setTitleColor(UIColor.white, for: .normal)
            cell.commentButton.tintColor = UIColor.white
            cell.likeButton.tintColor = UIColor.white
            cell.reportButton.setImage(UIImage(named: "Report-dark"), for: .normal)
        } else {
            cell.contentView.backgroundColor = UIColor.white
            cell.feedLocation.setTitleColor(UIColor.black, for: .normal)
            cell.commentButton.tintColor = UIColor.black
        }
        
        cell.userName.text = feed.user.name
        cell.userImage.image = feed.user.image
        
        if feed.location == nil {
            cell.feedLocation.isHidden = true
        } else {
            cell.feedLocation.setTitle(feed.location, for: .normal)
        }
        cell.feed.text = feed.feed
        cell.tags = feed.tags
        cell.likeCount.text = "\(feed.likeCount) Likes"
        cell.commentCount.text = "\(feed.commentCount) Comments"
        cell.commentTapAction = {() in
            self.performSegue(withIdentifier: "detailFeedSegue", sender: self.feedsInfo[indexPath.row])
        }
        cell.locationTapAction = {() in
            print("Location Clicked!!")
            self.openMapForPlace()
            
        }
        
        cell.reportTapAction = {() in
            self.setupReportAlert()
        }
        
        cell.likeTapAction = {() in
            if feed.likeStatus == false {
                feed.likeStatus = true
            } else {
                feed.likeStatus = false
            }
            self.setLikeButtonState(button: cell.likeButton, feed: feed)
        }
        
        setLikeButtonState(button: cell.likeButton, feed: feed)
        
        cell.configure()
        return cell
    }
}
