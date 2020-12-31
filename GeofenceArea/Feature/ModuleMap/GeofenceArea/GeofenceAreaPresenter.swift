//
//  GeofenceAreaPresenter.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 12/31/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import Foundation
import MapKit
import SystemConfiguration.CaptiveNetwork

public protocol IGeofenceAreaPresenter {
    
    func getGeofence() -> GeofenceModel?
    func updateGeofence(_ geofence: GeofenceModel?)
    func checkUpdateGeofenceStatus()
    
    func isInsideGeofenceCircle(currentLocation: CLLocationCoordinate2D, geofence: GeofenceModel?) -> Bool
    func isMatchWifiName(geofence: GeofenceModel) -> Bool
}

public class GeofenceAreaPresenter: IGeofenceAreaPresenter {
    
    private weak var view: IGeofenceAreaView?
    private let service: IGeofenceAreaService
    
    init(view: IGeofenceAreaView, service: IGeofenceAreaService) {
        self.view = view
        self.service = service
    }
    
    public func getGeofence() -> GeofenceModel? {
        return service.getGeofence()
    }
    
    public func updateGeofence(_ geofence: GeofenceModel?) {
        service.updateGeofence(geofence)
        self.view?.updateGeofenceInMap(geofence: geofence)
        self.view?.updateGeofenceStatus(geofence: geofence)
    }
    
    public func checkUpdateGeofenceStatus() {
        guard let geofence = service.getGeofence() else { return }
        self.view?.updateGeofenceStatus(geofence: geofence)
    }
    
    public func isInsideGeofenceCircle(currentLocation: CLLocationCoordinate2D, geofence: GeofenceModel?) -> Bool {
        guard let geofence = geofence else { return false }
        let region = CLCircularRegion(center: geofence.coordinate, radius: geofence.radius, identifier: geofence.description)
        return region.contains(currentLocation)
    }
    
    public func isMatchWifiName(geofence: GeofenceModel) -> Bool {
        let currentWifiName = getWiFiSsid()
        let wifiName = geofence.wifiName
        return !wifiName.isEmpty && currentWifiName == wifiName
    }
}

extension GeofenceAreaPresenter {
    
    /*
     Get WiFiSsid
     Source: https://github.com/HackingGate/iOS13-WiFi-Info
     */
    private func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
}
