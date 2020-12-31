//
//  MapView+Extensions.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 12/30/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import MapKit

extension MKMapView {
    public func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        setRegion(region, animated: true)
    }
    
    public func zoomToUserLocation(_ locationManager: CLLocationManager, animated: Bool = true) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        setRegion(region, animated: animated)
    }
    
    public func zoomToLocation(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        setRegion(region, animated: true)
    }
    
    func addGeofence(geofence: GeofenceModel) {
        addOverlay(MKCircle(center: geofence.coordinate, radius: geofence.radius))
        addAnnotation(geofence)
    }
    
    public func removeAllGeofences() {
        removeAnnotations(annotations)
        removeOverlays(overlays)
    }
}
