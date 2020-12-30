//
//  EditGeofenceViewController.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 12/30/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import UIKit
import MapKit

protocol EditGeofenceViewControllerDelegate: class {
    func tappedDoneEditViewController(coordinate: CLLocationCoordinate2D, radius: Double, wifiName: String)
}

class EditGeofenceViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var wifiNameTextField: UITextField!
    
    public weak var delegate: EditGeofenceViewControllerDelegate?
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupUI()
        hideKeyboardWhenTappedAround()
        setupLocation()
    }
    
    private func setupUI() {
        
    }
    
    private func setupNavigation() {
        self.title = "Edit Geofence"
        let btnMyLocation = UIBarButtonItem(image: UIImage(named: "my_location_white"), style: .plain, target: self, action: #selector(tappedMyLocation))
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tappedDone))
        navigationItem.rightBarButtonItems = [btnDone, btnMyLocation]
    }
    
    private func setupLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters:10000, longitudinalMeters: 10000)
            mapView.setRegion(viewRegion, animated: false)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - Location Manager Delegate
extension EditGeofenceViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    mapView.showsUserLocation = status == .authorizedAlways
  }
    
}

// MARK: - Action
extension EditGeofenceViewController {
    @objc func tappedMyLocation() {
        dismissKeyboard()
        mapView.zoomToUserLocation()
    }
    
    @objc func tappedDone() {
        dismissKeyboard()
        guard let wifiName = wifiNameTextField.text, let radiusText = radiusTextField.text, let radius = Double(radiusText) else {
            self.presentAlert(title: "Error", message: "Please input valid values!")
            return
        }
        
        let coordinate = mapView.centerCoordinate
        self.delegate?.tappedDoneEditViewController(coordinate: coordinate, radius: radius, wifiName: wifiName)
        self.navigationController?.popViewController(animated: true)
    }
}
