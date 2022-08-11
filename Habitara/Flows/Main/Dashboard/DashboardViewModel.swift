//
//  DashboardViewModel.swift
//  Habitara
//
//  Created by Sam Kheirandish on 2022-08-08.
//

import Foundation
import Combine
import CoreData

protocol DashboardViewModelInteface: ObservableObject {
    func retrieveItems()
    func addNewItem()
}

final class DashboardViewModel: ViewModel, DashboardViewModelInteface {
    
    // MARK: Private
    
    private let dependencies: Dependencies
    private let services: Dependencies.Services
    private var cancelables = Set<AnyCancellable>()
    
    
    // MARK: Public
    
    struct Dependencies {
        struct Services {
            let presistence: PersistenceServiceProvider
        }
    }
    
    public let viewContext: NSManagedObjectContext
    @Published public var items = [Item]()
    
    
    init(dependencies: Dependencies, services: Dependencies.Services) {
        self.dependencies = dependencies
        self.services = services
        self.viewContext = services.presistence.container.viewContext
        retrieveItems()
    }
    
    func retrieveItems() {
        services.presistence.retrieveItems()
        services.presistence.items
            .sink {
                switch $0 {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] in
                self?.items = $0
            }
            .store(in: &cancelables)

    }
    
    func addNewItem() {
        let newItem = Item(context: viewContext)
        newItem.timestamp = Date()
        
        services.presistence.addItem(item: newItem)
    }
}
