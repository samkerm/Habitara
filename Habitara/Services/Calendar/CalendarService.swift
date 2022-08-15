//
//  CalendarService.swift
//  Habitara
//
//  Created by Sam Kheirandish on 2022-08-07.
//

// import CoreHabitara
import Foundation

protocol CalendarServiceProvider {
    /// The calendar to be used for displaying users agenda
    var calendar: AnyObject? { get set }
    /// Makes a calendar and assigns it for the *calendar*
    func makeCalendar()
}

extension Services {
    /// A service that provides all calendar needs
    final class Calendar: Service, CalendarServiceProvider, ObservableObject {
        /// A singleton providing the **Calendar** service to keep the service in memory
        static var provider: CalendarServiceProvider?
        
        // MARK: Service
        
        static func start() {
            Self.provider = Calendar()
        }
        
        static func end() {
            Self.provider = nil
        }
        
        static func mock(with service: CalendarServiceProvider) {
            Self.provider = service
        }
        
        private init() {}
        
        // MARK: CalendarServiceProvider
        
        var calendar: AnyObject?
        
        func makeCalendar() {
            //
        }
    }
}
