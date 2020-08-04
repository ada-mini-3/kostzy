//
//  FeedsLocationVX.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit
import CoreLocation

class FeedsLocationVC: UIViewController {
    
    @IBOutlet weak var locationTableView: UITableView!
    
    @IBOutlet weak var segmentedLocation: UISegmentedControl!
    
    var selectedLocation : Location?
    
    @IBOutlet weak var buttonCurrentLocation: UIButton!
    
    fileprivate let locations : [Location] = Location.initData()
    
    fileprivate var filteredLocation = [Location]()
    
    let locationManager = CLLocationManager()
    
    var currentLocation: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCancelButtonAttrs()
        setupButtonLocation()
        filteredLocation = locations.filter { $0.type == .university }
        setupSegmentedControl()
        setupTableView()
        setupLocation()
    }
    
    private func setupButtonLocation() {
        if isDarkMode == true {
            buttonCurrentLocation.setTitleColor(UIColor.white, for: .normal)
            buttonCurrentLocation.setImage(UIImage(named: "current-dark"), for: .normal)
        } else {
            buttonCurrentLocation.setTitleColor(UIColor.black, for: .normal)
            buttonCurrentLocation.setImage(UIImage(named: "current-loc-light"), for: .normal)
        }
    }
    
    private func setupTableView() {
        locationTableView.dataSource = self
        locationTableView.delegate = self
        self.locationTableView.tableFooterView = UIView()
    }
    
    private func setupCancelButtonAttrs() {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain , target: self, action: #selector(dismissViewController))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func setupSegmentedControl() {
         let attrs = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        segmentedLocation.selectedSegmentTintColor = UIColor(red: 255.0/255, green: 184.0/255, blue: 0.0/255, alpha: 1)
        segmentedLocation.setTitleTextAttributes(attrs, for: .selected)
        if isDarkMode == true {
            segmentedLocation.backgroundColor = UIColor(red: 44/255, green: 45/255, blue: 47/255, alpha: 1)
        }
    }
    
    @objc private func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func changeLocationType(_ sender: UISegmentedControl) {
        setSegmentedData()
        locationTableView.reloadData()
    }
    
    @IBAction func currentLocationClicked(_ sender: Any) {
        selectedLocation = currentLocation
        shouldPerformSegue(withIdentifier: "unwindFeeds", sender: self)
    }
    
    
    private func setSegmentedData() {
        switch segmentedLocation.selectedSegmentIndex {
        case 0:
            filteredLocation = locations.filter {
                $0.type == .university
            }
        default:
            filteredLocation = locations.filter {
                $0.type == .area
            }
        }
    }
    
    private func setupLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func searchLocation(_ sender: UITextField) {
        setSegmentedData()
        if let text = sender.text {
            if sender.text == "" {
                setSegmentedData()
            } else {
                let temp = filteredLocation.filter {
                $0.name.lowercased().contains(text.lowercased())
                }
                filteredLocation = temp
            }
        }
        locationTableView.reloadData()
    }
}

extension FeedsLocationVC: CLLocationManagerDelegate {
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemark, error in
            completion(placemark?.first?.locality,
                       error)
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { city, error in
            guard let city = city, error == nil else { return }
            self.currentLocation = Location(name: city, type: .area, lat: location.coordinate.latitude, long: location.coordinate.longitude)
        }
    }
}

extension FeedsLocationVC : UITableViewDataSource, UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFeeds" {
            if let dest = segue.destination as? FeedsVC {
                dest.location = selectedLocation
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLocation = filteredLocation[indexPath.row]
        performSegue(withIdentifier: "unwindFeeds", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        cell.textLabel?.text = filteredLocation[indexPath.row].name
        return cell
    }
}
