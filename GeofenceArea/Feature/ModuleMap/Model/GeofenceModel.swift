//
//  GeofenceModel.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 12/30/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import UIKit
import MapKit

class GeofenceModel: NSObject, Codable, MKAnnotation {
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, radius, wifiName
    }
    
    let coordinate: CLLocationCoordinate2D
    let radius: CLLocationDistance
    let wifiName: String
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, wifiName: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.wifiName = wifiName
    }
    
    // MARK: Codable
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try values.decode(Double.self, forKey: .latitude)
        let longitude = try values.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        radius = try values.decode(Double.self, forKey: .radius)
        wifiName = try values.decode(String.self, forKey: .wifiName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(radius, forKey: .radius)
        try container.encode(wifiName, forKey: .wifiName)
    }
    
    public class func getSavedGeofenceModel() -> GeofenceModel? {
        guard let savedData = UserDefaults.standard.data(forKey: Constant.UserDefaultKey.SAVED_GEOFENCE_KEY) else { return nil }
        let decoder = JSONDecoder()
        if let savedGeofence = try? decoder.decode(GeofenceModel.self, from: savedData) as GeofenceModel {
            return savedGeofence
        }
        return nil
    }
}

