//
//  DashboardView.swift
//  Habitara
//
//  Created by Sam Kheirandish on 2022-08-06.
//

import SwiftUI

struct DashboardView<VM>: HabitaraView where VM: DashboardViewModelInteface {
    
    @ObservedObject var viewModel: VM
        
    var body: some View {
        NavigationView {
            List {
                ForEach($viewModel.items) { item in
                   NavigationLink {
                       Text("Item at \(item.wrappedValue.timestamp!, formatter: itemFormatter)")
                   } label: {
                       Text("SAS at")
                       Text(item.wrappedValue.timestamp!, formatter: itemFormatter)
                   }
               }
               .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Farshid's To Do list")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }

    private func addItem() {
        withAnimation {
            viewModel.addNewItem()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            viewModel.deleteItem(index: offsets)
        }
    }
    
    typealias Dependencies = DashboardViewModel.Dependencies
    typealias Services = DashboardViewModel.Dependencies.Services
}

// MARK: Fileprivates

fileprivate let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

// MARK: Extensions

extension DashboardView {
    static func make(dependencies: Dependencies, services: Services) -> DashboardView {
        DashboardView(viewModel: DashboardViewModel(dependencies: dependencies, services: services) as! VM)
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView<DashboardViewModel>
            .make(dependencies: .init(), services: .init(presistence: Services.Persistence.provider!))
            .environment(\.managedObjectContext, Services.Persistence.preview.container.viewContext)
    }
}
