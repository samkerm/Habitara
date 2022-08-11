//
//  HabitaraApp.swift
//  Habitara
//
//  Created by Sam Kheirandish on 2022-08-06.
//

import SwiftUI

@main
struct HabitaraApp: App {
    let appCoordinator = HabitaraAppCoordinator.shared
    
    init() {
        appCoordinator.startFundamentalServices()
    }
    
    var body: some Scene {
        WindowGroup {
            DashboardView.make(
                dependencies: .init(),
                services: .init(presistence: Services.Persistence.provider!))
                .environment(\.managedObjectContext, Services.Persistence.provider!.container.viewContext)
        }
    }
}

