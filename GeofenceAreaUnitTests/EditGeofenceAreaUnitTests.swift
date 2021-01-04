//
//  EditGeofenceAreaUnitTests.swift
//  GeofenceAreaUnitTests
//
//  Created by Nguyen Thanh Trung on 1/4/21.
//  Copyright © 2021 Nguyen Thanh Trung. All rights reserved.
//

import XCTest
import MapKit
@testable import GeofenceArea

class EditGeofenceAreaUnitTests: XCTestCase {
    
    var sut: IEditGeofencePresenter!
    
    override func setUp() {
        super.setUp()
        let service = GeofenceAreaService()
        sut = EditGeofencePresenter(service: service)
    }
    
    func testLoadGeofenceWhenNoData() {
        let model = sut.loadGeofence()
        XCTAssertNil(model)
    }
    
    func testLoadGeofenceWhenHaveData() {
        saveTestDemoGeofence()
        let model = sut.loadGeofence()
        XCTAssertNotNil(model)
    }
    
    override func tearDown() {
        resetUserDefaults()
        sut = nil
        super.tearDown()
    }
}

// MARK: - Init
extension EditGeofenceAreaUnitTests {
    private func createNewGeofence(radius: Double =  100.0, wifiName: String = "SotaTek") -> GeofenceModel {
        let coordinate = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)
        let geofence = GeofenceModel(coordinate: coordinate, radius: radius, wifiName: wifiName)
        return geofence
    }
    
    @discardableResult
    private func saveTestDemoGeofence() -> GeofenceModel {
        let service = GeofenceAreaService()
        let geofence = createNewGeofence()
        service.updateGeofence(geofence)
        return geofence
    }
    
    private func resetUserDefaults() {
        let userDefaults = UserDefaults.standard
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }
    }
}
