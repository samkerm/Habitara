//
//  DashboardViewModel.swift
//  Habitara
//
//  Created by Sam Kheirandish on 2022-08-08.
//

import Foundation
import Combine

protocol DashboardViewModelInteface: ObservableObject {
    func addNewItem()
    func deleteItem(index: IndexSet)
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
    
    @Published public var items = [Item]()
    
    
    init(dependencies: Dependencies, services: Dependencies.Services) {
        self.dependencies = dependencies
        self.services = services
        bindItems()
    }
    
    private func bindItems() {
        services.presistence.items
            .map {
                $0.sorted(by: { $0.timestamp ?? Date() < $1.timestamp ?? Date() })
            }
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
        services.presistence.addItem(date: Date())
    }
    
    func deleteItem(index: IndexSet) {
        index.map { items[$0] }.forEach(services.presistence.delete(item:))
    }
}
