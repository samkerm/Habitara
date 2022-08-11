//
//  HabitaraAppCoordinator.swift
//  Habitara
//
//  Created by Sam Kheirandish on 2022-08-07.
//

import SwiftUI
import Combine

protocol HabitaraAppCoordinatorInterface {
    /// This method instantiates all fundamental services app needs to perform its function
    func startFundamentalServices()
    /// This method deallocates all fundamental services from memory
    func endAllServices()
    /// A publisher that publishes the app life cycle states.
    func getNotificationPublisher(for event: HabitaraAppCoordinator.NotificationEvent) -> AnyPublisher<NotificationCenter.Publisher.Output, NotificationCenter.Publisher.Failure>
}

/// This object manages app services and states
struct HabitaraAppCoordinator: HabitaraAppCoordinatorInterface {
    
    static let shared: HabitaraAppCoordinatorInterface = HabitaraAppCoordinator()
    
    enum NotificationEvent {
        case foreground
        case background
        case active
        case terminate
        
        var name: Notification.Name {
            switch self {
            case .foreground:
                return UIApplication.willEnterForegroundNotification
            case .background:
                return UIApplication.backgroundRefreshStatusDidChangeNotification
            case .active:
                return UIApplication.didBecomeActiveNotification
            case .terminate:
                return UIApplication.willTerminateNotification
            }
        }
    }
    
    private init() {}
    
    func getNotificationPublisher(for event: NotificationEvent) -> AnyPublisher<NotificationCenter.Publisher.Output, NotificationCenter.Publisher.Failure> {
        NotificationCenter.default
            .publisher(for: event.name)
            .eraseToAnyPublisher()
    }
    
    func startFundamentalServices() {
        Services.Calendar.start()
        Services.Persistence.start()
    }
    
    func endAllServices() {
        Services.Calendar.end()
        Services.Persistence.end()
    }
}
