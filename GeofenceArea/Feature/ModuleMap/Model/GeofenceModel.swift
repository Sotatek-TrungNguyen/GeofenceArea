//
//  GeofenceModel.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 12/30/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import UIKit
import MapKit

public class GeofenceModel: NSObject, Codable, MKAnnotation {
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, radius, wifiName
    }
    
    public let coordinate: CLLocationCoordinate2D
    public let radius: CLLocationDistance
    public let wifiName: String
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, wifiName: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.wifiName = wifiName
    }
    
    // MARK: Codable
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try values.decode(Double.self, forKey: .latitude)
        let longitude = try values.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        radius = try values.decode(Double.self, forKey: .radius)
        wifiName = try values.decode(String.self, forKey: .wifiName)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(radius, forKey: .radius)
        try container.encode(wifiName, forKey: .wifiName)
    }
}

