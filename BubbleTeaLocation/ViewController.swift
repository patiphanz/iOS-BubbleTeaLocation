//
//  ViewController.swift
//  BubbleTeaLocation
//
//  Created by Shoot Patiphan on 14/2/2562 BE.
//  Copyright © 2562 Patiphan Srisook. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        mapView.delegate = self
        
    }
    
    @IBAction func findAction(_ sender: Any) {
        Alamofire.request("https://api.foursquare.com/v2/venues/search?client_id=QUBFFE5U1ZB0BQKDVHQ1LRSUHIO1BUQAOJ3NBMY3J2HX02ZU&client_secret=F2SQ3T3WNPQHSHDERIYUFN4O3EUMBCITJXX2GRDYEGNZ1OUJ&v=20180323&limit=10&ll=\(locationManager.location?.coordinate.latitude ?? 0.0),\(locationManager.location?.coordinate.longitude ?? 0.0)&query=bubbletea").responseJSON(completionHandler: { res in
            
            guard let data = res.data else {
                return
            }
            let responseData = try?
                JSONDecoder().decode(JsonResponse.self, from: data)
            
//            print(responseData?.response.venues)
            let venues = responseData?.response.venues
            
            venues?.forEach{venue in
                let coordinate = CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lng)
                
                let marker = GMSMarker(position: coordinate)
                
                marker.map = self.mapView
                marker.title = venue.name
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? VenueDetailViewController
            let name = sender as? String
            vc?.name = name
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: 15)
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        performSegue(withIdentifier: "showDetail", sender: marker.title)
        return true
    }
}

