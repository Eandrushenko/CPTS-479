//
//  MapViewController.swift
//  FoodApp
//
//  Created by Elijah Andrushenko on 3/25/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var MapLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var Mapfood : String = ""
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapLabel.text = Mapfood
        
        initializeLocation()
        //locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        // Do any additional setup after loading the view.
    }
    
    func initializeLocation() {
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startLocation()
        case .denied, .restricted:
            print("location not authorized")
            LocationUnavailable()
        case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func startLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        findFood()
    }
    
    func stopLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if ((status == .authorizedAlways) || (status == .authorizedWhenInUse)) {
            self.startLocation()
        }
        else {
            self.stopLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if let latitude = location?.coordinate.latitude {
            print("Latitude: \(latitude)")
        } else if let longitude = location?.coordinate.longitude {
            print("Longitude: \(longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager error: \(error.localizedDescription)")
    }
    
    
    func findFood() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = MapLabel.text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: searchHandler)
    }
    
    func searchHandler(response: MKLocalSearch.Response?, error: Error?) {
        if let err = error {
            print("Error occured in search: \(err.localizedDescription)")
        } else if let resp = response {
            print("\(resp.mapItems.count) matches found")
            self.mapView.removeAnnotations(self.mapView.annotations)
            for item in resp.mapItems {
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func LocationUnavailable() {
        let alert = UIAlertController(title: "Location Unavailable", message: "Authorize location services for this app in device settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
