//
//  MockedPersistenceServiceProvider.swift
//  HabitaraTests
//
//  Created by Sam Kheirandish on 2022-08-16.
//

import Foundation
import CoreData
import Combine
@testable import Habitara

class MockedPersistenceServiceProvider: PersistenceServiceProvider {
    
    init(){
        container = NSPersistentContainer(name: "Habitara")
        container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        items = PassthroughSubject<[Item], PersistenceError>()
        addSomeItems()
        assignPublisherForItems()
    }
    
    private func addSomeItems() {
        for _ in 0..<10 {
            let newItem = Item(context: container.viewContext)
            newItem.timestamp = Date()
        }
        do {
            try container.viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    var cancelables = Set<AnyCancellable>()
    func assignPublisherForItems() {
        CoreDataPublisher(request: Item.fetchRequest(), context: container.viewContext)
            .sink { result in
                switch result {
                case .failure(_):
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] in
                self?.items.send($0)
            }
            .store(in: &cancelables)
    }
    
    var container: NSPersistentContainer
    
    var items: PassthroughSubject<[Item], PersistenceError>
    
    func addItem(date: Date) {
        let newItem = Item(context: container.viewContext)
        newItem.timestamp = Date()
        do {
            try container.viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func delete(item: Item) {
        container.viewContext.delete(item)
        
        do {
            try container.viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}


class MockedPersistenceServiceProviderErrors: MockedPersistenceServiceProvider {
    override func assignPublisherForItems() {
        CoreDataPublisher(request: Item.fetchRequest(), context: container.viewContext)
            .sink { result in
                switch result {
                case .failure(_):
                    break
                case .finished:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.items.send(completion: .failure(.failedTogetAllItems))
            }
            .store(in: &cancelables)
    }
}
