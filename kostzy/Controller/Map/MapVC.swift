//
//  MapVC.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    var previousLocation: CLLocation?
    var streetNumber = ""
    var streetName = ""
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
//        setupCancelButtonAttrs()
        
    }
//
//    private func setupCancelButtonAttrs() {
//        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain , target: self, action: #selector(dismissViewController))
//        navigationItem.leftBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
//    }
    
//    private func setupNavigationTitle() {
//        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
//        navigationItem.largeTitleDisplayMode,setupNavigationTitle()
//    }
        
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        print("Location Set Up")
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
            print("locatopn ada")
        }
        print("location gaada")
    }

//
//    @objc private func dismissViewController() {
//          self.dismiss(animated: true, completion: nil)
//      }
//

    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
            print("Enabled")
        } else {
            //show alert letting the user know they have to turn this on
            print("Service not enabled")
        }
}

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            print("authorized")
           startTrackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            print("Denird")
            break
        case .notDetermined:
            print("not determined")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
           print("Restricted")
            break
        case .authorizedAlways:
            print("Always")
            startTrackingUserLocation()
            break
         default:
            print("Default")
            break
        }
    }
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
        print("Hello")
    }
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToCreateSegue" {
            if let dest = segue.destination as? FeedsCreateVC {
                dest.locationString = streetName
            }
        }
    }
}

extension MapVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
        print("Location manager kepanggil")
    }
}
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else {
            print("prev location error")
            return
        }
        
        guard center.distance(from: previousLocation) > 50 else {
            print("distance location error")
            return
        }
        self.previousLocation = center
        
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
               print("Error")
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: show alert informing the user
                print("Error")
                return
            }
            print(placemark, "Map Place")
            self.streetNumber = placemark.subThoroughfare ?? ""
            self.streetName = placemark.thoroughfare ?? ""
        
            DispatchQueue.main.async {
                self.adressLabel.text = "\(self.streetNumber) \(self.streetName)"
            }
        }
    }
}
