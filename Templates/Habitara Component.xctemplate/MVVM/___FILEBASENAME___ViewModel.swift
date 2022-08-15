//
//  ___FILEHEADER___
//

import Foundation
import Combine

protocol ___VARIABLE_productName:identifier___ViewModelInteface: ViewModel {
    var property: [String] { get set }
    func method()
}

final class ___VARIABLE_productName:identifier___ViewModel: ___VARIABLE_productName:identifier___ViewModelInteface {
    
    // MARK: Private
    
    private let dependencies: Dependencies
    private let services: Dependencies.Services
    private var cancelables = Set<AnyCancellable>()
    
    // MARK: Public
    
    struct Dependencies {
        struct Services {
        }
    }
    
    @Published public var property = [String]()
    
    
    init(dependencies: Dependencies, services: Dependencies.Services) {
        self.dependencies = dependencies
        self.services = services
        bindItems()
    }
    
    private func bindItems() {
        /*
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
            */

    }
    
    func method() {
        
    }
}
