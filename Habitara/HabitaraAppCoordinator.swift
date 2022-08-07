//
//  HabitaraAppCoordinator.swift
//  Habitara
//
//  Created by Sam Kheirandish on 2022-08-07.
//

import SwiftUI
import Combine

struct HabitaraAppCoordinator {
    static let shared = HabitaraAppCoordinator()
    
    func getNotificationPublisher(for event: NotificationEvent) -> AnyPublisher<NotificationCenter.Publisher.Output, NotificationCenter.Publisher.Failure> {
        NotificationCenter.default
            .publisher(for: event.name)
            .eraseToAnyPublisher()
    }
    
    private init() {
        Services.Calendar.start()
        Services.Persistence.start()
    }
}

extension HabitaraAppCoordinator {
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
}
