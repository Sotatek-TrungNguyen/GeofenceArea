//
//  CLAuthorizationStatus.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 12/30/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import Foundation
import CoreLocation

public extension CLAuthorizationStatus {
    var isAccessNotDetermined: Bool {
        switch self {
        case .notDetermined: return true
        default: return false
        }
    }
    
    var isAccessDenied: Bool {
        switch self {
        case .notDetermined: return false
        case .denied: return true
        default: return false
        }
    }
    
    var isAccessRestricted: Bool {
        switch self {
        case .notDetermined: return false
        case .restricted: return true
        default: return false
        }
    }
}
