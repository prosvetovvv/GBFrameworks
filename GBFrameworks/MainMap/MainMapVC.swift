//
//  ViewController.swift
//  GBFrameworks
//
//  Created by Vitaly Prosvetov on 28.05.2021.
//

import UIKit
import MapKit
import RealmSwift

class MainMapVC: UIViewController {
    let rootView = MainMapView()
    let locationManager = CLLocationManager()
    let locationDistance: Double = 500
    var coordinates = [CLLocationCoordinate2D]()
    var isRecording = false
    
    let realm = try! Realm()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupLocationManager()
        setupButtons()
    }
    
    // MARK: - Private
    
    private func setupMapView() {
        rootView.mapView.delegate = self
        rootView.mapView.showsUserLocation = true
    }
    
    private func setupLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            handleAuthorizationStatus(locationManager: locationManager, status: locationManager.authorizationStatus)
        } else {
            //show alert
        }
    }
    
    private func centerViewToUserLocation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: locationDistance, longitudinalMeters: locationDistance)
        rootView.mapView.setRegion(region, animated: true)
    }
    
    private func updateRoute() {
        removeRoute()
        addPolyLine()
    }
    
    private func addPolyLine() {
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        rootView.mapView.addOverlay(polyline)
    }
    
    private func removeRoute() {
        let oldPolyLineOverlay = rootView.mapView.overlays.filter { $0 is MKPolyline }
        rootView.mapView.removeOverlays(oldPolyLineOverlay)
    }
    
    private func saveRoutePoints() {
        coordinates.forEach {
            let location = Location(latitude: $0.latitude, longitude: $0.longitude)
            
            DBService.shared.save(location: location)
        }
    }
    
    private func removeRoutePoints() {
        DBService.shared.removeAllLocation()
    }
    
    private func handleAuthorizationStatus(locationManager: CLLocationManager, status: CLAuthorizationStatus) {
        switch status {
        
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        //locationManager.requestWhenInUseAuthorization()
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
    
    // MARK: - UI
    
    private func setupButtons() {
        rootView.routeButton.addTarget(self, action: #selector(tappedRoute), for: .touchUpInside)
        rootView.recordButton.addTarget(self, action: #selector(tappedRecord), for: .touchUpInside)
        rootView.stopButton.addTarget(self, action: #selector(tappedStop), for: .touchUpInside)
    }
    
    // MARK: - Objc
    
    @objc
    private func tappedRoute() {
        guard !isRecording else { return }

        let routePoints = DBService.shared.getLocation()
        
        coordinates = routePoints.map { $0.clLocationCoordinate2D }
        
        updateRoute()
        
        rootView.mapView.setVisibleMapRect(rootView.mapView.overlays.first!.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80, left: 20, bottom: 100, right: 20), animated: true)
    }
    
    @objc
    private func tappedRecord() {
        guard !isRecording else { return }
        
        isRecording = true
        coordinates = []
        
        removeRoute()
    
        locationManager.startUpdatingLocation()
        //locationManager.startMonitoringSignificantLocationChanges()
    }
    
    @objc
    private func tappedStop() {
        guard isRecording else { return }
        
        isRecording = false
        
        locationManager.stopUpdatingLocation()
        
        removeRoutePoints()
        
        saveRoutePoints()
        
        removeRoute()
    }
}

// MARK: - Extension

extension MainMapVC: MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let currentCoordinate = location.coordinate
        coordinates.append(currentCoordinate)
                
        centerViewToUserLocation(center: currentCoordinate)
        
        updateRoute()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 7
            return renderer
        }
        return MKOverlayRenderer()
    }
}

extension MainMapVC: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuthorizationStatus(locationManager: manager, status: manager.authorizationStatus)
    }
}

