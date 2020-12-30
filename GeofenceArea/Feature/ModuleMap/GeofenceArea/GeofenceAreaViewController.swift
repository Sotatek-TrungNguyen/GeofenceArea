//
//  GeofenceAreaViewController.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 12/30/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GeofenceAreaViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupUI()
        setupLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.showsUserLocation = true
    }
    
    private func setupUI() {
        mapView.delegate = self
    }
    
    private func setupNavigation() {
        self.title = "Geofence Area"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "my_location_white"), style: .plain, target: self, action: #selector(tappedMyLocation))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(tappedEdit))
    }
    
    private func setupLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(viewRegion, animated: false)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - MKMapViewDelegate
extension GeofenceAreaViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .purple
            circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    // MARK: Map overlay functions
    func addRadiusOverlay(forGeotification geotification: GeofenceModel) {
        mapView?.addOverlay(MKCircle(center: geotification.coordinate, radius: geotification.radius))
    }
    
    func removeRadiusOverlay(forGeotification geotification: GeofenceModel) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        guard let overlays = mapView?.overlays else { return }
        for overlay in overlays {
            guard let circleOverlay = overlay as? MKCircle else { continue }
            let coord = circleOverlay.coordinate
            if coord.latitude == geotification.coordinate.latitude && coord.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radius {
                mapView?.removeOverlay(circleOverlay)
                break
            }
        }
    }
}

// MARK: - Location Manager Delegate
extension GeofenceAreaViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
            mapView.zoomToUserLocation()
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            self.presentAlert(title: "Need permission", message: "Please allow location access in Settings", actionTitle: "Go to Settings", actionHandler: { action in
                UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            })
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    }
    
}

// MARK: - Action
extension GeofenceAreaViewController {
    
    @objc func tappedMyLocation() {
        mapView.zoomToUserLocation()
    }
    
    @objc func tappedEdit() {
        let vc = EditGeofenceViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension GeofenceAreaViewController: EditGeofenceViewControllerDelegate {
    func tappedDoneEditViewController(coordinate: CLLocationCoordinate2D, radius: Double, wifiName: String){
        let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
        let geotification = GeofenceModel(coordinate: coordinate, radius: clampedRadius, wifiName: wifiName)
        add(geotification)
    }
    
    private func add(_ geotification: GeofenceModel) {
        mapView.addAnnotation(geotification)
        addRadiusOverlay(forGeotification: geotification)
    }
}
