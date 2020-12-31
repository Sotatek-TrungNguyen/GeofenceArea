//
//  AppPreferences.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 12/31/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import Foundation

class AppPreferences {
    enum Key: String {
        case geofenceModel = "kGeofenceModel"
    }
    
    public static let instance = AppPreferences()
    private let userDefaults: UserDefaults
    
    private init() {
        userDefaults = UserDefaults.standard
    }
    
    public var geofenceModel: GeofenceModel? {
        set {
            do {
                let encodedObject = try JSONEncoder().encode(newValue)
                userDefaults.set(encodedObject, forKey: Key.geofenceModel.rawValue)
                userDefaults.synchronize()
            } catch {
                print("Error save GeofenceModel")
            }
        }
        
        get {
            guard let savedData = userDefaults.data(forKey: Key.geofenceModel.rawValue) else { return nil }
            let decoder = JSONDecoder()
            if let savedGeofence = try? decoder.decode(GeofenceModel.self, from: savedData) as GeofenceModel {
                return savedGeofence
            }
            return nil
        }
    }
}
