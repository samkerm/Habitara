//
//  HabitaraApp.swift
//  Habitara
//
//  Created by Sam Kheirandish on 2022-08-06.
//

import SwiftUI

@main
struct HabitaraApp: App {
    let persistenceService = PersistenceService.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceService.container.viewContext)
        }
    }
}

