//
//  ViewController.swift
//  GBFrameworks
//
//  Created by Vitaly Prosvetov on 28.05.2021.
//

import UIKit
import MapKit

class MainMapVC: UIViewController {
    let rootView = MainMapView()
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    let locationDistance: Double = 500
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupLocationManager()
        
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Private
    
    private func setupMapView() {
        
        rootView.mapView.delegate = self
        rootView.mapView.showsUserLocation = true
    }
    
    private func setupLocationManager() {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            handleAuthorizationStatus(locationManager: locationManager, status: locationManager.authorizationStatus)
        } else {
            //show alert
        }
    }
    
    private func centerViewToUserLocation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: locationDistance, longitudinalMeters: locationDistance)
        rootView.mapView.setRegion(region, animated: true)
    }
    
    private func pinAnnotationAtCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        let currentLocation = MKPointAnnotation()
        currentLocation.coordinate = coordinate
        rootView.mapView.addAnnotation(currentLocation)
    }
    
    private func handleAuthorizationStatus(locationManager: CLLocationManager, status: CLAuthorizationStatus) {
        switch status {
        
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            // show alert
            break
        case .authorizedWhenInUse:
            if let center = locationManager.location?.coordinate {
                centerViewToUserLocation(center: center)
            }
        default:
            break
        }
    }
}

// MARK: - Extension

extension MainMapVC: MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let coordinate = location.coordinate
        pinAnnotationAtCurrentLocation(coordinate)
        let center = location.coordinate
        centerViewToUserLocation(center: center)
    }
}

extension MainMapVC: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuthorizationStatus(locationManager: manager, status: manager.authorizationStatus)
    }
}

