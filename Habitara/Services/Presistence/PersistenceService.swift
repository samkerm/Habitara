//
//  PersistenceService.swift
//  Habitara
//
//  Created by Sam Kheirandish on 2022-08-06.
//

// import CoreHabitara
import CoreData
import Combine

enum PersistenceError: Error {
    case failedTogetAllItems
}

protocol PersistenceServiceProvider {
    var container: NSPersistentContainer { get set }
    var items: PassthroughSubject<[Item], PersistenceError> { get }
    func addItem(date: Date)
    func delete(item: Item)
}

extension Services {
    
    class Persistence: Service, PersistenceServiceProvider, ObservableObject {
                
        static var provider: PersistenceServiceProvider?
        
        // MARK: Service
        
        static func start() {
            Self.provider = Persistence()
        }
        
        static func end() {
            Self.provider = nil
        }
        
        static func mock(with service: PersistenceServiceProvider? = nil) {
            guard let service = service else {
                Self.provider = Persistence(inMemory: true)
                return
            }
            Self.provider = service
        }
        
        private init(inMemory: Bool = false) {
            container = NSPersistentContainer(name: "Habitara")
            if inMemory {
                container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            }
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
            container.viewContext.automaticallyMergesChangesFromParent = true
            assignPublisherForItems()
        }
        
        static var preview: Services.Persistence = {
            let result = Services.Persistence(inMemory: true)
            let viewContext = result.container.viewContext
            for _ in 0..<10 {
                let newItem = Item(context: viewContext)
                newItem.timestamp = Date()
            }
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            return result
        }()
                
        // MARK: PersistenceServiceProvider
        
        // MARK: Private
        
        private var cancelables = Set<AnyCancellable>()
        private func assignPublisherForItems() {
            CoreDataPublisher(request: Item.fetchRequest(), context: container.viewContext)
                .sink { [weak self] result in
                    switch result {
                    case .failure(_):
                        self?.items.send(completion: .failure(.failedTogetAllItems))
                    case .finished:
                        self?.items.send(completion: .finished)
                    }
                } receiveValue: { [weak self] in
                    self?.items.send($0)
                }
                .store(in: &cancelables)
        }
        
        // MARK: Internal
        
        var container: NSPersistentContainer
        var items = PassthroughSubject<[Item], PersistenceError>()
        
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
}
