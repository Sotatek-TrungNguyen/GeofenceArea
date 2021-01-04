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

public protocol IGeofenceAreaView: class {
    func updateGeofenceInMap(geofence: GeofenceModel?)
    func updateGeofenceStatus(geofence: GeofenceModel?)
    func startMonitoring(geofence: GeofenceModel?)
}

class GeofenceAreaViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var wifiNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    private var locationManager = CLLocationManager()
    private var presenter: IGeofenceAreaPresenter?
    
    init() {
        super.init(nibName: "GeofenceAreaViewController", bundle: nil)
    }
    
    init(presenter: IGeofenceAreaPresenter) {
        self.presenter = presenter
        super.init(nibName: "GeofenceAreaViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.onViewDidLoad(view: self)
        setupNavigation()
        setupUI()
        setupLocation()
        setupObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.showsUserLocation = true
    }
    
    private func setupUI() {
        mapView.delegate = self
        wifiNameLabel.text = ""
        statusLabel.text = ""
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
        mapView.zoomToUserLocation(locationManager, animated: false)
        
        DispatchQueue.main.async { [weak self] in
            self?.locationManager.startUpdatingLocation()
        }
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeWifi), name: NSNotification.Name(rawValue: Constant.NotificationKey.wifiChange), object: nil)
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
        presenter?.checkUpdateGeofenceStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        presenter?.checkUpdateGeofenceStatus()
    }
    
}

// MARK: - Action
extension GeofenceAreaViewController {
    
    @objc func tappedMyLocation() {
        mapView.zoomToUserLocation()
    }
    
    @objc func tappedEdit() {
        let service = GeofenceAreaService()
        let presenter = EditGeofencePresenter(service: service)
        let editVC = EditGeofenceViewController(presenter: presenter)
        editVC.delegate = self
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc func didChangeWifi() {
        presenter?.checkUpdateGeofenceStatus()
    }
}

// MARK: - EditGeofenceViewControllerDelegate
extension GeofenceAreaViewController: EditGeofenceViewControllerDelegate {
    func tappedDoneEditViewController(coordinate: CLLocationCoordinate2D, radius: Double, wifiName: String){
        let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
        let geofence = GeofenceModel(coordinate: coordinate, radius: clampedRadius, wifiName: wifiName)
        presenter?.updateGeofence(geofence)
    }
}

// MARK: - IGeofenceAreaView Method
extension GeofenceAreaViewController: IGeofenceAreaView {
    
    func startMonitoring(geofence: GeofenceModel?) {
        if let geofence = geofence, CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let region = CLCircularRegion(center: geofence.coordinate, radius: geofence.radius, identifier: geofence.wifiName)
            region.notifyOnExit = true
            region.notifyOnEntry = true
            locationManager.startMonitoring(for: region)
        }
    }
    
    func updateGeofenceInMap(geofence: GeofenceModel?) {
        guard let geofence = geofence else { return }
        
        wifiNameLabel.text = "Wifi connect:" + "\(geofence.wifiName)"
        mapView.removeAllGeofences()
        mapView.addGeofence(geofence: geofence)
        startMonitoring(geofence: geofence)
    }
    
    func updateGeofenceStatus(geofence: GeofenceModel?) {
        guard let geofence = geofence, let presenter = presenter else { return }
        let currentCoordinate = mapView.userLocation.coordinate
        let currentWifiName = presenter.getWiFiSsid() ?? ""
        
        let isInsideArea = presenter.isInsideGeofenceCircle(currentLocation: currentCoordinate, geofence: geofence) || presenter.isMatchWifiName(geofence: geofence, currentWifiName: currentWifiName)
        statusLabel.text = isInsideArea ? "Inside" : "Outside"
        statusLabel.textColor = isInsideArea ? .blue : .red
    }
    
}
