//
//  HabitaraTests.swift
//  HabitaraTests
//
//  Created by Sam Kheirandish on 2022-08-06.
//

import XCTest
import Combine
@testable import Habitara

class DashboardTests: XCTestCase {
    
    private var testSubject: DashboardView<DashboardViewModel>!

    override func setUp() {
        super.setUp()
    }
    
    private func setUpTestSubjectForSuccess() {
        testSubject = DashboardView<DashboardViewModel>.make(
            dependencies: .init(),
            services: .init(presistence: MockedPersistenceServiceProvider())
        )
        hydrateItemsInViewModel()
    }
    
    private func setUpTestSubjectForFail() {
        testSubject = DashboardView<DashboardViewModel>.make(
            dependencies: .init(),
            services: .init(presistence: MockedPersistenceServiceProviderErrors())
        )
        hydrateErrorsInViewModel()
    }
    
    private func hydrateItemsInViewModel() {
        // Making sure the initial assignment of an empty array to items is not tracked
        let itemsPublisher = testSubject.viewModel.$items.dropFirst()
        _ = try? awaitPublisher(itemsPublisher)
    }
    
    private func hydrateErrorsInViewModel() {
        // Making sure the initial assignment of an empty array to items is not tracked
        let errorsPublisher = testSubject.viewModel.$error.dropFirst()
        _ = try? awaitPublisher(errorsPublisher)
    }
    
    
    func test_adding_an_item_adds_it_to_data_base() throws {
        setUpTestSubjectForSuccess()
        XCTAssertEqual(testSubject.viewModel.items.count, 10)
        let itemsPublisher = testSubject.viewModel.$items
        testSubject.viewModel.addNewItem()
        let items = try awaitPublisher(itemsPublisher)
        XCTAssertEqual(items.count, 11)
    }
    
    func test_deleting_an_item_deletes_it_from_data_base() throws {
        setUpTestSubjectForSuccess()
        XCTAssertEqual(testSubject.viewModel.items.count, 10)
        testSubject.viewModel.deleteItem(index: .init(integer: 0))
        var items = try awaitPublisher(testSubject.viewModel.$items)
        XCTAssertEqual(items.count, 9)
        testSubject.viewModel.deleteItem(index: .init(integer: 0))
        items = try awaitPublisher(testSubject.viewModel.$items)
        XCTAssertEqual(items.count, 8)
    }
    
    func test_adding_an_item_fails_with_error() throws {
        setUpTestSubjectForFail()
        let errorPublisher = testSubject.viewModel.$error
        testSubject.viewModel.addNewItem()
        let error = try awaitPublisher(errorPublisher)
        XCTAssertNotNil(error)
        XCTAssertEqual(error, .persistenceService)
    }
    
    func test_deleting_an_item_fails_with_error() throws {
        setUpTestSubjectForFail()
        let errorPublisher = testSubject.viewModel.$error
        testSubject.viewModel.addNewItem()
        let error = try awaitPublisher(errorPublisher)
        XCTAssertNotNil(error)
        XCTAssertEqual(error, .persistenceService)
    }
}

