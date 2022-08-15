//
//  ___FILEHEADER___
//

import SwiftUI

struct  ___VARIABLE_productName:identifier___View<VM>: HabitaraView where VM: ___VARIABLE_productName:identifier___ViewModelInteface {
    
    @ObservedObject var viewModel: VM
        
    var body: some View {
        Text("SAS Farshid")
    }

    typealias Dependencies = ___VARIABLE_productName:identifier___ViewModel.Dependencies
    typealias Services = ___VARIABLE_productName:identifier___ViewModel.Dependencies.Services
}

// MARK: Extensions

extension ___VARIABLE_productName:identifier___View {
    static func make(dependencies: Dependencies, services: Services) -> ___VARIABLE_productName:identifier___View {
        ___VARIABLE_productName:identifier___View(viewModel: ___VARIABLE_productName:identifier___ViewModel(dependencies: dependencies, services: services) as! VM)
    }
}

struct ___VARIABLE_productName:identifier___View_Previews: PreviewProvider {
    static var previews: some View {
        ___VARIABLE_productName:identifier___View<___VARIABLE_productName:identifier___ViewModel>
            .make(dependencies: .init(), services: .init())
    }
}