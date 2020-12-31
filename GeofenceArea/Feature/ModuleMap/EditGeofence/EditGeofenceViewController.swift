//
//  EditGeofenceViewController.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 12/30/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import UIKit
import MapKit

public protocol IEditGeofenceView: class {
    func updateUIWithModel(_ geofence: GeofenceModel)
}

public protocol EditGeofenceViewControllerDelegate: class {
    func tappedDoneEditViewController(coordinate: CLLocationCoordinate2D, radius: Double, wifiName: String)
}

class EditGeofenceViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var wifiNameTextField: UITextField!
    
    public weak var delegate: EditGeofenceViewControllerDelegate?
    private var presenter: EditGeofencePresenter!
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        hideKeyboardWhenTappedAround()
        setupLocation()
        
        presenter = EditGeofencePresenter(view: self, service: GeofenceAreaService())
        presenter.loadGeofence()
    }
    
    private func setupNavigation() {
        self.title = "Edit Geofence"
        let btnMyLocation = UIBarButtonItem(image: UIImage(named: "my_location_white"), style: .plain, target: self, action: #selector(tappedMyLocation))
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tappedDone))
        navigationItem.rightBarButtonItems = [btnDone, btnMyLocation]
        
        radiusTextField.delegate = self
        wifiNameTextField.delegate = self
    }
    
    private func setupLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
        mapView.zoomToUserLocation(locationManager, animated: false)
        
        DispatchQueue.main.async { [weak self] in
            self?.locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - Location Manager Delegate
extension EditGeofenceViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      switch status {
      case .authorizedAlways, .authorizedWhenInUse:
          mapView.showsUserLocation = true
//          mapView.zoomToUserLocation()
      case .denied, .restricted:
          self.presentAlert(title: "Need permission", message: "Please allow location access in Settings", actionTitle: "Go to Settings", actionHandler: { action in
              UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL)
          })
      default:
          break
      }
  }
    
}

// MARK: - Action
extension EditGeofenceViewController: UITextFieldDelegate {
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
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditGeofenceViewController: IEditGeofenceView {
    func updateUIWithModel(_ geofence: GeofenceModel) {
        radiusTextField.text = String(geofence.radius)
        wifiNameTextField.text = geofence.wifiName
        mapView.zoomToLocation(coordinate: geofence.coordinate)
    }
}
