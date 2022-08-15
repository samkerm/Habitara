//
//  ___FILEHEADER___
//

// import CoreHabitara
import Foundation

/// A ___VARIABLE_productName:identifier___ service that performs something
protocol ___VARIABLE_productName:identifier___ServiceProvider {
    /// The property to be used for displaying data
    var property: AnyObject? { get set }
    /// Makes a property and assigns it for the *property*
    func method()
}

extension Services {
    /// A service that performs something
    final class ___VARIABLE_productName:identifier___: Service, ___VARIABLE_productName:identifier___ServiceProvider, ObservableObject {
        /// A singleton providing the **___VARIABLE_productName:identifier___** service to keep the service in memory
        static var provider: ___VARIABLE_productName:identifier___ServiceProvider?
        
        // MARK: Service
        
        static func start() {
            Self.provider = ___VARIABLE_productName:identifier___()
        }
        
        static func end() {
            Self.provider = nil
        }
        
        static func mock(with service: ___VARIABLE_productName:identifier___ServiceProvider) {
            Self.provider = service
        }
        
        private init() {}
        
        // MARK: ___VARIABLE_productName:identifier___ServiceProvider
        
        var property: AnyObject?
        
        func method() {}
    }
}

