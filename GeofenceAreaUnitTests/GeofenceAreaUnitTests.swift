//
//  GeofenceAreaUnitTests.swift
//  GeofenceAreaUnitTests
//
//  Created by Nguyen Thanh Trung on 12/31/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import XCTest
import MapKit
@testable import GeofenceArea

class GeofenceAreaUnitTests: XCTestCase {
    var sut: GeofenceAreaPresenter!

    override func setUp() {
        super.setUp()
        
        let service = GeofenceAreaService()
        sut = GeofenceAreaPresenter(service: service)
    }

    func testGetGeofenceWhenNoData() {
        let model = sut.getGeofence()
        XCTAssertNil(model)
    }
    
    func testGetGeofenceWhenHaveData() {
        let geofence = createNewGeofence()
        let service = GeofenceAreaService()
        service.updateGeofence(geofence)
        
        let model = sut.getGeofence()
        XCTAssertNotNil(model)
    }
    
    func testUpdateGeofence() {
        let service = GeofenceAreaService()
        // Setup data
        let oldModel = saveTestDemoGeofence()
        // Test update
        let geofence2 = createNewGeofence(radius: 200.0, wifiName: "blala")
        sut.updateGeofence(geofence2)
        let newModel = service.getGeofence()
        
        XCTAssertNotEqual(oldModel.wifiName, newModel?.wifiName)
        XCTAssertNotEqual(oldModel.radius, newModel?.radius)
    }
    
    func testIsMatchWifiName() {
        // Setup data
        let service = GeofenceAreaService()
        let geofence = createNewGeofence(wifiName: "SotaTek")
        service.updateGeofence(geofence)
        
        let wifiName = "SotaTek"
        let isMatch = sut.isMatchWifiName(geofence: geofence, currentWifiName: wifiName)
        XCTAssertTrue(isMatch)
    }
    
    func testIsNotMatchWifiName() {
        let service = GeofenceAreaService()
        let geofence = createNewGeofence(wifiName: "Hello123")
        service.updateGeofence(geofence)
        
        let wifiName = "SotaTek"
        let isMatch = sut.isMatchWifiName(geofence: geofence, currentWifiName: wifiName)
        XCTAssertFalse(isMatch)
    }
    
    func testIsInsideGeofenceCircle() {
        let service = GeofenceAreaService()
        let geofence = createNewGeofence(radius: 10000.0, wifiName: "SotaTek")
        service.updateGeofence(geofence)
        
        let coordinate = CLLocationCoordinate2D(latitude: 10.01, longitude: 10.01)
        let isInside = sut.isInsideGeofenceCircle(currentLocation: coordinate, geofence: geofence)
        XCTAssertTrue(isInside)
    }
    
    func testIsNotInsideGeofenceCircle() {
        let service = GeofenceAreaService()
        let geofence = createNewGeofence(radius: 10000.0, wifiName: "SotaTek")
        service.updateGeofence(geofence)
        
        let coordinate = CLLocationCoordinate2D(latitude: 10.02, longitude: 10.02)
        let isInside = sut.isInsideGeofenceCircle(currentLocation: coordinate, geofence: geofence)
        XCTAssertTrue(isInside)
    }
    
    override func tearDown() {
        resetUserDefaults()
        sut = nil
        super.tearDown()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

// MARK: - Init
extension GeofenceAreaUnitTests {
    private func createNewGeofence(radius: Double =  100.0, wifiName: String = "SotaTek") -> GeofenceModel {
        let coordinate = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)
        let geofence = GeofenceModel(coordinate: coordinate, radius: radius, wifiName: wifiName)
        return geofence
    }
    
    private func saveTestDemoGeofence() -> GeofenceModel {
        let service = GeofenceAreaService()
        let geofence = createNewGeofence()
        service.updateGeofence(geofence)
        return geofence
    }
    
    private func removeGeofence() {
        resetUserDefaults()
    }
    
    private func resetUserDefaults() {
        let userDefaults = UserDefaults.standard
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }
    }
}
