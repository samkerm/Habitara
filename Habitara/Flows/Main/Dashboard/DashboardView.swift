//
//  DashboardView.swift
//  Habitara
//
//  Created by Sam Kheirandish on 2022-08-06.
//

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject var viewModel: DashboardViewModel
        
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                   NavigationLink {
                       Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                   } label: {
                       Text("SAS at")
                       Text(item.timestamp!, formatter: itemFormatter)
                   }
               }
               .onDelete(perform: deleteItems)
            }
            .navigationTitle(Text("Farshid's To Do list"))
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
            Text("Select an item")
        }
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
extension DashboardView {
    static func make(dependencies: Dependencies, services: Services) -> DashboardView {
        DashboardView(viewModel: DashboardViewModel(dependencies: dependencies, services: services))
    }
}

fileprivate let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView.make(dependencies: .init(), services: .init(presistence: Services.Persistence.provider!))
            .environment(\.managedObjectContext, Services.Persistence.preview.container.viewContext)
    }
}
