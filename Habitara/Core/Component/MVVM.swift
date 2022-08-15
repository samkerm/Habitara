//
//  MVVM.swift
//  Habitara
//
//  Created by Sam Kheirandish on 2022-08-08.
//

import SwiftUI
import Combine

protocol HabitaraView: View {
    associatedtype VM: ViewModel
    var viewModel: VM { get set }
}

protocol ViewModel: ObservableObject {}

