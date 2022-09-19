//
//  DashboardUITests.swift
//  HabitaraUITests
//
//  Created by Sam Kheirandish on 2022-09-13.
//

import XCTest

class DashboardUITests: BaseUITests {

    lazy var storedItems = {
        app.cells.buttons[Id.Dashboard.storedTask]
    }()

    lazy var navigationBar = {
        app.navigationBars.firstMatch
    }()
    
    lazy var navigationTitle = {
        navigationBar.staticTexts.firstMatch.label
    }()
    
    lazy var addTaskButton = {
        navigationBar.buttons[Id.Dashboard.addTaskButton]
    }()
    
    lazy var editButton = {
        navigationBar.buttons[Id.Dashboard.editButton]
    }()
    
    lazy var editCellRemoveButtons = {
        app.cells.images.matching(identifier: .init(stringLiteral: "remove"))
    }()
    
    func testDashboardNavigation() {
        XCTAssertTrue(navigationBar.exists)
        XCTAssertEqual(navigationTitle, "Farshid's To Do list")
        XCTAssertTrue(addTaskButton.exists)
        XCTAssertTrue(editButton.exists)
        XCTAssertEqual(editButton.label, "Edit")
    }
    
    func testDashboardListItemsShow() {
        XCTAssert(app.cells.count == 10)
        XCTAssertTrue(storedItems.exists)
    }
    
    func testAddingAnItemAddsToList() {
        XCTAssert(app.cells.count == 10)
        addTaskButton.tap()
        XCTAssert(app.cells.count == 11)
    }
    
    func testEditButtonStartsEditingAndDeletesTasks() {
        XCTAssert(app.cells.count == 10)
        XCTAssertFalse(editCellRemoveButtons.firstMatch.exists)
        editButton.tap()
        XCTAssertEqual(editButton.label, "Done")
        XCTAssertTrue(editCellRemoveButtons.firstMatch.exists)
        XCTAssertTrue(editCellRemoveButtons.count == 10)
        editCellRemoveButtons.firstMatch.tap()
        XCTAssertTrue(app.buttons["Delete"].exists)
        app.buttons["Delete"].tap()
        XCTAssert(app.cells.count == 9)
    }
    
    func testTappingAnItemShowsANewScreen() {
        // MARK: TODO
        // fill in the blank
    }
}
