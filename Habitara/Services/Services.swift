//
//  Services.swift
//  Habitara
//
//  Created by Sam Kheirandish on 2022-08-07.
//

protocol Service {
    /// Services interface to be used for mocking the service for tests
    associatedtype ServiceType
    /// Allocates service in the memory
    static func start()
    /// Dealocates service from memory
    static func end()
    /// Mocks a service with an object with matching interface
    static func mock(with service: ServiceType)
}
/// Name space used for all services in the app
enum Services {}
