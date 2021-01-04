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
    
    private var locationManager = CLLocationManager()
    public weak var delegate: EditGeofenceViewControllerDelegate?
    private var presenter: IEditGeofencePresenter?
    
    init() {
        super.init(nibName: "EditGeofenceViewController", bundle: nil)
    }
    
    init(presenter: IEditGeofencePresenter) {
        self.presenter = presenter
        super.init(nibName: "EditGeofenceViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.onViewDidLoad(view: self)
        setupUI()
        setupNavigation()
        hideKeyboardWhenTappedAround()
        setupLocation()
        
        presenter?.loadGeofence()
    }
    
    private func setupUI() {
        radiusTextField.delegate = self
        wifiNameTextField.delegate = self
    }
    
    private func setupNavigation() {
        self.title = "Edit Geofence"
        let btnMyLocation = UIBarButtonItem(image: UIImage(named: "my_location_white"), style: .plain, target: self, action: #selector(tappedMyLocation))
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tappedDone))
        btnDone.isAccessibilityElement = true
        btnDone.accessibilityLabel = "Done"
        navigationItem.rightBarButtonItems = [btnDone, btnMyLocation]
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
        guard let wifiName = wifiNameTextField.text?.trimSpace(), let radiusText = radiusTextField.text, let radius = Double(radiusText) else {
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == wifiNameTextField {
            animateViewMoving(up: true, moveValue: 100)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == wifiNameTextField {
            animateViewMoving(up: false, moveValue: 100)
        }
    }
    
    private func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}

// MARK: - IEditGeofenceView Method
extension EditGeofenceViewController: IEditGeofenceView {
    func updateUIWithModel(_ geofence: GeofenceModel) {
        radiusTextField.text = String(geofence.radius)
        wifiNameTextField.text = geofence.wifiName
        mapView.zoomToLocation(coordinate: geofence.coordinate)
    }
}
