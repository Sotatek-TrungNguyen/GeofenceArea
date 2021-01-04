//
//  GeofenceAreaUITests.swift
//  GeofenceAreaUITests
//
//  Created by Nguyen Thanh Trung on 1/4/21.
//  Copyright © 2021 Nguyen Thanh Trung. All rights reserved.
//

import XCTest

class GeofenceAreaUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMoveToEditScreen() {
        app.navigationBars["Geofence Area"].buttons["EditButton"].tap()
        XCTAssert(app.navigationBars["Edit Geofence"].exists)
    }
    
    func testBackToGeofenceScreen(){
        app.navigationBars["Geofence Area"].buttons["EditButton"].tap()
        sleep(1)
        app.navigationBars["Edit Geofence"].buttons["backButtonNavigation"].tap()
        
        XCTAssert(app.navigationBars["Geofence Area"].exists)
    }
    
    func testTapDoneInEditScreen() {
        let app = XCUIApplication()
        app.navigationBars["Geofence Area"].buttons["EditButton"].tap()
        app.textFields["wifiNameTextField"].clearAndEnterText(text: "SotaTek")
        app.navigationBars["Edit Geofence"].buttons["Done"].tap()
        
        let wifiNameLabel = app.staticTexts["wifiNameLabel"]
        let statusLabel = app.staticTexts["statusLabel"]
        
        XCTAssert(app.navigationBars["Geofence Area"].exists)
        XCTAssertTrue(wifiNameLabel.exists)
        XCTAssertTrue(statusLabel.exists)
        XCTAssertEqual("Wifi Name to connect:SotaTek", wifiNameLabel.label)
    }
    
    func testShowGeofenceInEditScreen() {
        let app = XCUIApplication()
        app.navigationBars["Geofence Area"].buttons["EditButton"].tap()
        
        let radiusTextField = app.textFields["radiusTextField"]
        let wifiNameTextField = app.textFields["wifiNameTextField"]
        
        radiusTextField.clearAndEnterText(text: "500")
        // Paste text to text field
        wifiNameTextField.tap()
        UIPasteboard.general.string = "SotaTek"
        wifiNameTextField.press(forDuration: 1.1)
        app.menuItems["Paste"].tap()
        
        sleep(1)
        app.navigationBars["Edit Geofence"].buttons["Done"].tap()
        sleep(1)
        let editButton = app.navigationBars["Geofence Area"].buttons["EditButton"]
        editButton.tap()
        sleep(1)
        
        XCTAssertTrue(radiusTextField.exists)
        XCTAssertTrue(wifiNameTextField.exists)
        XCTAssertEqual("SotaTek", wifiNameTextField.value as! String)
        XCTAssertEqual(Double("500"), Double(radiusTextField.value as! String))
    }
    
}

extension XCUIElement {
    /**
     Source: https://gist.github.com/Blackjacx/27d5610a02cb6c2550be3f69157c6a21
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    public func clearAndEnterText(text: String) {
        defer {
            self.typeText(text)
        }
        
        guard let stringValue = self.value as? String else {
            return
        }
        
        self.tap()
        
        let deleteString = stringValue.compactMap { _ in XCUIKeyboardKey.delete.rawValue }.joined()
        self.typeText(deleteString)
    }
    
}
