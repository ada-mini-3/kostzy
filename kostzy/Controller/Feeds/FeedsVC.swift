//
//  FeedsVC.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit
import MapKit

class FeedsVC: UIViewController, MKMapViewDelegate {
    
    

    @IBOutlet weak var btnLocation: UIButton!
    
    @IBOutlet weak var segmentedCategory: UISegmentedControl!
    
    @IBOutlet weak var feedsCollectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var actityIndicator: UIActivityIndicatorView!
    
    var location : Location?
    var feeds = Feeds.initData().filter {
        $0.category == 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItem()
        setupSegmentedControl()
        setupButtonToLocation()
        setupRefreshControl()
        setupIndicator()
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
    
//    //Customizing the annotation
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = "MyMarker"
//
//        if annotation.isKind(of: MKUserLocation.self) {
//            return nil
//        }
//        //reuse the annotation if possible
//        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
//        if annotationView == nil {
//            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//        }
//
//        annotationView?.glyphImage = #imageLiteral(resourceName: "location-icon ")
//
//        return annotationView
//    }
    
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
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching New Feeds ...", attributes: nil)

    }
    
    @objc func refresh(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func setupNavigationBarItem() {
        let icon = UIImage(systemName: "plus.circle.fill")
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        let iconButton = UIButton(frame: iconSize)
        iconButton.setBackgroundImage(icon, for: .normal)
        let barButton = UIBarButtonItem(customView: iconButton)
        iconButton.addTarget(self, action: #selector(segueToCreateFeeds), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func segueToCreateFeeds() {
        performSegue(withIdentifier: "createFeedSegue", sender: self)
    }
    
    private func setupSegmentedControl() {
        segmentedCategory.selectedSegmentTintColor = UIColor(red: 255.0/255, green: 184.0/255, blue: 0.0/255, alpha: 1)
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
        segmentedCategory.setTitleTextAttributes(attrs, for: .selected)
        segmentedCategory.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }
    
    private func setupButtonToLocation() {
        btnLocation.contentHorizontalAlignment = .left
        if location != nil {
             btnLocation.setTitle(location?.name, for: .normal)
        }
    }
    
    @IBAction func unwindToFeeds(_ sender: UIStoryboardSegue) {
        setupButtonToLocation()
    }
    
    @IBAction func changeCategory(_ sender: UISegmentedControl) {
        changeSegmentedImage()
        filterFeedBasedOnCategory()
        feedsCollectionView.reloadData()
    }
    
    private func filterFeedBasedOnCategory() {
        var temp = Feeds.initData()
        switch segmentedCategory.selectedSegmentIndex {
        case 0:
            temp = temp.filter {
                $0.category == 1
            }
        default:
            temp = temp.filter {
                $0.category == 2
            }
        }
        feeds = temp
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

extension FeedsVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailFeedSegue" {
         if let dest = segue.destination as? FeedsDetailVC {
             dest.feeds = sender as? Feeds
         }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         performSegue(withIdentifier: "detailFeedSegue", sender: feeds[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        feeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedCell
        let feed = feeds[indexPath.row]
        cell.userName.text = feed.user.name
        cell.userImage.image = feed.user.image
        cell.feedLocation.setTitle(feed.location, for: .normal)
        cell.feed.text = feed.feed
        cell.tags = feed.tags
        cell.likeCount.text = "\(feed.likeCount) Likes"
        cell.commentCount.text = "\(feed.commentCount) Comments"
        cell.commentTapAction = {() in
            self.performSegue(withIdentifier: "detailFeedSegue", sender: self.feeds[indexPath.row])
        }
        cell.locationTapAction = {() in
            print("Location Clicked!!")
            self.openMapForPlace()
            
        }
        cell.configure()
        
        return cell
    }
    
 
}
