//
//  DashboardViewModel.swift
//  Habitara
//
//  Created by Sam Kheirandish on 2022-08-08.
//

import Foundation
import Combine

protocol DashboardViewModelInteface: ViewModel {
    var items: [Item] { get }
    var error: DashboardViewModel.DashboardError? { get }
    func addNewItem()
    func deleteItem(index: IndexSet)
}

final class DashboardViewModel: DashboardViewModelInteface {
    
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
    
    enum DashboardError {
        case persistenceService
    }
    
    @Published private(set) var items = [Item]()
    @Published private(set) var error: DashboardError?
    
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
            .sink { [weak self] in
                switch $0 {
                case .failure:
                    self?.error = .persistenceService
                case .finished:
                    self?.error = nil
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
        index.compactMap { items[$0] }.forEach(services.presistence.delete(item:))
    }
}
