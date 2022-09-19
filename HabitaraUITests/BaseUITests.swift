//
//  BaseUITests.swift
//  HabitaraUITests
//
//  Created by Sam Kheirandish on 2022-09-14.
//

import XCTest

class BaseUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
}
