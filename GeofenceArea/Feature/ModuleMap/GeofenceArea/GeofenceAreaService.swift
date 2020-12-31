//
//  GeofenceAreaService.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 12/31/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import Foundation

protocol IGeofenceAreaService {
    func getGeofence() -> GeofenceModel?
    func updateGeofence(_ geofence: GeofenceModel?)
}

public class GeofenceAreaService: IGeofenceAreaService {
    public func getGeofence() -> GeofenceModel?{
        return AppPreferences.instance.geofenceModel
    }
    
    public func updateGeofence(_ geofence: GeofenceModel?) {
        AppPreferences.instance.geofenceModel = geofence
    }
}
